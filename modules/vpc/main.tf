data "aws_availability_zones" "available" {
    state = "available"
}


#VPC
resource "aws_vpc" "main" {
    cidr_block = var.vpc_cidr

    enable_dns_support = true
    enable_dns_hostnames = true

    tags = {
        Name = "${var.env_name}-vpc"
    }
}

#Internet Gateway
resource "aws_internet_gateway" "igw_standard" {
    vpc_id = aws_vpc.main.id

    tags = {
        Name = "${var.env_name}-igw"
    }
}

#Public Subnets
resource "aws_subnet" "public_zone1" {
    vpc_id = aws_vpc.main.id
    cidr_block = cidrsubnet(var.vpc_cidr, 8, 1)
    availability_zone = data.aws_availability_zones.available.names[0]
    map_public_ip_on_launch = true

    tags = {
        "Name" = "${var.env_name}-public-${data.aws_availability_zones.available.names[0]}"
        "kubernetes.io/role/elb" = "1"
        "kubernetes.io/cluster/${var.env_name}-cluster" = "shared"
        }
}


resource "aws_subnet" "public_zone2" {
    vpc_id = aws_vpc.main.id
    cidr_block = cidrsubnet(var.vpc_cidr, 8, 2)
    availability_zone = data.aws_availability_zones.available.names[1]
    map_public_ip_on_launch = true

    tags = {
        "Name" = "${var.env_name}-public-${data.aws_availability_zones.available.names[1]}"
        "kubernetes.io/role/elb" = "1"
        "kubernetes.io/cluster/${var.env_name}-cluster" = "shared"
        }
}

#Private Subnets
resource "aws_subnet" "private_zone1" {
    vpc_id = aws_vpc.main.id
    cidr_block = cidrsubnet(var.vpc_cidr, 8, 11)
    availability_zone = data.aws_availability_zones.available.names[0]
    map_public_ip_on_launch = false

    tags = {
        "Name" = "${var.env_name}-private-${data.aws_availability_zones.available.names[0]}"
        "kubernetes.io/role/internal-elb" = "1"
        "kubernetes.io/cluster/${var.env_name}-cluster" = "shared"
        }
}


resource "aws_subnet" "private_zone2" {
    vpc_id = aws_vpc.main.id
    cidr_block = cidrsubnet(var.vpc_cidr, 8, 12)
    availability_zone = data.aws_availability_zones.available.names[1]
    map_public_ip_on_launch = false

    tags = {
        "Name" = "${var.env_name}-private-${data.aws_availability_zones.available.names[1]}"
        "kubernetes.io/role/internal-elb" = "1"
        "kubernetes.io/cluster/${var.env_name}-cluster" = "shared"
        }
}

#Public Route Table
resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw_standard.id
    }

    tags = {
        Name = "${var.env_name}-demo-public-rt"
    }
}


#Private Route Table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }

  tags = { Name = "${var.env_name}-private-rt" }
}

resource "aws_route_table_association" "public_zone1" {
    subnet_id = aws_subnet.public_zone1.id
    route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_zone2" {
    subnet_id = aws_subnet.public_zone2.id
    route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private_zone1" {
  subnet_id      = aws_subnet.private_zone1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_zone2" {
  subnet_id      = aws_subnet.private_zone2.id
  route_table_id = aws_route_table.private.id
}

#NAT Gateway
resource "aws_eip" "nat" {
    domain = "vpc"
    tags   = { Name = "${var.env_name}-nat-eip" }
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_zone1.id # Must be in a Public subnet!

  tags = { Name = "${var.env_name}-nat" }
}