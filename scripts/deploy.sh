#!/bin/bash

# OpenBioCure Nginx Deployment Script
# This script deploys the nginx container with maintenance mode capability

set -e  # Exit on any error

echo "🚀 Deploying OpenBioCure Nginx..."

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker first."
    exit 1
fi

# Check if docker-compose is available
if ! command -v docker-compose &> /dev/null; then
    echo "❌ docker-compose is not installed. Please install it first."
    exit 1
fi

# Build and start the container
echo "🔨 Building and starting nginx container..."
docker-compose up -d --build

# Wait a moment for the container to start
sleep 3

# Check if container is running
if docker-compose ps | grep -q "Up"; then
    echo "✅ Container is running successfully!"
    
    # Test the health endpoint
    echo "🏥 Testing health endpoint..."
    if curl -f http://localhost/health > /dev/null 2>&1; then
        echo "✅ Health check passed!"
    else
        echo "⚠️  Health check failed, but container is running."
    fi
    
    echo ""
    echo "🎉 Deployment completed successfully!"
    echo ""
    echo "🔧 Useful commands:"
    echo "   - View logs: docker-compose logs -f nginx"
    echo "   - Stop: docker-compose down"
    echo "   - Restart: docker-compose restart nginx"
    echo "   - Reload nginx: docker-compose exec nginx nginx -s reload"
    echo "   - Access shell: docker-compose exec nginx sh"
    echo ""
    echo "🌐 Your nginx server should be available at: http://localhost"
    echo "🏥 Health check: http://localhost/health"
    
else
    echo "❌ Container failed to start. Check logs with: docker-compose logs nginx"
    exit 1
fi 