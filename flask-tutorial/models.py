from datetime import datetime
from flask_sqlalchemy import SQLAlchemy

# Inicializar SQLAlchemy
db = SQLAlchemy()

class User(db.Model):
    """
    Modelo de Usuario
    Representa la tabla 'user' en la base de datos
    """
    __tablename__ = 'user'
    
    # Columnas de la tabla
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)
    email = db.Column(db.String(120), unique=True, nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    
    def __repr__(self):
        """Representación en string del objeto User"""
        return f'<User {self.name}>'
    
    def to_dict(self):
        """
        Convierte el objeto User a un diccionario
        Útil para serializar a JSON
        """
        return {
            'id': self.id,
            'name': self.name,
            'email': self.email,
            'created_at': self.created_at.isoformat() if self.created_at else None
        }
