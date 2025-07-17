# OpenBioCure Nginx

A production-ready nginx configuration with Docker support, maintenance mode capability, and Cloudflare integration for the OpenBioCure platform.

## 🏗️ Architecture

```
Internet → Cloudflare → nginx.lab → obc-platform.lab:3080
```

- **nginx.lab**: Reverse proxy with maintenance mode capability
- **obc-platform.lab**: Backend application server
- **Cloudflare**: CDN, DDoS protection, and SSL termination

## 📁 Project Structure

```
nginx/
├── nginx.conf                    # Main nginx configuration
├── conf.d/
│   ├── default.conf             # Production configuration
│   ├── default.conf.maintenance # Maintenance mode configuration
│   └── platform.conf            # Platform site configuration
├── static/
│   └── maintenance.html         # Maintenance page
├── assets/                      # Favicons and logo
│   ├── icon.png
│   ├── favicon.ico
│   ├── favicon-16x16.png
│   ├── favicon-32x32.png
│   ├── apple-touch-icon.png
│   ├── android-chrome-192x192.png
│   ├── android-chrome-512x512.png
│   └── site.webmanifest
├── docker/
│   └── Dockerfile               # Docker container definition
├── scripts/
│   ├── install-docker.sh        # Docker installation for AlmaLinux
│   └── deploy.sh                # Deployment script
├── docker-compose.yml           # Docker Compose configuration
├── Makefile                     # Management commands
├── .dockerignore                # Docker build exclusions
└── README.md                    # This file
```

## 🚀 Quick Start

### Prerequisites

- Docker and Docker Compose installed
- Git repository cloned

### Local Development

```bash
# Clone the repository
git clone <repository-url>
cd nginx

# Start the nginx container
make up

# Or use docker-compose directly
docker-compose up -d

# Check status
make status

# View logs
make logs
```

### Production Deployment

```bash
# Install Docker on AlmaLinux (server only)
make install-docker

# Full deployment
make deploy

# Or use the deployment script
./scripts/deploy.sh
```

## 🔧 Management Commands

### Using Makefile (Recommended)

```bash
# Show all available commands
make help

# Container management
make build          # Build container
make up             # Start container
make down           # Stop container
make restart        # Restart container
make logs           # View logs
make shell          # Access container shell

# Configuration
make reload         # Reload nginx configuration
make test           # Test nginx configuration
make health         # Check container health

# Development
make dev-up         # Start development mode
make dev-reload     # Reload for development

# 🔧 Maintenance Mode (NEW!)
make maintenance-on # Enable maintenance mode (takes site down)
make maintenance-off # Disable maintenance mode (brings site up)

# Utilities
make status         # Show container status
make clean          # Remove containers and images
make deploy         # Full deployment
```

### Using Docker Compose

```bash
# Start services
docker-compose up -d

# Stop services
docker-compose down

# View logs
docker-compose logs -f nginx

# Rebuild and start
docker-compose up -d --build

# Access container
docker-compose exec nginx sh
```

## 🔧 Maintenance Mode

The nginx configuration supports **one-click maintenance mode** switching using separate configuration files.

### Enable Maintenance Mode

```bash
# Take the site down for maintenance
make maintenance-on
```

This will:
- Switch to maintenance configuration
- Show maintenance page for all requests
- Return 503 status codes
- Keep health endpoint available

### Disable Maintenance Mode

```bash
# Bring the site back up
make maintenance-off
```

This will:
- Switch back to production configuration
- Resume normal proxy functionality
- Return to normal operation

### Maintenance Mode Features

- **Instant switching** - No manual file editing required
- **Clean separation** - Dedicated maintenance config file
- **Health monitoring** - Health endpoint still available
- **Asset serving** - Favicons and logo still accessible
- **Professional page** - OpenBioCure branded maintenance page

## 🌐 Configuration

### Server Configuration

- **Domain**: `nginx.lab`
- **Port**: 80
- **Backend**: `obc-platform.lab:3080`
- **Maintenance Page**: `/maintenance.html`

### Cloudflare Integration

The configuration includes Cloudflare-specific headers:
- `CF-Connecting-IP`: Real client IP
- `CF-IPCountry`: Visitor country
- `CF-Ray`: Request ID for debugging
- `CF-Visitor`: Visitor information

### Security Headers

- `X-Frame-Options`: SAMEORIGIN
- `X-Content-Type-Options`: nosniff
- `X-XSS-Protection`: 1; mode=block
- `Referrer-Policy`: strict-origin-when-cross-origin

## 🎨 Branding

The maintenance page uses OpenBioCure brand colors:
- **Deep Blue**: #00239c (Primary brand color)
- **Navy Blue**: #001e62 (Dark mode backgrounds)
- **Vibrant Orange**: #e76900 (Accent color)
- **Bright Cyan**: #00a3e0 (Secondary accent)

## 📊 Health Monitoring

- **Health Endpoint**: `http://nginx.lab/health`
- **Status**: Returns "OpenBioCure healthy" when running
- **Maintenance Status**: Returns "OpenBioCure - MAINTENANCE MODE" when in maintenance
- **Monitoring**: Docker health check included

## 🔍 Troubleshooting

### Common Issues

1. **Container won't start**
   ```bash
   # Check logs
   make logs
   
   # Test configuration
   make test
   ```

2. **Permission denied**
   ```bash
   # Check file permissions
   ls -la conf.d/ static/ assets/
   
   # Fix permissions if needed
   chmod 644 conf.d/* static/* assets/*
   ```

3. **Port already in use**
   ```bash
   # Check what's using port 80
   sudo lsof -i :80
   
   # Stop conflicting service
   sudo systemctl stop apache2  # or other service
   ```

### Debug Commands

```bash
# Check nginx configuration
make test

# View nginx error logs
docker-compose exec nginx tail -f /var/log/nginx/error.log

# Check container health
make health

# Access container for debugging
make shell
```

## 🚀 Deployment

### AlmaLinux Server

1. **Install Docker**:
   ```bash
   ./scripts/install-docker.sh
   ```

2. **Deploy**:
   ```bash
   ./scripts/deploy.sh
   ```

3. **Verify**:
   ```bash
   make status
   curl http://nginx.lab/health
   ```

### Docker Registry

```bash
# Build image
docker build -f docker/Dockerfile -t openbiocure/nginx:latest .

# Push to registry
docker push openbiocure/nginx:latest
```

## 📝 Development

### Adding New Configurations

1. Create new config file in `conf.d/`
2. Update `nginx.conf` if needed
3. Test configuration: `make test`
4. Reload: `make reload`

### Updating Maintenance Page

1. Edit `static/maintenance.html`
2. Reload nginx: `make reload`
3. Test: Visit the site

### Updating Assets

1. Replace files in `assets/`
2. Clear browser cache
3. Test: Check favicons and logo

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test with `make test`
5. Submit a pull request

## 📄 License

This project is part of the OpenBioCure platform.

## 🆘 Support

For support, contact: support@openbiocure.com
