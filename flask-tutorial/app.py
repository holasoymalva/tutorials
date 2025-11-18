from flask import Flask, request, jsonify
from flask_cors import CORS
from config import Config
from models import db, User

# Crear la aplicación Flask
app = Flask(__name__)

CORS(app)

# Cargar configuración
app.config.from_object(Config)

# Inicializar la base de datos con la aplicación
db.init_app(app)

# Crear las tablas en la base de datos
with app.app_context():
    db.create_all()


# ==================== RUTAS DE LA API ====================

@app.route('/')
def index():
    """Ruta principal - Información de la API"""
    return jsonify({
        'message': 'Bienvenido a la API REST con Flask',
        'version': '1.0',
        'endpoints': {
            'users': '/api/users',
            'user_detail': '/api/users/<id>'
        }
    })


@app.route('/api/users', methods=['GET'])
def get_users():
    """
    GET /api/users
    Obtiene todos los usuarios de la base de datos
    """
    try:
        users = User.query.all()
        return jsonify([user.to_dict() for user in users]), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500


@app.route('/api/users/<int:user_id>', methods=['GET'])
def get_user(user_id):
    """
    GET /api/users/<id>
    Obtiene un usuario específico por su ID
    """
    try:
        user = User.query.get(user_id)
        if user is None:
            return jsonify({'error': 'Usuario no encontrado'}), 404
        return jsonify(user.to_dict()), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500


@app.route('/api/users', methods=['POST'])
def create_user():
    """
    POST /api/users
    Crea un nuevo usuario
    Espera JSON: {"name": "Nombre", "email": "email@example.com"}
    """
    try:
        # Obtener datos del request
        data = request.get_json()
        
        # Validar que los datos requeridos estén presentes
        if not data or 'name' not in data or 'email' not in data:
            return jsonify({'error': 'Nombre y email son requeridos'}), 400
        
        # Verificar si el email ya existe
        existing_user = User.query.filter_by(email=data['email']).first()
        if existing_user:
            return jsonify({'error': 'El email ya está registrado'}), 400
        
        # Crear nuevo usuario
        new_user = User(
            name=data['name'],
            email=data['email']
        )
        
        # Guardar en la base de datos
        db.session.add(new_user)
        db.session.commit()
        
        return jsonify(new_user.to_dict()), 201
    
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500


@app.route('/api/users/<int:user_id>', methods=['PUT'])
def update_user(user_id):
    """
    PUT /api/users/<id>
    Actualiza un usuario existente
    Espera JSON: {"name": "Nuevo Nombre", "email": "nuevo@example.com"}
    """
    try:
        # Buscar el usuario
        user = User.query.get(user_id)
        if user is None:
            return jsonify({'error': 'Usuario no encontrado'}), 404
        
        # Obtener datos del request
        data = request.get_json()
        if not data:
            return jsonify({'error': 'No se proporcionaron datos'}), 400
        
        # Actualizar campos si están presentes
        if 'name' in data:
            user.name = data['name']
        
        if 'email' in data:
            # Verificar que el nuevo email no esté en uso por otro usuario
            existing_user = User.query.filter_by(email=data['email']).first()
            if existing_user and existing_user.id != user_id:
                return jsonify({'error': 'El email ya está registrado'}), 400
            user.email = data['email']
        
        # Guardar cambios
        db.session.commit()
        
        return jsonify(user.to_dict()), 200
    
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500


@app.route('/api/users/<int:user_id>', methods=['DELETE'])
def delete_user(user_id):
    """
    DELETE /api/users/<id>
    Elimina un usuario
    """
    try:
        # Buscar el usuario
        user = User.query.get(user_id)
        if user is None:
            return jsonify({'error': 'Usuario no encontrado'}), 404
        
        # Eliminar usuario
        db.session.delete(user)
        db.session.commit()
        
        return jsonify({'message': 'Usuario eliminado exitosamente'}), 200
    
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500


# ==================== MANEJO DE ERRORES ====================

@app.errorhandler(404)
def not_found(error):
    """Maneja errores 404 - Recurso no encontrado"""
    return jsonify({'error': 'Recurso no encontrado'}), 404


@app.errorhandler(500)
def internal_error(error):
    """Maneja errores 500 - Error interno del servidor"""
    db.session.rollback()
    return jsonify({'error': 'Error interno del servidor'}), 500


# ==================== EJECUTAR APLICACIÓN ====================

if __name__ == '__main__':
    # Ejecutar en modo debug (solo para desarrollo)
    app.run(debug=True, host='0.0.0.0', port=8000)
