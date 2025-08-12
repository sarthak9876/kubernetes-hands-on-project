import os
import socket
from flask import Flask, jsonify

app = Flask(__name__)

@app.route('/')
def hello():
    return f"Hello from Backend API Pod: {socket.gethostname()}\nDatabase: {os.getenv('DATABASE_HOST')}\nEnvironment: {os.getenv('ENVIRONMENT', 'unknown')}\n"

@app.route('/health')
def health():
    return jsonify({
        "status": "healthy",
        "pod": socket.gethostname(),
        "database_host": os.getenv('DATABASE_HOST'),
        "environment": os.getenv('ENVIRONMENT', 'unknown')
    })

@app.route('/config')
def config():
    return jsonify({
        "database_host": os.getenv('DATABASE_HOST'),
        "database_port": os.getenv('DATABASE_PORT'),
        "database_name": os.getenv('DATABASE_NAME'),
        "api_port": os.getenv('API_PORT'),
        "log_level": os.getenv('LOG_LEVEL'),
        "environment": os.getenv('ENVIRONMENT'),
        "pod_name": socket.gethostname()
    })

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)