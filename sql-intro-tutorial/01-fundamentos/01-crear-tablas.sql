-- ============================================
-- FUNDAMENTOS DE SQL: CREAR TABLAS (DDL)
-- ============================================

-- DDL (Data Definition Language) se usa para definir la estructura de la base de datos

-- Eliminar tablas si existen (para poder ejecutar el script múltiples veces)
DROP TABLE IF EXISTS clientes;
DROP TABLE IF EXISTS productos;
DROP TABLE IF EXISTS categorias;

-- ============================================
-- CREAR TABLA: CATEGORIAS
-- ============================================

CREATE TABLE categorias (
    id INTEGER PRIMARY KEY AUTOINCREMENT,  -- Clave primaria con auto-incremento
    nombre TEXT NOT NULL UNIQUE,           -- No permite nulos y debe ser único
    descripcion TEXT,                      -- Permite valores nulos
    activa INTEGER DEFAULT 1,              -- Valor por defecto: 1 (true)
    fecha_creacion TEXT DEFAULT (datetime('now', 'localtime'))  -- Fecha actual
);

-- ============================================
-- CREAR TABLA: PRODUCTOS
-- ============================================

CREATE TABLE productos (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre TEXT NOT NULL,
    descripcion TEXT,
    precio REAL NOT NULL CHECK(precio >= 0),  -- Restricción: precio no negativo
    stock INTEGER DEFAULT 0 CHECK(stock >= 0),
    categoria_id INTEGER,
    activo INTEGER DEFAULT 1,
    fecha_creacion TEXT DEFAULT (datetime('now', 'localtime')),
    
    -- Clave foránea: relaciona con la tabla categorias
    FOREIGN KEY (categoria_id) REFERENCES categorias(id)
        ON DELETE SET NULL  -- Si se elimina la categoría, se pone NULL
        ON UPDATE CASCADE   -- Si se actualiza el id, se actualiza aquí también
);

-- ============================================
-- CREAR TABLA: CLIENTES
-- ============================================

CREATE TABLE clientes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre TEXT NOT NULL,
    apellido TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,  -- Email único para cada cliente
    telefono TEXT,
    direccion TEXT,
    ciudad TEXT,
    pais TEXT DEFAULT 'México',
    codigo_postal TEXT,
    fecha_registro TEXT DEFAULT (datetime('now', 'localtime')),
    activo INTEGER DEFAULT 1,
    
    -- Restricción de tabla: validar formato de email básico
    CHECK (email LIKE '%@%.%')
);

-- ============================================
-- CREAR ÍNDICES
-- ============================================

-- Los índices mejoran el rendimiento de las búsquedas
CREATE INDEX idx_productos_nombre ON productos(nombre);
CREATE INDEX idx_clientes_email ON clientes(email);
CREATE INDEX idx_productos_categoria ON productos(categoria_id);

-- ============================================
-- VERIFICAR ESTRUCTURA
-- ============================================

-- Para ver las tablas creadas, ejecuta en SQLite:
-- .tables

-- Para ver el esquema de una tabla:
-- .schema clientes
-- .schema productos
-- .schema categorias

-- ============================================
-- CONCEPTOS CLAVE
-- ============================================

/*
1. PRIMARY KEY: Identifica únicamente cada registro
   - En SQLite, INTEGER PRIMARY KEY es alias de ROWID (más eficiente)
   - AUTOINCREMENT asegura que no se reutilicen IDs eliminados

2. NOT NULL: La columna no puede tener valores nulos

3. UNIQUE: No permite valores duplicados

4. DEFAULT: Valor por defecto si no se especifica

5. CHECK: Validación personalizada (ej: precio >= 0)

6. FOREIGN KEY: Relaciona tablas entre sí
   - ON DELETE: Qué hacer cuando se elimina el registro padre
     * CASCADE: Eliminar registros relacionados
     * SET NULL: Poner NULL en la clave foránea
     * RESTRICT: No permitir eliminación si hay relaciones
   - ON UPDATE: Qué hacer cuando se actualiza la clave

7. ÍNDICES: Estructuras que aceleran las búsquedas
   - Usar en columnas frecuentemente consultadas
   - No abusar: ralentizan INSERT/UPDATE
*/
