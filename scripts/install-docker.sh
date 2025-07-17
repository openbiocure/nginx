#!/bin/bash

# Docker Installation Script for AlmaLinux
# This script installs Docker and Docker Compose

set -e  # Exit on any error

echo "🚀 Installing Docker on AlmaLinux..."

# Update system packages
echo "📦 Updating system packages..."
sudo dnf update -y

# Install required packages
echo "📦 Installing required packages..."
sudo dnf install -y dnf-utils device-mapper-persistent-data lvm2

# Add Docker repository
echo "📦 Adding Docker repository..."
sudo dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

# Install Docker
echo "🐳 Installing Docker..."
sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Start and enable Docker service
echo "🔧 Starting Docker service..."
sudo systemctl start docker
sudo systemctl enable docker

# Add current user to docker group
echo "👤 Adding user to docker group..."
sudo usermod -aG docker $USER

# Install Docker Compose (standalone version)
echo "📦 Installing Docker Compose..."
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Create symbolic link for docker-compose
sudo ln -sf /usr/local/bin/docker-compose /usr/bin/docker-compose

# Verify installation
echo "✅ Verifying installation..."
docker --version
docker-compose --version

echo ""
echo "🎉 Docker installation completed!"
echo ""
echo "⚠️  IMPORTANT: You need to log out and log back in for the docker group changes to take effect."
echo "   Or run: newgrp docker"
echo ""
echo "🔧 Useful commands:"
echo "   - Start Docker: sudo systemctl start docker"
echo "   - Stop Docker: sudo systemctl stop docker"
echo "   - Check status: sudo systemctl status docker"
echo "   - View logs: sudo journalctl -u docker"
echo ""
echo "🐳 Test Docker: docker run hello-world" 