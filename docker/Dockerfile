# Use official nginx image as base
FROM nginx:alpine

# Install any additional packages if needed
RUN apk add --no-cache curl

# Create necessary directories
RUN mkdir -p /etc/nginx/static /etc/nginx/assets

# Copy nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Copy server configuration
COPY conf.d/default.conf /etc/nginx/conf.d/default.conf

# Copy maintenance page
COPY static/maintenance.html /etc/nginx/static/maintenance.html

# Copy assets
COPY assets/ /etc/nginx/assets/

# Set proper permissions
RUN chown -R nginx:nginx /etc/nginx/static /etc/nginx/assets && \
    chmod -R 755 /etc/nginx/static /etc/nginx/assets

# Expose port 80
EXPOSE 80

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost/health || exit 1

# Start nginx
CMD ["nginx", "-g", "daemon off;"] 