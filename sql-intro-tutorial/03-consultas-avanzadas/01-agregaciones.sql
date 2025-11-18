-- ============================================
-- CONSULTAS AVANZADAS: FUNCIONES DE AGREGACIÓN
-- ============================================

-- Las funciones de agregación operan sobre conjuntos de filas

PRAGMA foreign_keys = ON;

-- ============================================
-- FUNCIONES DE AGREGACIÓN BÁSICAS
-- ============================================

-- COUNT: Contar registros
SELECT COUNT(*) AS total_productos FROM productos;
SELECT COUNT(descripcion) AS productos_con_descripcion FROM productos;
SELECT COUNT(DISTINCT categoria_id) AS categorias_usadas FROM productos;

-- SUM: Sumar valores
SELECT SUM(stock) AS stock_total FROM productos;
SELECT SUM(precio * stock) AS valor_inventario FROM productos;

-- AVG: Promedio
SELECT AVG(precio) AS precio_promedio FROM productos;
SELECT ROUND(AVG(precio), 2) AS precio_promedio_redondeado FROM productos;

-- MAX y MIN: Valores máximo y mínimo
SELECT MAX(precio) AS precio_maximo FROM productos;
SELECT MIN(precio) AS precio_minimo FROM productos;
SELECT MAX(precio) - MIN(precio) AS rango_precios FROM productos;

-- Múltiples agregaciones
SELECT 
    COUNT(*) AS total_productos,
    SUM(stock) AS stock_total,
    AVG(precio) AS precio_promedio,
    MAX(precio) AS precio_max,
    MIN(precio) AS precio_min
FROM productos;

-- ============================================
-- GROUP BY: Agrupar resultados
-- ============================================

-- Productos por categoría
SELECT 
    categoria_id,
    COUNT(*) AS total_productos,
    AVG(precio) AS precio_promedio
FROM productos
GROUP BY categoria_id;

-- Con JOIN para nombres legibles
SELECT 
    c.nombre AS categoria,
    COUNT(p.id) AS total_productos,
    ROUND(AVG(p.precio), 2) AS precio_promedio,
    SUM(p.stock) AS stock_total
FROM categorias c
LEFT JOIN productos p ON c.id = p.categoria_id
GROUP BY c.id, c.nombre
ORDER BY total_productos DESC;

-- Agrupar por múltiples columnas
SELECT 
    categoria_id,
    activo,
    COUNT(*) AS total,
    AVG(precio) AS precio_promedio
FROM productos
GROUP BY categoria_id, activo;

-- ============================================
-- HAVING: Filtrar grupos
-- ============================================

-- WHERE filtra filas, HAVING filtra grupos

-- Categorías con más de 2 productos
SELECT 
    c.nombre AS categoria,
    COUNT(p.id) AS total_productos
FROM categorias c
INNER JOIN productos p ON c.id = p.categoria_id
GROUP BY c.id, c.nombre
HAVING COUNT(p.id) > 2;

-- Categorías con precio promedio mayor a 500
SELECT 
    c.nombre AS categoria,
    ROUND(AVG(p.precio), 2) AS precio_promedio,
    COUNT(p.id) AS total_productos
FROM categorias c
INNER JOIN productos p ON c.id = p.categoria_id
GROUP BY c.id, c.nombre
HAVING AVG(p.precio) > 500;

-- Combinar WHERE y HAVING
SELECT 
    c.nombre AS categoria,
    COUNT(p.id) AS productos_activos,
    SUM(p.stock) AS stock_total
FROM categorias c
INNER JOIN productos p ON c.id = p.categoria_id
WHERE p.activo = 1  -- Filtrar antes de agrupar
GROUP BY c.id, c.nombre
HAVING SUM(p.stock) > 30  -- Filtrar después de agrupar
ORDER BY stock_total DESC;

-- ============================================
-- CONSULTAS DE ANÁLISIS
-- ============================================

-- 1. Resumen de ventas por cliente
SELECT 
    c.nombre || ' ' || c.apellido AS cliente,
    COUNT(p.id) AS total_pedidos,
    SUM(p.total) AS total_gastado,
    AVG(p.total) AS promedio_por_pedido,
    MAX(p.total) AS pedido_mayor,
    MIN(p.total) AS pedido_menor
FROM clientes c
INNER JOIN pedidos p ON c.id = p.cliente_id
GROUP BY c.id, c.nombre, c.apellido
ORDER BY total_gastado DESC;

-- 2. Productos más vendidos
SELECT 
    pr.nombre AS producto,
    SUM(dp.cantidad) AS unidades_vendidas,
    COUNT(DISTINCT dp.pedido_id) AS pedidos,
    SUM(dp.subtotal) AS ingresos_totales,
    AVG(dp.precio_unitario) AS precio_promedio
FROM productos pr
INNER JOIN detalle_pedidos dp ON pr.id = dp.producto_id
GROUP BY pr.id, pr.nombre
ORDER BY unidades_vendidas DESC
LIMIT 10;

-- 3. Ventas por mes
SELECT 
    strftime('%Y-%m', fecha_pedido) AS mes,
    COUNT(*) AS total_pedidos,
    SUM(total) AS ingresos,
    AVG(total) AS ticket_promedio
FROM pedidos
GROUP BY strftime('%Y-%m', fecha_pedido)
ORDER BY mes DESC;

-- 4. Análisis de inventario
SELECT 
    CASE 
        WHEN stock = 0 THEN 'Sin stock'
        WHEN stock < 20 THEN 'Stock bajo'
        WHEN stock < 50 THEN 'Stock medio'
        ELSE 'Stock alto'
    END AS nivel_stock,
    COUNT(*) AS total_productos,
    SUM(precio * stock) AS valor_inventario
FROM productos
GROUP BY nivel_stock
ORDER BY 
    CASE nivel_stock
        WHEN 'Sin stock' THEN 1
        WHEN 'Stock bajo' THEN 2
        WHEN 'Stock medio' THEN 3
        ELSE 4
    END;

-- 5. Clientes por ciudad
SELECT 
    ciudad,
    COUNT(*) AS total_clientes,
    COUNT(CASE WHEN activo = 1 THEN 1 END) AS clientes_activos,
    COUNT(CASE WHEN activo = 0 THEN 1 END) AS clientes_inactivos
FROM clientes
GROUP BY ciudad
ORDER BY total_clientes DESC;

-- ============================================
-- AGREGACIONES CON CONDICIONES
-- ============================================

-- COUNT con condición
SELECT 
    COUNT(*) AS total_productos,
    COUNT(CASE WHEN precio > 1000 THEN 1 END) AS productos_premium,
    COUNT(CASE WHEN stock = 0 THEN 1 END) AS productos_agotados,
    COUNT(CASE WHEN activo = 1 THEN 1 END) AS productos_activos
FROM productos;

-- SUM con condición
SELECT 
    c.nombre AS categoria,
    SUM(CASE WHEN p.activo = 1 THEN 1 ELSE 0 END) AS activos,
    SUM(CASE WHEN p.activo = 0 THEN 1 ELSE 0 END) AS inactivos,
    SUM(CASE WHEN p.stock > 0 THEN p.stock ELSE 0 END) AS stock_disponible
FROM categorias c
LEFT JOIN productos p ON c.id = p.categoria_id
GROUP BY c.id, c.nombre;

-- ============================================
-- PERCENTILES Y ESTADÍSTICAS
-- ============================================

-- Mediana (percentil 50)
SELECT AVG(precio) AS mediana_precio
FROM (
    SELECT precio
    FROM productos
    ORDER BY precio
    LIMIT 2 - (SELECT COUNT(*) FROM productos) % 2
    OFFSET (SELECT (COUNT(*) - 1) / 2 FROM productos)
);

-- Distribución de precios
SELECT 
    CASE 
        WHEN precio < 300 THEN '0-300'
        WHEN precio < 600 THEN '300-600'
        WHEN precio < 1000 THEN '600-1000'
        WHEN precio < 2000 THEN '1000-2000'
        ELSE '2000+'
    END AS rango_precio,
    COUNT(*) AS cantidad,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM productos), 2) AS porcentaje
FROM productos
GROUP BY rango_precio
ORDER BY MIN(precio);

-- ============================================
-- ROLLUP Y SUBTOTALES (simulado en SQLite)
-- ============================================

-- Ventas por categoría con total general
SELECT 
    COALESCE(c.nombre, 'TOTAL GENERAL') AS categoria,
    COUNT(dp.id) AS ventas,
    SUM(dp.subtotal) AS ingresos
FROM detalle_pedidos dp
LEFT JOIN productos p ON dp.producto_id = p.id
LEFT JOIN categorias c ON p.categoria_id = c.id
GROUP BY c.nombre

UNION ALL

SELECT 
    'TOTAL GENERAL',
    COUNT(dp.id),
    SUM(dp.subtotal)
FROM detalle_pedidos dp;

-- ============================================
-- CONCEPTOS CLAVE
-- ============================================

/*
1. FUNCIONES DE AGREGACIÓN:
   - COUNT(*): Cuenta todas las filas
   - COUNT(columna): Cuenta valores no nulos
   - COUNT(DISTINCT): Cuenta valores únicos
   - SUM(): Suma valores
   - AVG(): Promedio
   - MAX(): Valor máximo
   - MIN(): Valor mínimo

2. GROUP BY:
   - Agrupa filas con valores similares
   - Todas las columnas en SELECT deben estar en GROUP BY o ser agregadas
   - Se puede agrupar por múltiples columnas

3. HAVING:
   - Filtra grupos (después de GROUP BY)
   - WHERE filtra filas (antes de GROUP BY)
   - Puede usar funciones de agregación

4. Orden de ejecución:
   FROM → WHERE → GROUP BY → HAVING → SELECT → ORDER BY → LIMIT

5. COUNT con CASE:
   - Contar condicionalmente
   - COUNT(CASE WHEN condición THEN 1 END)
   - Útil para múltiples conteos en una consulta

6. COALESCE:
   - Retorna primer valor no nulo
   - Útil para reemplazar NULL en agregaciones
   - COALESCE(valor, 0)

7. Buenas prácticas:
   - Usar alias descriptivos
   - ROUND() para decimales legibles
   - Combinar con JOIN para datos contextuales
   - WHERE antes de GROUP BY para mejor rendimiento

8. Diferencia WHERE vs HAVING:
   - WHERE: Filtra filas individuales
   - HAVING: Filtra grupos agregados
   - WHERE se ejecuta antes, HAVING después

9. Funciones de fecha:
   - strftime(): Formatear fechas
   - date(): Extraer fecha
   - datetime(): Fecha y hora
   - Útil para agrupar por periodo

10. NULL en agregaciones:
    - COUNT(*) cuenta NULL
    - COUNT(columna) ignora NULL
    - SUM/AVG ignoran NULL
    - Usar COALESCE para manejar NULL
*/
