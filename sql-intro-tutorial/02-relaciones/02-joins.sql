-- ============================================
-- RELACIONES: JOINS (UNIONES)
-- ============================================

-- Los JOINs combinan datos de múltiples tablas

PRAGMA foreign_keys = ON;

-- ============================================
-- INNER JOIN: Registros que coinciden en ambas tablas
-- ============================================

-- Productos con su categoría
SELECT 
    p.id,
    p.nombre AS producto,
    p.precio,
    c.nombre AS categoria
FROM productos p
INNER JOIN categorias c ON p.categoria_id = c.id;

-- Forma alternativa (sin INNER, es lo mismo)
SELECT 
    p.nombre AS producto,
    c.nombre AS categoria
FROM productos p
JOIN categorias c ON p.categoria_id = c.id;

-- INNER JOIN con múltiples tablas
SELECT 
    c.nombre || ' ' || c.apellido AS cliente,
    p.fecha_pedido,
    p.total,
    p.estado
FROM pedidos p
INNER JOIN clientes c ON p.cliente_id = c.id
WHERE p.estado = 'Entregado';

-- ============================================
-- LEFT JOIN: Todos los registros de la tabla izquierda
-- ============================================

-- Todas las categorías, incluso sin productos
SELECT 
    c.nombre AS categoria,
    COUNT(p.id) AS total_productos
FROM categorias c
LEFT JOIN productos p ON c.id = p.categoria_id
GROUP BY c.id, c.nombre;

-- Clientes con y sin pedidos
SELECT 
    c.nombre || ' ' || c.apellido AS cliente,
    COUNT(p.id) AS total_pedidos,
    COALESCE(SUM(p.total), 0) AS total_gastado
FROM clientes c
LEFT JOIN pedidos p ON c.id = p.cliente_id
GROUP BY c.id, c.nombre, c.apellido;

-- Encontrar clientes sin pedidos
SELECT 
    c.id,
    c.nombre,
    c.apellido,
    c.email
FROM clientes c
LEFT JOIN pedidos p ON c.id = p.cliente_id
WHERE p.id IS NULL;

-- ============================================
-- CROSS JOIN: Producto cartesiano
-- ============================================

-- Todas las combinaciones posibles (usar con precaución)
SELECT 
    c.nombre AS cliente,
    p.nombre AS producto
FROM clientes c
CROSS JOIN productos p
LIMIT 10;

-- Útil para generar combinaciones
SELECT 
    c.nombre AS categoria,
    'Enero' AS mes
FROM categorias c
UNION ALL
SELECT c.nombre, 'Febrero' FROM categorias c
UNION ALL
SELECT c.nombre, 'Marzo' FROM categorias c;

-- ============================================
-- SELF JOIN: Unir tabla consigo misma
-- ============================================

-- Crear tabla de empleados para demostrar
CREATE TEMP TABLE empleados (
    id INTEGER PRIMARY KEY,
    nombre TEXT,
    jefe_id INTEGER,
    FOREIGN KEY (jefe_id) REFERENCES empleados(id)
);

INSERT INTO empleados VALUES
    (1, 'Carlos Director', NULL),
    (2, 'Ana Gerente', 1),
    (3, 'Luis Supervisor', 2),
    (4, 'María Empleada', 3),
    (5, 'Juan Empleado', 3);

-- Empleados con su jefe
SELECT 
    e.nombre AS empleado,
    j.nombre AS jefe
FROM empleados e
LEFT JOIN empleados j ON e.jefe_id = j.id;

-- ============================================
-- MÚLTIPLES JOINS
-- ============================================

-- Pedidos completos: cliente, productos, categorías
SELECT 
    c.nombre || ' ' || c.apellido AS cliente,
    p.fecha_pedido,
    pr.nombre AS producto,
    cat.nombre AS categoria,
    dp.cantidad,
    dp.precio_unitario,
    dp.subtotal
FROM pedidos p
INNER JOIN clientes c ON p.cliente_id = c.id
INNER JOIN detalle_pedidos dp ON p.id = dp.pedido_id
INNER JOIN productos pr ON dp.producto_id = pr.id
INNER JOIN categorias cat ON pr.categoria_id = cat.id
ORDER BY p.id, dp.id;

-- ============================================
-- JOINS CON CONDICIONES ADICIONALES
-- ============================================

-- Productos de electrónica con pedidos
SELECT 
    p.nombre AS producto,
    COUNT(dp.id) AS veces_vendido,
    SUM(dp.cantidad) AS unidades_vendidas
FROM productos p
INNER JOIN categorias c ON p.categoria_id = c.id AND c.nombre = 'Electrónica'
LEFT JOIN detalle_pedidos dp ON p.id = dp.producto_id
GROUP BY p.id, p.nombre;

-- ============================================
-- USING: Simplificar JOIN cuando columnas tienen mismo nombre
-- ============================================

-- Si las columnas se llaman igual, se puede usar USING
-- En lugar de: ON p.categoria_id = c.id
-- Se puede usar: USING (categoria_id)

-- Ejemplo (requiere que las columnas se llamen igual)
-- SELECT * FROM productos p
-- JOIN categorias c USING (categoria_id);

-- ============================================
-- NATURAL JOIN: JOIN automático por columnas con mismo nombre
-- ============================================

-- No recomendado: puede causar resultados inesperados
-- NATURAL JOIN une automáticamente por columnas con mismo nombre
-- SELECT * FROM productos NATURAL JOIN categorias;

-- ============================================
-- CONSULTAS PRÁCTICAS CON JOINS
-- ============================================

-- 1. Top 5 productos más vendidos
SELECT 
    pr.nombre AS producto,
    SUM(dp.cantidad) AS unidades_vendidas,
    SUM(dp.subtotal) AS ingresos_totales
FROM productos pr
INNER JOIN detalle_pedidos dp ON pr.id = dp.producto_id
GROUP BY pr.id, pr.nombre
ORDER BY unidades_vendidas DESC
LIMIT 5;

-- 2. Clientes con más compras
SELECT 
    c.nombre || ' ' || c.apellido AS cliente,
    COUNT(p.id) AS total_pedidos,
    SUM(p.total) AS total_gastado,
    AVG(p.total) AS promedio_por_pedido
FROM clientes c
INNER JOIN pedidos p ON c.id = p.cliente_id
GROUP BY c.id, c.nombre, c.apellido
ORDER BY total_gastado DESC;

-- 3. Productos sin ventas
SELECT 
    p.id,
    p.nombre,
    p.precio,
    p.stock
FROM productos p
LEFT JOIN detalle_pedidos dp ON p.id = dp.producto_id
WHERE dp.id IS NULL;

-- 4. Resumen de ventas por categoría
SELECT 
    cat.nombre AS categoria,
    COUNT(DISTINCT p.id) AS productos_vendidos,
    SUM(dp.cantidad) AS unidades_vendidas,
    SUM(dp.subtotal) AS ingresos_totales
FROM categorias cat
INNER JOIN productos pr ON cat.id = pr.categoria_id
INNER JOIN detalle_pedidos dp ON pr.id = dp.producto_id
GROUP BY cat.id, cat.nombre
ORDER BY ingresos_totales DESC;

-- ============================================
-- CONCEPTOS CLAVE
-- ============================================

/*
1. INNER JOIN:
   - Solo registros que coinciden en ambas tablas
   - Más común y restrictivo
   - Sintaxis: FROM tabla1 INNER JOIN tabla2 ON condición

2. LEFT JOIN (LEFT OUTER JOIN):
   - Todos los registros de tabla izquierda
   - NULL si no hay coincidencia en tabla derecha
   - Útil para encontrar registros sin relación

3. RIGHT JOIN:
   - SQLite NO lo soporta
   - Solución: Invertir orden de tablas con LEFT JOIN

4. FULL OUTER JOIN:
   - SQLite NO lo soporta nativamente
   - Solución: UNION de LEFT JOIN y RIGHT JOIN

5. CROSS JOIN:
   - Producto cartesiano (todas las combinaciones)
   - Usar con precaución: puede generar muchos registros
   - Útil para matrices o combinaciones

6. SELF JOIN:
   - Tabla unida consigo misma
   - Útil para jerarquías (empleado-jefe)
   - Requiere alias diferentes

7. Sintaxis de JOIN:
   - ON: Condición de unión explícita (recomendado)
   - USING: Cuando columnas tienen mismo nombre
   - NATURAL: Automático (no recomendado)

8. Buenas prácticas:
   - Usar alias para tablas (p, c, dp)
   - Especificar tabla.columna para evitar ambigüedad
   - Preferir INNER JOIN explícito sobre comas
   - LEFT JOIN para incluir registros sin relación
   - Indexar columnas usadas en JOIN

9. Orden de ejecución:
   FROM → JOIN → WHERE → GROUP BY → HAVING → SELECT → ORDER BY → LIMIT

10. COALESCE:
    - Retorna primer valor no nulo
    - Útil con LEFT JOIN para reemplazar NULL
    - Ejemplo: COALESCE(suma, 0)
*/
