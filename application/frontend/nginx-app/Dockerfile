# Dockerfile: Build an OCI-compliant image for Nginx frontend
# Compatible with Docker and containerd

FROM nginx:1.21-alpine

# Copy static website files
COPY index.html /usr/share/nginx/html/index.html

# Copy default nginx.conf (can be overridden in Kubernetes)
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
