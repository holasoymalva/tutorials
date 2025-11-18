-- ============================================
-- PROYECTO FINAL: SISTEMA DE GESTIÓN DE TIENDA
-- ============================================

-- Este script integra todos los conceptos aprendidos en un proyecto completo

PRAGMA foreign_keys = ON;

-- ============================================
-- 1. CREAR ESTRUCTURA COMPLETA
-- ============================================

-- Limpiar base de datos
DROP TABLE IF EXISTS detalle_pedidos;
DROP TABLE IF EXISTS pedidos;
DROP TABLE IF EXISTS productos_etiquetas;
DROP TABLE IF EXISTS etiquetas;
DROP TABLE IF EXISTS productos;
DROP TABLE IF EXISTS categorias;
DROP TABLE IF EXISTS clientes;
DROP TABLE IF EXISTS auditoria;

-- Tabla de categorías
CREATE TABLE categorias (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre TEXT NOT NULL UNIQUE,
    descripcion TEXT,
    activa INTEGER DEFAULT 1,
    fecha_creacion TEXT DEFAULT (datetime('now', 'localtime'))
);

-- Tabla de productos
CREATE TABLE productos (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre TEXT NOT NULL,
    descripcion TEXT,
    precio REAL NOT NULL CHECK(precio >= 0),
    costo REAL CHECK(costo >= 0),
    stock INTEGER DEFAULT 0 CHECK(stock >= 0),
    stock_minimo INTEGER DEFAULT 10,
    categoria_id INTEGER,
    activo INTEGER DEFAULT 1,
    fecha_creacion TEXT DEFAULT (datetime('now', 'localtime')),
    fecha_actualizacion TEXT DEFAULT (datetime('now', 'localtime')),
    
    FOREIGN KEY (categoria_id) REFERENCES categorias(id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

-- Tabla de clientes
CREATE TABLE clientes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre TEXT NOT NULL,
    apellido TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE CHECK (email LIKE '%@%.%'),
    telefono TEXT,
    direccion TEXT,
    ciudad TEXT,
    estado TEXT,
    pais TEXT DEFAULT 'México',
    codigo_postal TEXT,
    fecha_registro TEXT DEFAULT (datetime('now', 'localtime')),
    fecha_nacimiento TEXT,
    activo INTEGER DEFAULT 1
);

-- Tabla de pedidos
CREATE TABLE pedidos (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    cliente_id INTEGER NOT NULL,
    fecha_pedido TEXT DEFAULT (datetime('now', 'localtime')),
    fecha_entrega TEXT,
    subtotal REAL DEFAULT 0,
    impuestos REAL DEFAULT 0,
    descuento REAL DEFAULT 0,
    total REAL DEFAULT 0,
    estado TEXT DEFAULT 'Pendiente',
    notas TEXT,
    
    FOREIGN KEY (cliente_id) REFERENCES clientes(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    
    CHECK (estado IN ('Pendiente', 'Procesando', 'Enviado', 'Entregado', 'Cancelado')),
    CHECK (total >= 0)
);

-- Tabla de detalle de pedidos
CREATE TABLE detalle_pedidos (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    pedido_id INTEGER NOT NULL,
    producto_id INTEGER NOT NULL,
    cantidad INTEGER NOT NULL CHECK(cantidad > 0),
    precio_unitario REAL NOT NULL CHECK(precio_unitario >= 0),
    descuento REAL DEFAULT 0 CHECK(descuento >= 0 AND descuento <= 100),
    subtotal REAL GENERATED ALWAYS AS (
        cantidad * precio_unitario * (1 - descuento / 100)
    ) STORED,
    
    FOREIGN KEY (pedido_id) REFERENCES pedidos(id)
        ON DELETE CASCADE,
    FOREIGN KEY (producto_id) REFERENCES productos(id)
        ON DELETE RESTRICT
);

-- Tabla de etiquetas
CREATE TABLE etiquetas (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre TEXT NOT NULL UNIQUE,
    color TEXT DEFAULT '#000000',
    descripcion TEXT
);

-- Tabla intermedia productos-etiquetas
CREATE TABLE productos_etiquetas (
    producto_id INTEGER NOT NULL,
    etiqueta_id INTEGER NOT NULL,
    fecha_asignacion TEXT DEFAULT (datetime('now', 'localtime')),
    
    PRIMARY KEY (producto_id, etiqueta_id),
    FOREIGN KEY (producto_id) REFERENCES productos(id) ON DELETE CASCADE,
    FOREIGN KEY (etiqueta_id) REFERENCES etiquetas(id) ON DELETE CASCADE
);

-- Tabla de auditoría
CREATE TABLE auditoria (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    tabla TEXT NOT NULL,
    operacion TEXT NOT NULL,
    registro_id INTEGER,
    datos_anteriores TEXT,
    datos_nuevos TEXT,
    fecha TEXT DEFAULT (datetime('now', 'localtime'))
);

-- ============================================
-- 2. CREAR ÍNDICES
-- ============================================

CREATE INDEX idx_productos_nombre ON productos(nombre);
CREATE INDEX idx_productos_categoria ON productos(categoria_id);
CREATE INDEX idx_productos_precio ON productos(precio);
CREATE INDEX idx_productos_activo ON productos(activo) WHERE activo = 1;

CREATE INDEX idx_clientes_email ON clientes(email);
CREATE INDEX idx_clientes_ciudad ON clientes(ciudad);
CREATE INDEX idx_clientes_activo ON clientes(activo) WHERE activo = 1;

CREATE INDEX idx_pedidos_cliente ON pedidos(cliente_id);
CREATE INDEX idx_pedidos_fecha ON pedidos(fecha_pedido);
CREATE INDEX idx_pedidos_estado ON pedidos(estado);

CREATE INDEX idx_detalle_pedido ON detalle_pedidos(pedido_id);
CREATE INDEX idx_detalle_producto ON detalle_pedidos(producto_id);

-- ============================================
-- 3. INSERTAR DATOS DE PRUEBA
-- ============================================

BEGIN TRANSACTION;

-- Categorías
INSERT INTO categorias (nombre, descripcion) VALUES
    ('Electrónica', 'Dispositivos electrónicos y accesorios'),
    ('Ropa', 'Prendas de vestir y accesorios'),
    ('Hogar', 'Artículos para el hogar'),
    ('Deportes', 'Equipamiento deportivo'),
    ('Libros', 'Libros y revistas'),
    ('Juguetes', 'Juguetes para todas las edades'),
    ('Alimentos', 'Productos alimenticios'),
    ('Belleza', 'Productos de belleza y cuidado personal');

-- Productos
INSERT INTO productos (nombre, descripcion, precio, costo, stock, stock_minimo, categoria_id) VALUES
    ('Laptop HP 15"', 'Laptop HP 15.6" Intel Core i5 8GB RAM 256GB SSD', 12999.99, 9000.00, 15, 5, 1),
    ('Mouse Logitech', 'Mouse óptico inalámbrico 2.4GHz', 299.99, 150.00, 50, 20, 1),
    ('Teclado Mecánico RGB', 'Teclado mecánico retroiluminado switches azules', 899.99, 500.00, 30, 10, 1),
    ('Monitor Samsung 24"', 'Monitor LED Full HD 24 pulgadas 75Hz', 2499.99, 1800.00, 20, 5, 1),
    ('Auriculares Bluetooth', 'Auriculares inalámbricos con cancelación de ruido', 1299.99, 700.00, 40, 15, 1),
    ('Camiseta Deportiva', 'Camiseta de algodón para deporte', 249.99, 100.00, 100, 30, 2),
    ('Pantalón Mezclilla', 'Pantalón de mezclilla azul corte recto', 599.99, 300.00, 75, 25, 2),
    ('Sudadera con Capucha', 'Sudadera de algodón con capucha', 449.99, 200.00, 60, 20, 2),
    ('Sofá 3 Plazas', 'Sofá moderno de 3 plazas color gris', 8999.99, 5000.00, 5, 2, 3),
    ('Lámpara LED', 'Lámpara de mesa LED regulable', 449.99, 200.00, 40, 15, 3),
    ('Balón de Fútbol', 'Balón profesional tamaño 5', 399.99, 200.00, 60, 20, 4),
    ('Raqueta de Tenis', 'Raqueta profesional de grafito', 1299.99, 700.00, 25, 10, 4),
    ('Cien Años de Soledad', 'Gabriel García Márquez - Novela', 299.99, 150.00, 50, 20, 5),
    ('Muñeca Barbie', 'Muñeca Barbie con accesorios', 349.99, 180.00, 80, 30, 6),
    ('Café Orgánico 500g', 'Café orgánico molido', 189.99, 90.00, 120, 40, 7),
    ('Crema Facial', 'Crema hidratante facial 50ml', 299.99, 120.00, 70, 25, 8);

-- Clientes
INSERT INTO clientes (nombre, apellido, email, telefono, direccion, ciudad, estado, codigo_postal, fecha_nacimiento) VALUES
    ('Juan', 'Pérez', 'juan.perez@email.com', '5551234567', 'Av. Reforma 123', 'Ciudad de México', 'CDMX', '01000', '1990-05-15'),
    ('María', 'González', 'maria.gonzalez@email.com', '5552345678', 'Calle Juárez 456', 'Guadalajara', 'Jalisco', '44100', '1985-08-22'),
    ('Carlos', 'Rodríguez', 'carlos.rodriguez@email.com', '5553456789', 'Blvd. Díaz Ordaz 789', 'Monterrey', 'Nuevo León', '64000', '1992-03-10'),
    ('Ana', 'Martínez', 'ana.martinez@email.com', '5554567890', 'Av. Universidad 321', 'Puebla', 'Puebla', '72000', '1988-11-30'),
    ('Luis', 'Hernández', 'luis.hernandez@email.com', '5555678901', 'Calle Morelos 654', 'Querétaro', 'Querétaro', '76000', '1995-07-18'),
    ('Laura', 'López', 'laura.lopez@email.com', '5556789012', 'Av. Juárez 987', 'Tijuana', 'Baja California', '22000', '1991-02-25'),
    ('Pedro', 'García', 'pedro.garcia@email.com', '5557890123', 'Calle Hidalgo 147', 'Mérida', 'Yucatán', '97000', '1987-09-14'),
    ('Sofia', 'Ramírez', 'sofia.ramirez@email.com', '5558901234', 'Av. Insurgentes 258', 'Ciudad de México', 'CDMX', '03100', '1993-12-05');

-- Etiquetas
INSERT INTO etiquetas (nombre, color, descripcion) VALUES
    ('Oferta', '#FF0000', 'Productos en oferta especial'),
    ('Nuevo', '#00FF00', 'Productos recién llegados'),
    ('Popular', '#0000FF', 'Productos más vendidos'),
    ('Descuento', '#FFA500', 'Productos con descuento'),
    ('Premium', '#FFD700', 'Productos de alta gama'),
    ('Eco-Friendly', '#228B22', 'Productos ecológicos'),
    ('Importado', '#800080', 'Productos importados');

-- Asignar etiquetas a productos
INSERT INTO productos_etiquetas (producto_id, etiqueta_id) VALUES
    (1, 2), (1, 5), (2, 1), (2, 3), (3, 3), (3, 5),
    (4, 2), (5, 5), (6, 1), (6, 4), (11, 3), (13, 2);

-- Pedidos
INSERT INTO pedidos (cliente_id, subtotal, impuestos, descuento, total, estado, fecha_pedido) VALUES
    (1, 13299.98, 2127.99, 0, 15427.97, 'Entregado', datetime('now', '-15 days')),
    (2, 899.99, 144.00, 50.00, 993.99, 'Entregado', datetime('now', '-12 days')),
    (3, 2499.99, 400.00, 0, 2899.99, 'Enviado', datetime('now', '-5 days')),
    (1, 1699.97, 272.00, 100.00, 1871.97, 'Procesando', datetime('now', '-2 days')),
    (4, 399.99, 64.00, 0, 463.99, 'Entregado', datetime('now', '-20 days')),
    (5, 8999.99, 1440.00, 500.00, 9939.99, 'Entregado', datetime('now', '-8 days')),
    (6, 749.98, 120.00, 0, 869.98, 'Pendiente', datetime('now', '-1 days')),
    (7, 1599.98, 256.00, 200.00, 1655.98, 'Procesando', datetime('now', 'localtime'));

-- Detalle de pedidos
INSERT INTO detalle_pedidos (pedido_id, producto_id, cantidad, precio_unitario, descuento) VALUES
    (1, 1, 1, 12999.99, 0), (1, 2, 1, 299.99, 0),
    (2, 3, 1, 899.99, 0),
    (3, 4, 1, 2499.99, 0),
    (4, 3, 1, 899.99, 10), (4, 2, 2, 299.99, 5), (4, 5, 1, 1299.99, 0),
    (5, 11, 1, 399.99, 0),
    (6, 9, 1, 8999.99, 0),
    (7, 6, 2, 249.99, 0), (7, 7, 1, 599.99, 0),
    (8, 5, 1, 1299.99, 15), (8, 2, 1, 299.99, 0);

COMMIT;

-- ============================================
-- 4. VISTAS ÚTILES
-- ============================================

-- Vista: Productos con información completa
CREATE VIEW v_productos_completo AS
SELECT 
    p.id,
    p.nombre,
    p.descripcion,
    p.precio,
    p.costo,
    p.precio - p.costo AS margen,
    ROUND((p.precio - p.costo) * 100.0 / p.precio, 2) AS margen_porcentaje,
    p.stock,
    p.stock_minimo,
    CASE 
        WHEN p.stock = 0 THEN 'Agotado'
        WHEN p.stock < p.stock_minimo THEN 'Stock Bajo'
        ELSE 'Disponible'
    END AS estado_stock,
    c.nombre AS categoria,
    p.activo,
    COALESCE(v.unidades_vendidas, 0) AS unidades_vendidas,
    COALESCE(v.ingresos, 0) AS ingresos_totales
FROM productos p
LEFT JOIN categorias c ON p.categoria_id = c.id
LEFT JOIN (
    SELECT producto_id, SUM(cantidad) AS unidades_vendidas, SUM(subtotal) AS ingresos
    FROM detalle_pedidos
    GROUP BY producto_id
) v ON p.id = v.producto_id;

-- Vista: Resumen de clientes
CREATE VIEW v_clientes_resumen AS
SELECT 
    c.id,
    c.nombre || ' ' || c.apellido AS nombre_completo,
    c.email,
    c.ciudad,
    c.estado,
    COUNT(p.id) AS total_pedidos,
    COALESCE(SUM(p.total), 0) AS total_gastado,
    COALESCE(AVG(p.total), 0) AS ticket_promedio,
    MAX(p.fecha_pedido) AS ultima_compra,
    CAST(julianday('now') - julianday(MAX(p.fecha_pedido)) AS INTEGER) AS dias_sin_comprar
FROM clientes c
LEFT JOIN pedidos p ON c.id = p.cliente_id
WHERE c.activo = 1
GROUP BY c.id, c.nombre, c.apellido, c.email, c.ciudad, c.estado;

-- Vista: Pedidos completos
CREATE VIEW v_pedidos_completos AS
SELECT 
    p.id AS pedido_id,
    p.fecha_pedido,
    c.nombre || ' ' || c.apellido AS cliente,
    c.email,
    c.ciudad,
    p.subtotal,
    p.impuestos,
    p.descuento,
    p.total,
    p.estado,
    COUNT(dp.id) AS items,
    SUM(dp.cantidad) AS unidades_totales
FROM pedidos p
INNER JOIN clientes c ON p.cliente_id = c.id
LEFT JOIN detalle_pedidos dp ON p.id = dp.pedido_id
GROUP BY p.id, p.fecha_pedido, c.nombre, c.apellido, c.email, c.ciudad,
         p.subtotal, p.impuestos, p.descuento, p.total, p.estado;

-- ============================================
-- 5. CONSULTAS DE ANÁLISIS
-- ============================================

-- Reporte de ventas por categoría
SELECT 
    c.nombre AS categoria,
    COUNT(DISTINCT p.id) AS productos_diferentes,
    SUM(dp.cantidad) AS unidades_vendidas,
    ROUND(SUM(dp.subtotal), 2) AS ingresos,
    ROUND(AVG(dp.precio_unitario), 2) AS precio_promedio
FROM categorias c
INNER JOIN productos p ON c.id = p.categoria_id
INNER JOIN detalle_pedidos dp ON p.id = dp.producto_id
GROUP BY c.id, c.nombre
ORDER BY ingresos DESC;

-- Top 10 productos más vendidos
SELECT 
    p.nombre,
    c.nombre AS categoria,
    SUM(dp.cantidad) AS unidades_vendidas,
    ROUND(SUM(dp.subtotal), 2) AS ingresos,
    p.stock AS stock_actual
FROM productos p
INNER JOIN categorias c ON p.categoria_id = c.id
INNER JOIN detalle_pedidos dp ON p.id = dp.producto_id
GROUP BY p.id, p.nombre, c.nombre, p.stock
ORDER BY unidades_vendidas DESC
LIMIT 10;

-- Clientes VIP (top 10 por gasto)
SELECT 
    c.nombre || ' ' || c.apellido AS cliente,
    c.email,
    c.ciudad,
    COUNT(p.id) AS total_pedidos,
    ROUND(SUM(p.total), 2) AS total_gastado,
    ROUND(AVG(p.total), 2) AS ticket_promedio,
    MAX(p.fecha_pedido) AS ultima_compra
FROM clientes c
INNER JOIN pedidos p ON c.id = p.cliente_id
GROUP BY c.id, c.nombre, c.apellido, c.email, c.ciudad
ORDER BY total_gastado DESC
LIMIT 10;

-- Productos con stock bajo
SELECT 
    p.nombre,
    c.nombre AS categoria,
    p.stock AS stock_actual,
    p.stock_minimo,
    p.stock_minimo - p.stock AS unidades_faltantes,
    ROUND(p.costo * (p.stock_minimo - p.stock), 2) AS costo_reposicion
FROM productos p
INNER JOIN categorias c ON p.categoria_id = c.id
WHERE p.stock < p.stock_minimo AND p.activo = 1
ORDER BY unidades_faltantes DESC;

-- Análisis de ventas por mes
SELECT 
    strftime('%Y-%m', fecha_pedido) AS mes,
    COUNT(*) AS total_pedidos,
    SUM(total) AS ingresos,
    AVG(total) AS ticket_promedio,
    COUNT(DISTINCT cliente_id) AS clientes_unicos
FROM pedidos
WHERE estado != 'Cancelado'
GROUP BY strftime('%Y-%m', fecha_pedido)
ORDER BY mes DESC;

-- Productos sin ventas
SELECT 
    p.nombre,
    c.nombre AS categoria,
    p.precio,
    p.stock,
    CAST(julianday('now') - julianday(p.fecha_creacion) AS INTEGER) AS dias_desde_creacion
FROM productos p
INNER JOIN categorias c ON p.categoria_id = c.id
LEFT JOIN detalle_pedidos dp ON p.id = dp.producto_id
WHERE dp.id IS NULL AND p.activo = 1
ORDER BY dias_desde_creacion DESC;

-- ============================================
-- 6. PROCEDIMIENTOS COMUNES (Conceptuales)
-- ============================================

/*
-- Procesar nuevo pedido
BEGIN TRANSACTION;
    -- Verificar stock
    -- Crear pedido
    -- Agregar detalles
    -- Actualizar stock
    -- Calcular totales
COMMIT;

-- Cancelar pedido
BEGIN TRANSACTION;
    -- Devolver stock
    -- Actualizar estado
    -- Registrar en auditoría
COMMIT;

-- Reporte de inventario
SELECT * FROM v_productos_completo
WHERE estado_stock IN ('Agotado', 'Stock Bajo');
*/

-- ============================================
-- 7. MANTENIMIENTO
-- ============================================

-- Actualizar estadísticas
ANALYZE;

-- Verificar integridad
PRAGMA integrity_check;

-- Optimizar base de datos
VACUUM;

-- ============================================
-- CONCEPTOS APLICADOS EN ESTE PROYECTO
-- ============================================

/*
1. DDL: CREATE TABLE, DROP TABLE, CREATE INDEX, CREATE VIEW
2. DML: INSERT, UPDATE, DELETE
3. DQL: SELECT con múltiples técnicas
4. Restricciones: PRIMARY KEY, FOREIGN KEY, CHECK, UNIQUE, NOT NULL
5. Relaciones: 1:N (clientes-pedidos), N:M (productos-etiquetas)
6. Índices: Para optimizar consultas frecuentes
7. Vistas: Para simplificar consultas complejas
8. Funciones: Agregación, texto, fecha, condicionales
9. JOINs: INNER, LEFT para relacionar datos
10. Subconsultas: En SELECT, WHERE, FROM
11. CTEs: Para consultas más legibles
12. Transacciones: Para mantener integridad
13. Columnas generadas: Para cálculos automáticos
14. Auditoría: Para rastrear cambios

Este proyecto demuestra un sistema completo de gestión de tienda
con todas las mejores prácticas de SQL.
*/
