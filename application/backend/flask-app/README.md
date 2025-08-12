# Flask App: Source & Containerization

This folder contains the source code and containerization files for the Flask backend API. It supports both Docker and containerd (via Dockerfile and OCI-compliant images).

## Structure
- `app.py`: Main Flask application entry point.
- `requirements.txt`: Python dependencies for the app.
- `config.py`: Application configuration (non-sensitive).
- `Dockerfile`: Build instructions for Docker and containerd.

## Containerization
- **Dockerfile**: Used to build an OCI-compliant image, compatible with both Docker and containerd runtimes.
- **containerd**: Directly supports images built from the Dockerfile, as containerd uses the same OCI image format.

## How to Build & Push the Image
1. Build the image locally:
   ```sh
   docker build -t your-dockerhub-username/flask-api:latest .
   ```
2. Push to Docker Hub (or your registry):
   ```sh
   docker push your-dockerhub-username/flask-api:latest
   ```
3. (For containerd) Pull the image on your node:
   ```sh
   sudo ctr image pull docker.io/your-dockerhub-username/flask-api:latest
   ```

## How to Run Locally (for testing)
```sh
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
python app.py
```

## Notes
- The image built from this Dockerfile can be used with both Docker and containerd-based Kubernetes clusters.
- Update the image reference in your deployment manifest as needed.

**Next:** See [../README.md](../README.md) for deployment in Kubernetes.
