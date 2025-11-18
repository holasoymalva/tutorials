-- ============================================
-- FUNDAMENTOS DE SQL: INSERTAR DATOS (DML)
-- ============================================

-- DML (Data Manipulation Language) se usa para manipular los datos

-- ============================================
-- INSERT: Insertar datos en las tablas
-- ============================================

-- Forma 1: Especificar todas las columnas
INSERT INTO categorias (nombre, descripcion, activa)
VALUES ('Electrónica', 'Dispositivos electrónicos y accesorios', 1);

-- Forma 2: Sin especificar columnas (debe coincidir el orden)
-- No recomendado: menos legible y propenso a errores
INSERT INTO categorias VALUES (NULL, 'Ropa', 'Prendas de vestir', 1, datetime('now', 'localtime'));

-- Forma 3: Insertar múltiples registros a la vez (más eficiente)
INSERT INTO categorias (nombre, descripcion) VALUES
    ('Hogar', 'Artículos para el hogar'),
    ('Deportes', 'Equipamiento deportivo'),
    ('Libros', 'Libros y revistas'),
    ('Juguetes', 'Juguetes para niños'),
    ('Alimentos', 'Productos alimenticios');

-- ============================================
-- INSERTAR PRODUCTOS
-- ============================================

INSERT INTO productos (nombre, descripcion, precio, stock, categoria_id) VALUES
    ('Laptop HP', 'Laptop HP 15.6" Intel Core i5 8GB RAM', 12999.99, 15, 1),
    ('Mouse Inalámbrico', 'Mouse óptico inalámbrico 2.4GHz', 299.99, 50, 1),
    ('Teclado Mecánico', 'Teclado mecánico RGB retroiluminado', 899.99, 30, 1),
    ('Monitor 24"', 'Monitor LED Full HD 24 pulgadas', 2499.99, 20, 1),
    ('Camiseta Deportiva', 'Camiseta de algodón para deporte', 249.99, 100, 2),
    ('Pantalón Mezclilla', 'Pantalón de mezclilla azul', 599.99, 75, 2),
    ('Sofá 3 Plazas', 'Sofá moderno de 3 plazas', 8999.99, 5, 3),
    ('Lámpara de Mesa', 'Lámpara LED regulable', 449.99, 40, 3),
    ('Balón de Fútbol', 'Balón profesional tamaño 5', 399.99, 60, 4),
    ('Raqueta de Tenis', 'Raqueta profesional de grafito', 1299.99, 25, 4);

-- ============================================
-- INSERTAR CLIENTES
-- ============================================

INSERT INTO clientes (nombre, apellido, email, telefono, direccion, ciudad, codigo_postal) VALUES
    ('Juan', 'Pérez', 'juan.perez@email.com', '5551234567', 'Av. Reforma 123', 'Ciudad de México', '01000'),
    ('María', 'González', 'maria.gonzalez@email.com', '5552345678', 'Calle Juárez 456', 'Guadalajara', '44100'),
    ('Carlos', 'Rodríguez', 'carlos.rodriguez@email.com', '5553456789', 'Blvd. Díaz Ordaz 789', 'Monterrey', '64000'),
    ('Ana', 'Martínez', 'ana.martinez@email.com', '5554567890', 'Av. Universidad 321', 'Puebla', '72000'),
    ('Luis', 'Hernández', 'luis.hernandez@email.com', '5555678901', 'Calle Morelos 654', 'Querétaro', '76000');

-- ============================================
-- INSERT con SELECT (copiar datos de otra tabla)
-- ============================================

-- Crear tabla temporal para demostración
CREATE TEMP TABLE productos_descuento AS
SELECT id, nombre, precio, precio * 0.8 AS precio_descuento
FROM productos
WHERE categoria_id = 1;

-- ============================================
-- INSERT OR IGNORE (ignorar si viola restricción)
-- ============================================

-- Si el email ya existe, no hace nada (no genera error)
INSERT OR IGNORE INTO clientes (nombre, apellido, email, telefono)
VALUES ('Pedro', 'López', 'juan.perez@email.com', '5556789012');

-- ============================================
-- INSERT OR REPLACE (reemplazar si existe)
-- ============================================

-- Si existe un registro con el mismo PRIMARY KEY o UNIQUE, lo reemplaza
INSERT OR REPLACE INTO categorias (id, nombre, descripcion)
VALUES (1, 'Electrónica', 'Dispositivos electrónicos modernos');

-- ============================================
-- VERIFICAR DATOS INSERTADOS
-- ============================================

-- Ver todos los registros
SELECT * FROM categorias;
SELECT * FROM productos;
SELECT * FROM clientes;

-- Contar registros insertados
SELECT COUNT(*) AS total_categorias FROM categorias;
SELECT COUNT(*) AS total_productos FROM productos;
SELECT COUNT(*) AS total_clientes FROM clientes;

-- ============================================
-- CONCEPTOS CLAVE
-- ============================================

/*
1. INSERT INTO: Comando para insertar datos
   Sintaxis: INSERT INTO tabla (columnas) VALUES (valores);

2. Formas de INSERT:
   - Especificar columnas: Más legible y seguro
   - Sin especificar: Debe coincidir orden exacto
   - Múltiples registros: Más eficiente que múltiples INSERT

3. Valores especiales:
   - NULL: Valor nulo (si la columna lo permite)
   - DEFAULT: Usa el valor por defecto de la columna
   - datetime('now'): Fecha y hora actual

4. Variantes de INSERT:
   - INSERT OR IGNORE: No inserta si viola restricción
   - INSERT OR REPLACE: Reemplaza si existe
   - INSERT OR ABORT: Aborta transacción (por defecto)
   - INSERT OR FAIL: Falla pero continúa transacción
   - INSERT OR ROLLBACK: Revierte toda la transacción

5. INSERT con SELECT:
   - Copiar datos de una tabla a otra
   - Útil para migraciones o respaldos

6. Buenas prácticas:
   - Siempre especificar las columnas
   - Usar transacciones para múltiples INSERT
   - Validar datos antes de insertar
   - Usar INSERT múltiple para mejor rendimiento
*/
