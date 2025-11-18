# Fundamentos de Backend Development con Node.js

Este proyecto es una guía práctica completa para aprender los fundamentos de desarrollo backend con Node.js, diseñado específicamente para prepararte para entrevistas de trabajo como Backend Developer Junior.

## 📚 Tabla de Contenidos

- [Conceptos Fundamentales](#conceptos-fundamentales)
- [Arquitectura del Proyecto](#arquitectura-del-proyecto)
- [Instalación y Configuración](#instalación-y-configuración)
- [Uso de la API](#uso-de-la-api)
- [Conceptos Clave para Entrevistas](#conceptos-clave-para-entrevistas)

---

## Conceptos Fundamentales

### 1. ¿Qué es Node.js?

Node.js es un entorno de ejecución de JavaScript del lado del servidor, construido sobre el motor V8 de Chrome. Permite ejecutar JavaScript fuera del navegador, lo que lo hace ideal para crear aplicaciones backend.

**Características principales:**
- **Asíncrono y basado en eventos**: No bloquea operaciones I/O
- **Single-threaded**: Usa un solo hilo con event loop
- **NPM**: Gestor de paquetes más grande del mundo
- **Multiplataforma**: Funciona en Windows, Linux y macOS

### 2. ¿Qué es una API REST?

REST (Representational State Transfer) es un estilo arquitectónico para diseñar servicios web. Una API REST usa métodos HTTP para realizar operaciones CRUD.

**Métodos HTTP principales:**
- `GET`: Obtener recursos
- `POST`: Crear nuevos recursos
- `PUT`: Actualizar recursos existentes
- `DELETE`: Eliminar recursos

**Códigos de estado HTTP importantes:**
- `200 OK`: Solicitud exitosa
- `201 Created`: Recurso creado exitosamente
- `400 Bad Request`: Error en la solicitud del cliente
- `404 Not Found`: Recurso no encontrado
- `500 Internal Server Error`: Error del servidor

### 3. Express.js

Express es el framework web más popular para Node.js. Simplifica la creación de servidores y APIs.

**Conceptos clave:**
- **Middleware**: Funciones que tienen acceso a req, res y next
- **Routing**: Sistema para manejar diferentes rutas y métodos HTTP
- **Request/Response**: Objetos que representan la petición y respuesta HTTP

### 4. Bases de Datos - SQLite

SQLite es una base de datos relacional ligera, perfecta para aprendizaje y proyectos pequeños.

**Conceptos SQL básicos:**
- **CREATE TABLE**: Crear tablas
- **INSERT**: Insertar datos
- **SELECT**: Consultar datos
- **UPDATE**: Actualizar datos
- **DELETE**: Eliminar datos
- **PRIMARY KEY**: Identificador único
- **FOREIGN KEY**: Relación entre tablas

---

## Arquitectura del Proyecto

Este proyecto sigue el patrón **MVC (Model-View-Controller)** adaptado para APIs:

```
nodejs-backend-fundamentals/
├── src/
│   ├── server.js              # Punto de entrada de la aplicación
│   ├── database/
│   │   ├── db.js              # Configuración de la base de datos
│   │   └── database.db        # Archivo SQLite (se crea automáticamente)
│   ├── models/
│   │   ├── User.js            # Modelo de datos de Usuario
│   │   └── Product.js         # Modelo de datos de Producto
│   ├── controllers/
│   │   ├── userController.js  # Lógica de negocio de usuarios
│   │   └── productController.js # Lógica de negocio de productos
│   └── routes/
│       ├── userRoutes.js      # Rutas de usuarios
│       └── productRoutes.js   # Rutas de productos
├── package.json
└── README.md
```

### Explicación de cada capa:

**1. Server (server.js)**
- Inicializa Express
- Configura middleware
- Registra rutas
- Inicia el servidor

**2. Routes (Rutas)**
- Define los endpoints de la API
- Conecta URLs con controladores
- Especifica métodos HTTP permitidos

**3. Controllers (Controladores)**
- Contiene la lógica de negocio
- Maneja validaciones
- Procesa requests y genera responses
- Maneja errores

**4. Models (Modelos)**
- Interactúa directamente con la base de datos
- Define operaciones CRUD
- Abstrae las consultas SQL

**5. Database (Base de datos)**
- Configura la conexión a SQLite
- Inicializa las tablas
- Gestiona el esquema de datos

---

## Instalación y Configuración

### Requisitos previos
- Node.js (versión 18 o superior)
- npm (viene con Node.js)

### Pasos de instalación

1. **Instalar dependencias:**
```bash
npm install
```

2. **Iniciar el servidor:**
```bash
npm start
```

3. **Modo desarrollo (con auto-reload):**
```bash
npm run dev
```

El servidor estará disponible en: `http://localhost:3000`

---

## Uso de la API

### Endpoints de Usuarios

#### 1. Obtener todos los usuarios
```bash
GET http://localhost:3000/api/users
```

**Respuesta:**
```json
[
  {
    "id": 1,
    "name": "Juan Pérez",
    "email": "juan@example.com",
    "created_at": "2024-01-15 10:30:00"
  }
]
```

#### 2. Obtener un usuario por ID
```bash
GET http://localhost:3000/api/users/1
```

#### 3. Crear un nuevo usuario
```bash
POST http://localhost:3000/api/users
Content-Type: application/json

{
  "name": "María García",
  "email": "maria@example.com"
}
```

#### 4. Actualizar un usuario
```bash
PUT http://localhost:3000/api/users/1
Content-Type: application/json

{
  "name": "Juan Pérez Actualizado",
  "email": "juan.nuevo@example.com"
}
```

#### 5. Eliminar un usuario
```bash
DELETE http://localhost:3000/api/users/1
```

### Endpoints de Productos

#### 1. Obtener todos los productos
```bash
GET http://localhost:3000/api/products
```

#### 2. Obtener un producto por ID
```bash
GET http://localhost:3000/api/products/1
```

#### 3. Crear un nuevo producto
```bash
POST http://localhost:3000/api/products
Content-Type: application/json

{
  "name": "Laptop",
  "description": "Laptop de alta gama",
  "price": 1299.99,
  "stock": 10
}
```

#### 4. Actualizar un producto
```bash
PUT http://localhost:3000/api/products/1
Content-Type: application/json

{
  "name": "Laptop Pro",
  "description": "Laptop profesional actualizada",
  "price": 1499.99,
  "stock": 5
}
```

#### 5. Eliminar un producto
```bash
DELETE http://localhost:3000/api/products/1
```

### Probar la API con cURL

```bash
# Crear un usuario
curl -X POST http://localhost:3000/api/users \
  -H "Content-Type: application/json" \
  -d '{"name":"Carlos López","email":"carlos@example.com"}'

# Obtener todos los usuarios
curl http://localhost:3000/api/users

# Crear un producto
curl -X POST http://localhost:3000/api/products \
  -H "Content-Type: application/json" \
  -d '{"name":"Mouse","description":"Mouse inalámbrico","price":29.99,"stock":50}'
```

---

## Conceptos Clave para Entrevistas

### 1. Event Loop en Node.js

El Event Loop es el mecanismo que permite a Node.js realizar operaciones no bloqueantes a pesar de que JavaScript es single-threaded.

**Fases del Event Loop:**
1. Timers (setTimeout, setInterval)
2. Pending callbacks
3. Idle, prepare
4. Poll (I/O operations)
5. Check (setImmediate)
6. Close callbacks

### 2. Middleware en Express

Los middleware son funciones que se ejecutan en el ciclo request-response.

```javascript
// Ejemplo de middleware personalizado
app.use((req, res, next) => {
  console.log(`${req.method} ${req.url}`);
  next(); // Pasa al siguiente middleware
});
```

**Tipos de middleware:**
- Application-level
- Router-level
- Error-handling
- Built-in (express.json(), express.static())
- Third-party

### 3. Promesas y Async/Await

Node.js maneja operaciones asíncronas con Promesas y async/await.

```javascript
// Con Promesas
function getData() {
  return new Promise((resolve, reject) => {
    // operación asíncrona
  });
}

// Con Async/Await
async function getData() {
  try {
    const result = await someAsyncOperation();
    return result;
  } catch (error) {
    console.error(error);
  }
}
```

### 4. Manejo de Errores

```javascript
// Try-catch para código síncrono y async/await
try {
  const result = await operation();
} catch (error) {
  console.error(error);
}

// Middleware de manejo de errores en Express
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ error: 'Error del servidor' });
});
```

### 5. Variables de Entorno

Usar variables de entorno para configuración sensible:

```javascript
const PORT = process.env.PORT || 3000;
const DB_URL = process.env.DATABASE_URL;
```

### 6. Módulos ES6 vs CommonJS

**ES6 Modules (usado en este proyecto):**
```javascript
import express from 'express';
export default router;
```

**CommonJS (tradicional):**
```javascript
const express = require('express');
module.exports = router;
```

### 7. Prepared Statements (Seguridad)

Este proyecto usa prepared statements para prevenir SQL injection:

```javascript
// ✅ SEGURO - Prepared statement
const stmt = db.prepare('SELECT * FROM users WHERE id = ?');
stmt.get(userId);

// ❌ INSEGURO - Concatenación directa
db.exec(`SELECT * FROM users WHERE id = ${userId}`);
```

### 8. Códigos de Estado HTTP

Conocer los códigos de estado es crucial:

- **2xx Success**: 200 OK, 201 Created, 204 No Content
- **3xx Redirection**: 301 Moved Permanently, 304 Not Modified
- **4xx Client Error**: 400 Bad Request, 401 Unauthorized, 403 Forbidden, 404 Not Found
- **5xx Server Error**: 500 Internal Server Error, 503 Service Unavailable

### 9. RESTful Best Practices

- Usar sustantivos para recursos: `/users`, `/products`
- Usar métodos HTTP correctamente
- Versionar la API: `/api/v1/users`
- Retornar códigos de estado apropiados
- Usar JSON como formato de datos
- Implementar paginación para listas grandes

### 10. Diferencias entre PUT y PATCH

- **PUT**: Reemplaza completamente el recurso
- **PATCH**: Actualiza parcialmente el recurso

---

## Preguntas Comunes de Entrevista

### Técnicas

**1. ¿Qué es Node.js y por qué es popular?**
- Entorno de ejecución JavaScript del lado del servidor
- Asíncrono y no bloqueante
- Gran ecosistema (NPM)
- Ideal para aplicaciones en tiempo real

**2. ¿Qué es el Event Loop?**
- Mecanismo que permite operaciones asíncronas
- Procesa callbacks de operaciones completadas
- Mantiene Node.js eficiente con un solo hilo

**3. ¿Qué es Express.js?**
- Framework web minimalista para Node.js
- Facilita creación de APIs y servidores web
- Sistema de routing y middleware robusto

**4. ¿Qué es middleware?**
- Funciones que procesan requests antes de llegar al handler final
- Tienen acceso a req, res y next
- Útiles para logging, autenticación, validación

**5. ¿Diferencia entre SQL y NoSQL?**
- **SQL**: Relacional, esquema fijo, ACID (SQLite, PostgreSQL, MySQL)
- **NoSQL**: No relacional, esquema flexible, escalabilidad horizontal (MongoDB, Redis)

### Prácticas

**6. ¿Cómo manejas errores en Node.js?**
- Try-catch para código síncrono y async/await
- Middleware de error en Express
- Listeners para eventos de error

**7. ¿Qué es CORS y cómo lo implementas?**
- Cross-Origin Resource Sharing
- Permite que APIs sean consumidas desde otros dominios
- Se implementa con headers o middleware como `cors`

**8. ¿Cómo aseguras una API?**
- Autenticación (JWT, OAuth)
- Validación de entrada
- Prepared statements (prevenir SQL injection)
- Rate limiting
- HTTPS
- Variables de entorno para secretos

**9. ¿Qué es npm?**
- Node Package Manager
- Gestor de dependencias de Node.js
- Repositorio de paquetes más grande del mundo

**10. ¿Diferencia entre dependencias y devDependencies?**
- **dependencies**: Necesarias en producción
- **devDependencies**: Solo para desarrollo (testing, linting)

---

## Próximos Pasos

Para profundizar tu conocimiento:

1. **Autenticación y Autorización**
   - Implementar JWT (JSON Web Tokens)
   - Sistema de login/registro
   - Middleware de autenticación

2. **Validación de Datos**
   - Usar librerías como Joi o express-validator
   - Validar tipos de datos y formatos

3. **Testing**
   - Unit tests con Jest
   - Integration tests con Supertest
   - Test coverage

4. **Documentación de API**
   - Swagger/OpenAPI
   - Postman Collections

5. **Deployment**
   - Variables de entorno con dotenv
   - Deploy en Heroku, Railway, o Render
   - Configurar CI/CD

6. **Base de Datos Avanzada**
   - Migraciones
   - Seeders
   - Relaciones entre tablas
   - Índices y optimización

7. **Mejores Prácticas**
   - Logging con Winston o Morgan
   - Rate limiting
   - Compresión de respuestas
   - CORS configuration
   - Helmet para seguridad

---

## Recursos Adicionales

- [Documentación oficial de Node.js](https://nodejs.org/docs/)
- [Documentación de Express](https://expressjs.com/)
- [MDN Web Docs - HTTP](https://developer.mozilla.org/es/docs/Web/HTTP)
- [SQLite Tutorial](https://www.sqlitetutorial.net/)

---

## Conclusión

Este proyecto cubre los fundamentos esenciales que necesitas dominar para una entrevista de Backend Developer Junior con Node.js:

✅ Configuración de un servidor con Express
✅ Creación de una API REST completa
✅ Operaciones CRUD con base de datos
✅ Arquitectura MVC
✅ Manejo de errores
✅ Mejores prácticas de código

Practica modificando y extendiendo este proyecto. Intenta agregar nuevas funcionalidades, implementar autenticación, o conectar con una base de datos diferente. ¡La práctica es la clave del éxito!

¡Buena suerte en tu entrevista! 🚀
