"""
Script para inicializar la base de datos SQLite
Ejecutar este script antes de usar la aplicación por primera vez
"""
from app import app, db
from models import User

def init_database():
    """Inicializa la base de datos y crea las tablas"""
    with app.app_context():
        # Eliminar todas las tablas existentes (opcional, útil para desarrollo)
        db.drop_all()
        print("✓ Tablas anteriores eliminadas (si existían)")
        
        # Crear todas las tablas definidas en los modelos
        db.create_all()
        print("✓ Tablas creadas exitosamente")
        
        # Opcional: Agregar datos de ejemplo
        agregar_datos_ejemplo()

def agregar_datos_ejemplo():
    """Agrega algunos usuarios de ejemplo a la base de datos"""
    with app.app_context():
        # Verificar si ya existen usuarios
        if User.query.count() > 0:
            print("✓ La base de datos ya contiene usuarios")
            return
        
        # Crear usuarios de ejemplo
        usuarios_ejemplo = [
            User(name="Juan Pérez", email="juan@example.com"),
            User(name="María García", email="maria@example.com"),
            User(name="Carlos López", email="carlos@example.com")
        ]
        
        # Agregar a la sesión y guardar
        for usuario in usuarios_ejemplo:
            db.session.add(usuario)
        
        db.session.commit()
        print(f"✓ {len(usuarios_ejemplo)} usuarios de ejemplo agregados")

def mostrar_usuarios():
    """Muestra todos los usuarios en la base de datos"""
    with app.app_context():
        usuarios = User.query.all()
        print(f"\n📊 Total de usuarios en la base de datos: {len(usuarios)}")
        if usuarios:
            print("\nUsuarios registrados:")
            print("-" * 60)
            for usuario in usuarios:
                print(f"ID: {usuario.id} | Nombre: {usuario.name} | Email: {usuario.email}")
            print("-" * 60)

if __name__ == '__main__':
    print("🚀 Inicializando base de datos SQLite...\n")
    init_database()
    mostrar_usuarios()
    print("\n✅ Base de datos lista para usar!")
    print("💡 Ejecuta 'python app.py' para iniciar el servidor")
