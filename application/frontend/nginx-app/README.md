# Nginx App: Static Website & Containerization

This folder contains the static website files and containerization instructions for the Nginx frontend. The image built here is compatible with both Docker and containerd.

## Structure
- `index.html`: Main landing page for the web UI.
- `style.css`: Stylesheet for the frontend.
- `script.js`: Optional JavaScript for interactivity.
- `nginx.conf`: Nginx configuration file (can be overridden by ConfigMap in Kubernetes).
- `Dockerfile`: Build instructions for the frontend image.

## Containerization
- **Dockerfile**: Builds an OCI-compliant image for use with Docker or containerd.

## How to Build & Push the Image
1. Build the image locally:
   ```sh
   docker build -t your-dockerhub-username/nginx-frontend:latest .
   ```
2. Push to Docker Hub (or your registry):
   ```sh
   docker push your-dockerhub-username/nginx-frontend:latest
   ```
3. (For containerd) Pull the image on your node:
   ```sh
   sudo ctr image pull docker.io/your-dockerhub-username/nginx-frontend:latest
   ```

## How to Run Locally (for testing)
```sh
docker run -p 8080:80 your-dockerhub-username/nginx-frontend:latest
```

## Notes
- The image built from this Dockerfile can be used with both Docker and containerd-based Kubernetes clusters.
- Update the image reference in your deployment manifest as needed.

**Next:** See [../README.md](../README.md) for deployment in Kubernetes.
