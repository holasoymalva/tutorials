-- ============================================
-- OPTIMIZACIÓN: ÍNDICES
-- ============================================

-- Los índices mejoran el rendimiento de las consultas

PRAGMA foreign_keys = ON;

-- ============================================
-- ¿QUÉ ES UN ÍNDICE?
-- ============================================

/*
Un índice es una estructura de datos que mejora la velocidad de las consultas.
Similar al índice de un libro: te permite encontrar información rápidamente
sin leer todo el contenido.

VENTAJAS:
- Acelera búsquedas (WHERE, JOIN, ORDER BY)
- Mejora rendimiento de consultas SELECT

DESVENTAJAS:
- Ocupa espacio en disco
- Ralentiza INSERT, UPDATE, DELETE
- Requiere mantenimiento
*/

-- ============================================
-- CREAR ÍNDICES
-- ============================================

-- Índice simple en una columna
CREATE INDEX idx_productos_precio ON productos(precio);

-- Índice en múltiples columnas (índice compuesto)
CREATE INDEX idx_productos_categoria_precio ON productos(categoria_id, precio);

-- Índice único (garantiza valores únicos)
CREATE UNIQUE INDEX idx_clientes_email_unique ON clientes(email);

-- Índice con condición (índice parcial)
CREATE INDEX idx_productos_activos ON productos(precio) WHERE activo = 1;

-- Índice en expresión
CREATE INDEX idx_clientes_email_lower ON clientes(LOWER(email));

-- ============================================
-- VER ÍNDICES EXISTENTES
-- ============================================

-- Ver todos los índices de una tabla
-- .indexes productos

-- Ver definición de un índice
-- .schema idx_productos_precio

-- Consultar índices desde SQL
SELECT name, tbl_name, sql
FROM sqlite_master
WHERE type = 'index' AND tbl_name = 'productos';

-- ============================================
-- ELIMINAR ÍNDICES
-- ============================================

-- Eliminar un índice
DROP INDEX IF EXISTS idx_productos_precio;

-- ============================================
-- CUÁNDO USAR ÍNDICES
-- ============================================

/*
USAR ÍNDICES EN:
1. Columnas en WHERE frecuentemente
2. Columnas en JOIN
3. Columnas en ORDER BY
4. Columnas en GROUP BY
5. Claves foráneas
6. Columnas con alta cardinalidad (muchos valores únicos)

NO USAR ÍNDICES EN:
1. Tablas pequeñas (< 1000 registros)
2. Columnas con pocos valores únicos (ej: booleanos)
3. Columnas que cambian frecuentemente
4. Tablas con muchas escrituras y pocas lecturas
*/

-- ============================================
-- EJEMPLOS PRÁCTICOS
-- ============================================

-- Recrear índices útiles para nuestro proyecto
CREATE INDEX IF NOT EXISTS idx_productos_nombre ON productos(nombre);
CREATE INDEX IF NOT EXISTS idx_productos_categoria ON productos(categoria_id);
CREATE INDEX IF NOT EXISTS idx_productos_precio ON productos(precio);
CREATE INDEX IF NOT EXISTS idx_productos_activo ON productos(activo);

CREATE INDEX IF NOT EXISTS idx_clientes_email ON clientes(email);
CREATE INDEX IF NOT EXISTS idx_clientes_ciudad ON clientes(ciudad);

CREATE INDEX IF NOT EXISTS idx_pedidos_cliente ON pedidos(cliente_id);
CREATE INDEX IF NOT EXISTS idx_pedidos_fecha ON pedidos(fecha_pedido);
CREATE INDEX IF NOT EXISTS idx_pedidos_estado ON pedidos(estado);

CREATE INDEX IF NOT EXISTS idx_detalle_pedido ON detalle_pedidos(pedido_id);
CREATE INDEX IF NOT EXISTS idx_detalle_producto ON detalle_pedidos(producto_id);

-- ============================================
-- ANALIZAR RENDIMIENTO
-- ============================================

-- EXPLAIN QUERY PLAN muestra cómo SQLite ejecutará la consulta

-- Sin índice (SCAN TABLE = lento)
EXPLAIN QUERY PLAN
SELECT * FROM productos WHERE precio > 1000;

-- Con índice (SEARCH TABLE USING INDEX = rápido)
EXPLAIN QUERY PLAN
SELECT * FROM productos WHERE nombre = 'Laptop HP';

-- JOIN con índices
EXPLAIN QUERY PLAN
SELECT p.nombre, c.nombre
FROM productos p
INNER JOIN categorias c ON p.categoria_id = c.id
WHERE p.precio > 500;

-- ============================================
-- ÍNDICES COMPUESTOS
-- ============================================

-- Orden de columnas importa en índices compuestos
-- Regla: Columnas más selectivas primero

-- Bueno: categoría primero (menos valores únicos)
CREATE INDEX idx_productos_cat_precio ON productos(categoria_id, precio);

-- Este índice sirve para:
-- WHERE categoria_id = ? AND precio > ?
-- WHERE categoria_id = ?
-- Pero NO para: WHERE precio > ? (sin categoria_id)

-- ============================================
-- ÍNDICES PARCIALES
-- ============================================

-- Índice solo para productos activos (ahorra espacio)
CREATE INDEX idx_productos_activos_precio 
ON productos(precio) 
WHERE activo = 1;

-- Índice solo para pedidos pendientes
CREATE INDEX idx_pedidos_pendientes 
ON pedidos(cliente_id, fecha_pedido) 
WHERE estado = 'Pendiente';

-- ============================================
-- MANTENIMIENTO DE ÍNDICES
-- ============================================

-- Analizar tabla para actualizar estadísticas
ANALYZE productos;
ANALYZE clientes;
ANALYZE pedidos;

-- Analizar toda la base de datos
ANALYZE;

-- Reindexar (reconstruir índices)
REINDEX productos;
REINDEX;  -- Toda la base de datos

-- Verificar integridad
PRAGMA integrity_check;

-- ============================================
-- ESTADÍSTICAS DE ÍNDICES
-- ============================================

-- Ver estadísticas de índices
SELECT * FROM sqlite_stat1;

-- ============================================
-- CASOS PRÁCTICOS
-- ============================================

-- 1. Búsqueda de productos por nombre (frecuente)
-- Índice: idx_productos_nombre
SELECT * FROM productos WHERE nombre LIKE 'Laptop%';

-- 2. Filtrar por categoría y precio (común en e-commerce)
-- Índice: idx_productos_cat_precio
SELECT * FROM productos 
WHERE categoria_id = 1 AND precio BETWEEN 500 AND 2000;

-- 3. Pedidos de un cliente (muy frecuente)
-- Índice: idx_pedidos_cliente
SELECT * FROM pedidos WHERE cliente_id = 1;

-- 4. Productos más vendidos (análisis)
-- Índices: idx_detalle_producto
SELECT producto_id, SUM(cantidad) AS total
FROM detalle_pedidos
GROUP BY producto_id
ORDER BY total DESC;

-- ============================================
-- COMPARACIÓN: CON Y SIN ÍNDICE
-- ============================================

-- Crear tabla de prueba grande
CREATE TEMP TABLE productos_test AS
SELECT 
    ROW_NUMBER() OVER () AS id,
    'Producto ' || ROW_NUMBER() OVER () AS nombre,
    ABS(RANDOM() % 10000) / 100.0 AS precio
FROM (
    SELECT 1 FROM productos, productos AS p2, productos AS p3
) LIMIT 10000;

-- Consulta SIN índice (lento en tablas grandes)
EXPLAIN QUERY PLAN
SELECT * FROM productos_test WHERE precio > 50;

-- Crear índice
CREATE INDEX idx_test_precio ON productos_test(precio);

-- Consulta CON índice (rápido)
EXPLAIN QUERY PLAN
SELECT * FROM productos_test WHERE precio > 50;

-- ============================================
-- ÍNDICES AUTOMÁTICOS
-- ============================================

/*
SQLite crea índices automáticamente para:
1. PRIMARY KEY
2. UNIQUE constraints
3. Algunos casos de ORDER BY en subconsultas

No necesitas crear índices manualmente para estas columnas.
*/

-- ============================================
-- MEJORES PRÁCTICAS
-- ============================================

/*
1. INDEXAR:
   - Claves foráneas
   - Columnas en WHERE frecuentes
   - Columnas en JOIN
   - Columnas en ORDER BY de consultas lentas

2. NO SOBRE-INDEXAR:
   - Cada índice ocupa espacio
   - Ralentiza escrituras
   - Máximo 5-10 índices por tabla

3. MONITOREAR:
   - Usar EXPLAIN QUERY PLAN
   - Analizar consultas lentas
   - Revisar uso de índices

4. MANTENER:
   - ANALYZE periódicamente
   - REINDEX si es necesario
   - Eliminar índices no usados

5. ORDEN EN ÍNDICES COMPUESTOS:
   - Igualdad primero (=)
   - Rangos después (>, <, BETWEEN)
   - Más selectivo primero

6. ÍNDICES PARCIALES:
   - Usar WHERE en índice
   - Ahorra espacio
   - Más rápido para casos específicos
*/

-- ============================================
-- CONCEPTOS CLAVE
-- ============================================

/*
1. ÍNDICE:
   - Estructura que acelera búsquedas
   - Trade-off: velocidad vs espacio/escritura
   - Similar a índice de libro

2. TIPOS DE ÍNDICES:
   - Simple: Una columna
   - Compuesto: Múltiples columnas
   - Único: Garantiza unicidad
   - Parcial: Con condición WHERE

3. B-TREE:
   - Estructura usada por SQLite
   - Búsqueda logarítmica O(log n)
   - Eficiente para rangos

4. CARDINALIDAD:
   - Número de valores únicos
   - Alta cardinalidad = buen candidato para índice
   - Baja cardinalidad = mal candidato

5. SELECTIVIDAD:
   - Qué tan específica es una condición
   - Alta selectividad = retorna pocas filas
   - Índices más útiles con alta selectividad

6. COVERING INDEX:
   - Índice que contiene todas las columnas necesarias
   - Evita acceder a la tabla
   - Muy rápido

7. EXPLAIN QUERY PLAN:
   - Muestra cómo se ejecutará la consulta
   - SCAN = sin índice (lento)
   - SEARCH = con índice (rápido)

8. ANALYZE:
   - Actualiza estadísticas de la tabla
   - Ayuda al optimizador a elegir mejor plan
   - Ejecutar después de cambios grandes

9. REINDEX:
   - Reconstruye índices
   - Útil después de muchas modificaciones
   - Puede mejorar rendimiento

10. Regla 80/20:
    - 20% de consultas causan 80% de carga
    - Optimizar esas consultas primero
    - Medir antes de optimizar
*/

-- ============================================
-- EJERCICIOS
-- ============================================

/*
1. Identificar consultas lentas en tu aplicación
2. Usar EXPLAIN QUERY PLAN para analizarlas
3. Crear índices apropiados
4. Medir mejora de rendimiento
5. Eliminar índices no usados
*/
