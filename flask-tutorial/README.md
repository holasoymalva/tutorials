# Fundamentos de Backend Development con Flask

## Introducción

Este proyecto es una guía práctica para aprender los fundamentos del desarrollo backend con Flask, un microframework de Python para crear aplicaciones web y APIs REST.

## ¿Qué es Flask?

Flask es un framework web minimalista y flexible para Python que permite crear aplicaciones web de manera rápida y sencilla. Es ideal para:
- Crear APIs REST
- Desarrollar aplicaciones web pequeñas y medianas
- Prototipar rápidamente
- Aprender desarrollo web backend

## Conceptos Fundamentales

### 1. API REST (Representational State Transfer)

Una API REST es un estilo de arquitectura para diseñar servicios web que utiliza:
- **HTTP Methods**: GET, POST, PUT, DELETE
- **Recursos**: Entidades que se manipulan (usuarios, productos, etc.)
- **Endpoints**: URLs que representan recursos
- **JSON**: Formato estándar para intercambio de datos
- **Stateless**: Cada petición es independiente

### 2. Métodos HTTP

- **GET**: Obtener recursos (lectura)
- **POST**: Crear nuevos recursos
- **PUT**: Actualizar recursos existentes
- **DELETE**: Eliminar recursos

### 3. Códigos de Estado HTTP

- **200 OK**: Petición exitosa
- **201 Created**: Recurso creado exitosamente
- **400 Bad Request**: Error en la petición del cliente
- **404 Not Found**: Recurso no encontrado
- **500 Internal Server Error**: Error del servidor

### 4. SQLite

SQLite es una base de datos relacional ligera que:
- **No requiere servidor separado**: Se ejecuta en el mismo proceso que la aplicación
- **Se almacena en un archivo único**: Todo en un solo archivo `.db`
- **Es perfecta para desarrollo**: Ideal para prototipos y aplicaciones pequeñas
- **Soporta SQL estándar**: Usa comandos SQL tradicionales
- **Zero-configuration**: No necesita instalación ni configuración adicional
- **Portátil**: El archivo de base de datos se puede copiar fácilmente

**¿Cómo funciona en este proyecto?**
1. Flask-SQLAlchemy maneja la conexión automáticamente
2. El archivo `app.db` se crea en la carpeta `instance/`
3. Las tablas se crean basándose en los modelos de Python
4. No necesitas escribir SQL manualmente (el ORM lo hace por ti)

### 5. ORM (Object-Relational Mapping)

Un ORM permite interactuar con la base de datos usando objetos de Python en lugar de SQL directo:
- **SQLAlchemy**: ORM más popular para Python
- **Modelos**: Clases que representan tablas
- **Migraciones**: Control de versiones de la base de datos

## Estructura del Proyecto

```
flask-intro/
├── app.py              # Aplicación principal con rutas de la API
├── models.py           # Modelos de base de datos (User)
├── config.py           # Configuración de Flask y SQLite
├── init_db.py          # Script para inicializar la base de datos
├── requirements.txt    # Dependencias del proyecto
├── .gitignore         # Archivos a ignorar en git
├── README.md          # Documentación (este archivo)
└── instance/          # Carpeta generada automáticamente
    └── app.db         # Base de datos SQLite
```

## Instalación y Configuración

### Requisitos Previos
- Python 3.7 o superior
- pip (gestor de paquetes de Python)

### Pasos de Instalación

1. **Crear entorno virtual** (recomendado):
```bash
python -m venv venv
source venv/bin/activate  # En Windows: venv\Scripts\activate
```

2. **Instalar dependencias**:
```bash
pip install -r requirements.txt
```

3. **Inicializar la base de datos SQLite**:
```bash
python init_db.py
```

Este script:
- Crea el archivo de base de datos `app.db` en la carpeta `instance/`
- Crea la tabla `user` con las columnas definidas en el modelo
- Agrega 3 usuarios de ejemplo para probar la API
- Muestra un resumen de los usuarios creados

4. **Ejecutar la aplicación**:
```bash
python app.py
```

La API estará disponible en `http://localhost:8000`

### Estructura de la Base de Datos

La base de datos SQLite se crea automáticamente en:
```
instance/app.db
```

**Tabla: user**
| Campo | Tipo | Descripción |
|-------|------|-------------|
| id | INTEGER | Clave primaria (autoincremental) |
| name | VARCHAR(100) | Nombre del usuario (requerido) |
| email | VARCHAR(120) | Email único (requerido) |
| created_at | DATETIME | Fecha de creación (automática) |

### Comandos Útiles para SQLite

Si quieres explorar la base de datos directamente:

```bash
# Abrir la base de datos con SQLite
sqlite3 instance/app.db

# Dentro de SQLite:
.tables                    # Ver todas las tablas
.schema user              # Ver estructura de la tabla user
SELECT * FROM user;       # Ver todos los usuarios
.exit                     # Salir
```

## Endpoints de la API

### Usuarios

#### 1. Obtener todos los usuarios
```http
GET /api/users
```

**Respuesta exitosa (200)**:
```json
[
  {
    "id": 1,
    "name": "Juan Pérez",
    "email": "juan@example.com",
    "created_at": "2024-01-15T10:30:00"
  }
]
```

#### 2. Obtener un usuario específico
```http
GET /api/users/<id>
```

**Respuesta exitosa (200)**:
```json
{
  "id": 1,
  "name": "Juan Pérez",
  "email": "juan@example.com",
  "created_at": "2024-01-15T10:30:00"
}
```

#### 3. Crear un nuevo usuario
```http
POST /api/users
Content-Type: application/json

{
  "name": "María García",
  "email": "maria@example.com"
}
```

**Respuesta exitosa (201)**:
```json
{
  "id": 2,
  "name": "María García",
  "email": "maria@example.com",
  "created_at": "2024-01-15T11:00:00"
}
```

#### 4. Actualizar un usuario
```http
PUT /api/users/<id>
Content-Type: application/json

{
  "name": "María García López",
  "email": "maria.garcia@example.com"
}
```

**Respuesta exitosa (200)**:
```json
{
  "id": 2,
  "name": "María García López",
  "email": "maria.garcia@example.com",
  "created_at": "2024-01-15T11:00:00"
}
```

#### 5. Eliminar un usuario
```http
DELETE /api/users/<id>
```

**Respuesta exitosa (200)**:
```json
{
  "message": "Usuario eliminado exitosamente"
}
```

## Tutorial: Cómo Desarrollar Este Proyecto Paso a Paso

Esta sección te guía para construir el proyecto desde cero, entendiendo cada componente.

### Paso 1: Configurar el Entorno

**1.1 Crear la carpeta del proyecto**
```bash
mkdir flask-intro
cd flask-intro
```

**1.2 Crear entorno virtual**
```bash
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate
```

**1.3 Instalar Flask y SQLAlchemy**
```bash
pip install Flask==3.0.0 Flask-SQLAlchemy==3.1.1
```

**1.4 Crear archivo requirements.txt**
```bash
pip freeze > requirements.txt
```

### Paso 2: Crear el Archivo de Configuración (config.py)

Crea `config.py` para centralizar la configuración:

```python
import os

class Config:
    """Configuración de la aplicación Flask"""
    SECRET_KEY = os.environ.get('SECRET_KEY') or 'dev-secret-key-change-in-production'
    SQLALCHEMY_DATABASE_URI = os.environ.get('DATABASE_URL') or 'sqlite:///app.db'
    SQLALCHEMY_TRACK_MODIFICATIONS = False
```

**¿Qué hace este archivo?**
- `SECRET_KEY`: Protege las sesiones y cookies
- `SQLALCHEMY_DATABASE_URI`: Define dónde se guarda la base de datos
- `SQLALCHEMY_TRACK_MODIFICATIONS`: Desactiva notificaciones innecesarias (mejora rendimiento)

### Paso 3: Crear el Modelo de Datos (models.py)

Crea `models.py` para definir la estructura de la base de datos:

```python
from datetime import datetime
from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

class User(db.Model):
    __tablename__ = 'user'
    
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)
    email = db.Column(db.String(120), unique=True, nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    
    def to_dict(self):
        return {
            'id': self.id,
            'name': self.name,
            'email': self.email,
            'created_at': self.created_at.isoformat() if self.created_at else None
        }
```

**Conceptos importantes:**
- `db.Model`: Clase base para todos los modelos
- `db.Column`: Define una columna en la tabla
- `primary_key=True`: Identificador único autoincremental
- `unique=True`: No permite valores duplicados
- `nullable=False`: Campo obligatorio
- `to_dict()`: Convierte el objeto a diccionario para JSON

### Paso 4: Crear la Aplicación Principal (app.py)

**4.1 Importar dependencias y configurar Flask**
```python
from flask import Flask, request, jsonify
from config import Config
from models import db, User

app = Flask(__name__)
app.config.from_object(Config)
db.init_app(app)

with app.app_context():
    db.create_all()
```

**4.2 Crear endpoint GET para listar usuarios**
```python
@app.route('/api/users', methods=['GET'])
def get_users():
    try:
        users = User.query.all()
        return jsonify([user.to_dict() for user in users]), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500
```

**4.3 Crear endpoint GET para un usuario específico**
```python
@app.route('/api/users/<int:user_id>', methods=['GET'])
def get_user(user_id):
    try:
        user = User.query.get(user_id)
        if user is None:
            return jsonify({'error': 'Usuario no encontrado'}), 404
        return jsonify(user.to_dict()), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500
```

**4.4 Crear endpoint POST para crear usuarios**
```python
@app.route('/api/users', methods=['POST'])
def create_user():
    try:
        data = request.get_json()
        
        if not data or 'name' not in data or 'email' not in data:
            return jsonify({'error': 'Nombre y email son requeridos'}), 400
        
        existing_user = User.query.filter_by(email=data['email']).first()
        if existing_user:
            return jsonify({'error': 'El email ya está registrado'}), 400
        
        new_user = User(name=data['name'], email=data['email'])
        db.session.add(new_user)
        db.session.commit()
        
        return jsonify(new_user.to_dict()), 201
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500
```

**4.5 Crear endpoint PUT para actualizar usuarios**
```python
@app.route('/api/users/<int:user_id>', methods=['PUT'])
def update_user(user_id):
    try:
        user = User.query.get(user_id)
        if user is None:
            return jsonify({'error': 'Usuario no encontrado'}), 404
        
        data = request.get_json()
        if not data:
            return jsonify({'error': 'No se proporcionaron datos'}), 400
        
        if 'name' in data:
            user.name = data['name']
        if 'email' in data:
            user.email = data['email']
        
        db.session.commit()
        return jsonify(user.to_dict()), 200
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500
```

**4.6 Crear endpoint DELETE para eliminar usuarios**
```python
@app.route('/api/users/<int:user_id>', methods=['DELETE'])
def delete_user(user_id):
    try:
        user = User.query.get(user_id)
        if user is None:
            return jsonify({'error': 'Usuario no encontrado'}), 404
        
        db.session.delete(user)
        db.session.commit()
        return jsonify({'message': 'Usuario eliminado exitosamente'}), 200
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500
```

**4.7 Agregar punto de entrada**
```python
if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=8000)
```

### Paso 5: Crear Script de Inicialización (init_db.py)

Crea `init_db.py` para configurar la base de datos fácilmente:

```python
from app import app, db
from models import User

def init_database():
    with app.app_context():
        db.drop_all()
        db.create_all()
        print("✓ Base de datos creada")
        
        # Agregar usuarios de ejemplo
        usuarios = [
            User(name="Juan Pérez", email="juan@example.com"),
            User(name="María García", email="maria@example.com"),
            User(name="Carlos López", email="carlos@example.com")
        ]
        
        for usuario in usuarios:
            db.session.add(usuario)
        db.session.commit()
        print(f"✓ {len(usuarios)} usuarios agregados")

if __name__ == '__main__':
    print("🚀 Inicializando base de datos...")
    init_database()
    print("✅ Base de datos lista!")
```

### Paso 6: Crear .gitignore

Crea `.gitignore` para no versionar archivos innecesarios:

```
__pycache__/
*.pyc
venv/
instance/
*.db
.env
```

### Paso 7: Probar la Aplicación

**7.1 Inicializar la base de datos**
```bash
python init_db.py
```

**7.2 Ejecutar el servidor**
```bash
python app.py
```

**7.3 Probar los endpoints**
```bash
# Listar usuarios
curl http://localhost:8000/api/users

# Crear usuario
curl -X POST http://localhost:8000/api/users \
  -H "Content-Type: application/json" \
  -d '{"name":"Ana Martínez","email":"ana@example.com"}'

# Obtener usuario específico
curl http://localhost:8000/api/users/1

# Actualizar usuario
curl -X PUT http://localhost:8000/api/users/1 \
  -H "Content-Type: application/json" \
  -d '{"name":"Juan Pérez Actualizado"}'

# Eliminar usuario
curl -X DELETE http://localhost:8000/api/users/1
```

### Conceptos Aprendidos en Cada Paso

**Paso 1-2**: Configuración de entorno y separación de concerns
**Paso 3**: ORM, modelos de datos, y serialización
**Paso 4**: Rutas, decoradores, métodos HTTP, y manejo de errores
**Paso 5**: Inicialización de base de datos y datos de prueba
**Paso 6**: Control de versiones y buenas prácticas
**Paso 7**: Testing y validación de la API

## Conceptos Clave del Código

### 1. Decoradores de Ruta
```python
@app.route('/api/users', methods=['GET'])
```
Define qué función se ejecuta cuando se accede a una URL específica.

### 2. Modelos SQLAlchemy
```python
class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)
```
Define la estructura de las tablas en la base de datos.

### 3. Serialización
Convertir objetos Python a JSON para enviar en las respuestas HTTP.

### 4. Manejo de Errores
Usar try-except para capturar y manejar errores de manera apropiada.

### 5. CRUD Operations
- **C**reate: POST
- **R**ead: GET
- **U**pdate: PUT
- **D**elete: DELETE

## Pruebas con cURL

### Crear un usuario
```bash
curl -X POST http://localhost:8000/api/users \
  -H "Content-Type: application/json" \
  -d '{"name":"Juan Pérez","email":"juan@example.com"}'
```

### Obtener todos los usuarios
```bash
curl http://localhost:8000/api/users
```

### Obtener un usuario específico
```bash
curl http://localhost:8000/api/users/1
```

### Actualizar un usuario
```bash
curl -X PUT http://localhost:8000/api/users/1 \
  -H "Content-Type: application/json" \
  -d '{"name":"Juan Pérez García","email":"juan.perez@example.com"}'
```

### Eliminar un usuario
```bash
curl -X DELETE http://localhost:8000/api/users/1
```

## Reiniciar la Base de Datos

Si necesitas reiniciar la base de datos desde cero:

```bash
# Opción 1: Ejecutar el script de inicialización (elimina y recrea todo)
python init_db.py

# Opción 2: Eliminar manualmente el archivo de base de datos
rm instance/app.db
python init_db.py
```

## Buenas Prácticas

1. **Usar entornos virtuales**: Aisla las dependencias del proyecto
2. **Validar datos de entrada**: Siempre verificar los datos recibidos
3. **Manejo de errores**: Capturar excepciones y devolver mensajes claros
4. **Códigos de estado apropiados**: Usar los códigos HTTP correctos
5. **Documentar la API**: Mantener documentación actualizada
6. **Separar configuración**: No hardcodear valores sensibles
7. **Usar variables de entorno**: Para configuración sensible en producción
8. **No versionar la base de datos**: El archivo `.db` debe estar en `.gitignore`

## Próximos Pasos

Para continuar aprendiendo, puedes:
1. Agregar autenticación con JWT
2. Implementar paginación en las listas
3. Agregar validación de datos con Flask-Marshmallow
4. Crear relaciones entre modelos (uno a muchos, muchos a muchos)
5. Implementar filtros y búsqueda
6. Agregar pruebas unitarias con pytest
7. Desplegar en un servidor de producción

## Recursos Adicionales

- [Documentación oficial de Flask](https://flask.palletsprojects.com/)
- [SQLAlchemy Documentation](https://docs.sqlalchemy.org/)
- [REST API Best Practices](https://restfulapi.net/)
- [HTTP Status Codes](https://httpstatuses.com/)

## Conclusión

Este proyecto cubre los fundamentos esenciales para desarrollar APIs REST con Flask. Has aprendido:
- Crear endpoints RESTful
- Conectar y manipular una base de datos SQLite
- Implementar operaciones CRUD
- Manejar peticiones y respuestas HTTP
- Estructurar un proyecto Flask básico

¡Felicidades por completar este tutorial! Ahora tienes las bases para crear tus propias aplicaciones backend con Flask.
