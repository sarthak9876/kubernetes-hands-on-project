# config.py
# Example configuration file for Flask app (non-sensitive)
import os

class Config:
    FLASK_ENV = os.environ.get('FLASK_ENV', 'production')
    API_FEATURE_FLAG = os.environ.get('API_FEATURE_FLAG', 'false')
    DB_HOST = os.environ.get('DATABASE_HOST', 'localhost')
    DB_PORT = os.environ.get('DATABASE_PORT', '3306')
    DB_USER = os.environ.get('DATABASE_USER', 'appuser')
    DB_PASSWORD = os.environ.get('DATABASE_PASSWORD', 'appuserpass')
    SECRET_KEY = os.environ.get('SECRET_KEY', 'supersecretkey')
