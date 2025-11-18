import os

class Config:
    """Configuración de la aplicación Flask"""
    
    # Clave secreta para sesiones (en producción usar variable de entorno)
    SECRET_KEY = os.environ.get('SECRET_KEY') or 'dev-secret-key-change-in-production'
    
    # Configuración de la base de datos SQLite
    SQLALCHEMY_DATABASE_URI = os.environ.get('DATABASE_URL') or 'sqlite:///app.db'
    
    # Desactivar el sistema de señales de SQLAlchemy (mejora rendimiento)
    SQLALCHEMY_TRACK_MODIFICATIONS = False
