import React, { useEffect, useRef } from 'react';
import * as THREE from 'three';

export default function LoveTCS3D() {
  const containerRef = useRef(null);
  
  useEffect(() => {
    if (!containerRef.current) return;
    
    // Scene setup
    const scene = new THREE.Scene();
    scene.background = new THREE.Color(0x0a0a1a);
    
    const camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 1000);
    camera.position.z = 15;
    
    const renderer = new THREE.WebGLRenderer({ antialias: true });
    renderer.setSize(window.innerWidth, window.innerHeight);
    containerRef.current.appendChild(renderer.domElement);
    
    // Lighting
    const ambientLight = new THREE.AmbientLight(0xffffff, 0.8);
    scene.add(ambientLight);
    
    const directionalLight = new THREE.DirectionalLight(0xffffff, 0.6);
    directionalLight.position.set(5, 10, 7.5);
    scene.add(directionalLight);
    
    // Create 3D text - just the characters, no boxes
    const letters = 'LOVETCS'.split('');
    const textMeshes = [];
    const spacing = 2.5;
    const startX = -(letters.length - 1) * spacing / 2;
    
    letters.forEach((letter, i) => {
      // Create text texture
      const canvas = document.createElement('canvas');
      canvas.width = 256;
      canvas.height = 256;
      const ctx = canvas.getContext('2d');
      ctx.fillStyle = '#ffffff';
      ctx.font = 'bold 200px Arial';
      ctx.textAlign = 'center';
      ctx.textBaseline = 'middle';
      ctx.fillText(letter, 128, 128);
      
      const texture = new THREE.CanvasTexture(canvas);
      const material = new THREE.MeshStandardMaterial({ 
        map: texture, 
        transparent: true,
        emissive: 0xffffff,
        emissiveIntensity: 0.3
      });
      const geometry = new THREE.PlaneGeometry(2, 2.5);
      const mesh = new THREE.Mesh(geometry, material);
      mesh.position.x = startX + i * spacing;
      mesh.userData = { 
        initialY: 0, 
        offset: i * 0.5,
        rotationSpeed: 0.008
      };
      scene.add(mesh);
      textMeshes.push(mesh);
    });
    
    // Add stars
    const starGeometry = new THREE.BufferGeometry();
    const starVertices = [];
    for (let i = 0; i < 2000; i++) {
      const x = (Math.random() - 0.5) * 100;
      const y = (Math.random() - 0.5) * 100;
      const z = (Math.random() - 0.5) * 100;
      starVertices.push(x, y, z);
    }
    starGeometry.setAttribute('position', new THREE.Float32BufferAttribute(starVertices, 3));
    const starMaterial = new THREE.PointsMaterial({ color: 0xffffff, size: 0.15 });
    const stars = new THREE.Points(starGeometry, starMaterial);
    scene.add(stars);
    
    // Animation
    let time = 0;
    const animate = () => {
      requestAnimationFrame(animate);
      time += 0.016;
      
      textMeshes.forEach((mesh) => {
        // Gentle floating motion
        mesh.position.y = mesh.userData.initialY + Math.sin(time * 1.5 + mesh.userData.offset) * 0.3;
        
        // Subtle rotation
        mesh.rotation.y = Math.sin(time * 0.5 + mesh.userData.offset) * 0.1;
      });
      
      // Rotate stars slowly
      stars.rotation.y += 0.0002;
      stars.rotation.x += 0.0001;
      
      renderer.render(scene, camera);
    };
    animate();
    
    // Handle resize
    const handleResize = () => {
      camera.aspect = window.innerWidth / window.innerHeight;
      camera.updateProjectionMatrix();
      renderer.setSize(window.innerWidth, window.innerHeight);
    };
    window.addEventListener('resize', handleResize);
    
    // Mouse interaction
    const handleMouseMove = (e) => {
      const x = (e.clientX / window.innerWidth) * 2 - 1;
      const y = -(e.clientY / window.innerHeight) * 2 + 1;
      camera.position.x = x * 1.5;
      camera.position.y = y * 1.5;
      camera.lookAt(0, 0, 0);
    };
    window.addEventListener('mousemove', handleMouseMove);
    
    // Cleanup
    return () => {
      window.removeEventListener('resize', handleResize);
      window.removeEventListener('mousemove', handleMouseMove);
      if (containerRef.current) {
        containerRef.current.removeChild(renderer.domElement);
      }
    };
  }, []);
  
  return (
    <div ref={containerRef} style={{ width: '100vw', height: '100vh', margin: 0, padding: 0, overflow: 'hidden' }} />
  );
}