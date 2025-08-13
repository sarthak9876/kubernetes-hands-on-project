# Dockerfile
# Build an OCI-compliant image for Flask API (works with Docker and containerd)

# Use official Python base image
FROM python:3.9-alpine

# Set working directory
WORKDIR /app

# Install dependencies
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY app.py ./
COPY config.py ./

# Expose port for Flask
EXPOSE 5000

# Set environment variables for production
ENV FLASK_ENV=production

# Run the Flask app
CMD ["python", "app.py"]
