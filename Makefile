# OpenBioCure Nginx Makefile
# Common tasks for building, deploying, and managing the nginx container

.PHONY: help build up down restart logs shell reload test clean install-docker deploy

# Default target
help:
	@echo "🚀 OpenBioCure Nginx Management"
	@echo ""
	@echo "Available commands:"
	@echo "  build        - Build the nginx container"
	@echo "  up           - Start the nginx container"
	@echo "  down         - Stop and remove the nginx container"
	@echo "  restart      - Restart the nginx container"
	@echo "  logs         - View nginx container logs"
	@echo "  shell        - Access nginx container shell"
	@echo "  reload       - Reload nginx configuration"
	@echo "  test         - Test nginx configuration"
	@echo "  health       - Check container health"
	@echo "  clean        - Remove containers and images"
	@echo "  install-docker - Install Docker on AlmaLinux (server only)"
	@echo "  deploy       - Full deployment (build + up + health check)"
	@echo ""

# Build the container
build:
	@echo "🔨 Building nginx container..."
	docker-compose build

# Start the container
up:
	@echo "🚀 Starting nginx container..."
	docker-compose up -d

# Stop and remove the container
down:
	@echo "🛑 Stopping nginx container..."
	docker-compose down

# Restart the container
restart:
	@echo "🔄 Restarting nginx container..."
	docker-compose restart nginx

# View logs
logs:
	@echo "📋 Viewing nginx logs..."
	docker-compose logs -f nginx

# Access container shell
shell:
	@echo "🐚 Accessing nginx container shell..."
	docker-compose exec nginx sh

# Reload nginx configuration
reload:
	@echo "🔄 Reloading nginx configuration..."
	docker-compose exec nginx nginx -s reload

# Test nginx configuration
test:
	@echo "🧪 Testing nginx configuration..."
	docker-compose exec nginx nginx -t

# Check container health
health:
	@echo "🏥 Checking container health..."
	@if curl -f http://localhost/health > /dev/null 2>&1; then \
		echo "✅ Health check passed!"; \
	else \
		echo "❌ Health check failed!"; \
		exit 1; \
	fi

# Clean up containers and images
clean:
	@echo "🧹 Cleaning up containers and images..."
	docker-compose down --rmi all --volumes --remove-orphans
	docker system prune -f

# Install Docker on AlmaLinux (server only)
install-docker:
	@echo "⚠️  This command is for AlmaLinux server only!"
	@echo "📦 Installing Docker..."
	@chmod +x scripts/install-docker.sh
	@./scripts/install-docker.sh

# Full deployment
deploy: build up
	@echo "⏳ Waiting for container to start..."
	@sleep 3
	@$(MAKE) health
	@echo "🎉 Deployment completed successfully!"
	@echo "🌐 Your nginx server is available at: http://localhost"
	@echo "🏥 Health check: http://localhost/health"

# Development helpers
dev-up: up
	@echo "🔧 Development mode started"
	@echo "📝 Edit files in conf.d/, static/, or assets/ and run 'make reload'"

dev-reload: reload
	@echo "🔄 Configuration reloaded"

# Maintenance mode helpers
maintenance-on:
	@echo "🔧 Enabling maintenance mode..."
	@echo "⚠️  Edit conf.d/default.conf and uncomment maintenance location block"
	@echo "   Then run: make reload"

maintenance-off:
	@echo "🔧 Disabling maintenance mode..."
	@echo "⚠️  Edit conf.d/default.conf and comment out maintenance location block"
	@echo "   Then run: make reload"

# Status check
status:
	@echo "📊 Container status:"
	@docker-compose ps
	@echo ""
	@echo "🔍 Nginx configuration test:"
	@docker-compose exec nginx nginx -t 2>/dev/null || echo "Container not running"
	@echo ""
	@echo "🏥 Health check:"
	@curl -f http://localhost/health > /dev/null 2>&1 && echo "✅ Healthy" || echo "❌ Unhealthy" 