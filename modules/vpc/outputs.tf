output "vpc_id" {
    value = aws_vpc.main.id
    description = "Inside of VPC"
}

output "private_subnet_ids" {
    value = [aws_subnet.private_zone1, aws_subnet.private_zone2]
    description = "List of private IDs"
}

output "public_subnet_ids" {
    value = [aws_subnet.public_zone1, aws_subnet.public_zone2]
    description = "List of public IDs"
}