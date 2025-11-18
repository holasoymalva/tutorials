-- ============================================
-- CONSULTAS AVANZADAS: SUBCONSULTAS
-- ============================================

-- Una subconsulta es una consulta dentro de otra consulta

PRAGMA foreign_keys = ON;

-- ============================================
-- SUBCONSULTAS EN WHERE
-- ============================================

-- Productos más caros que el promedio
SELECT nombre, precio
FROM productos
WHERE precio > (SELECT AVG(precio) FROM productos);

-- Clientes que han hecho pedidos
SELECT nombre, apellido, email
FROM clientes
WHERE id IN (SELECT DISTINCT cliente_id FROM pedidos);

-- Clientes que NO han hecho pedidos
SELECT nombre, apellido, email
FROM clientes
WHERE id NOT IN (SELECT cliente_id FROM pedidos WHERE cliente_id IS NOT NULL);

-- Productos de la categoría más popular
SELECT nombre, precio
FROM productos
WHERE categoria_id = (
    SELECT categoria_id
    FROM productos
    GROUP BY categoria_id
    ORDER BY COUNT(*) DESC
    LIMIT 1
);

-- ============================================
-- SUBCONSULTAS CON EXISTS
-- ============================================

-- EXISTS es más eficiente que IN para grandes conjuntos

-- Clientes con al menos un pedido
SELECT c.nombre, c.apellido
FROM clientes c
WHERE EXISTS (
    SELECT 1
    FROM pedidos p
    WHERE p.cliente_id = c.id
);

-- Productos que nunca se han vendido
SELECT p.nombre, p.precio, p.stock
FROM productos p
WHERE NOT EXISTS (
    SELECT 1
    FROM detalle_pedidos dp
    WHERE dp.producto_id = p.id
);

-- Categorías con productos activos
SELECT c.nombre
FROM categorias c
WHERE EXISTS (
    SELECT 1
    FROM productos p
    WHERE p.categoria_id = c.id AND p.activo = 1
);

-- ============================================
-- SUBCONSULTAS EN SELECT
-- ============================================

-- Agregar columnas calculadas con subconsultas

SELECT 
    nombre,
    precio,
    (SELECT AVG(precio) FROM productos) AS precio_promedio,
    precio - (SELECT AVG(precio) FROM productos) AS diferencia_promedio
FROM productos;

-- Productos con su ranking de precio
SELECT 
    nombre,
    precio,
    (SELECT COUNT(*) FROM productos p2 WHERE p2.precio > p1.precio) + 1 AS ranking_precio
FROM productos p1
ORDER BY precio DESC;

-- Clientes con total gastado
SELECT 
    c.nombre,
    c.apellido,
    (SELECT COUNT(*) FROM pedidos p WHERE p.cliente_id = c.id) AS total_pedidos,
    (SELECT COALESCE(SUM(total), 0) FROM pedidos p WHERE p.cliente_id = c.id) AS total_gastado
FROM clientes c;

-- ============================================
-- SUBCONSULTAS EN FROM (Tablas derivadas)
-- ============================================

-- Promedio de ventas por categoría
SELECT 
    categoria,
    ROUND(promedio_precio, 2) AS precio_promedio
FROM (
    SELECT 
        c.nombre AS categoria,
        AVG(p.precio) AS promedio_precio
    FROM categorias c
    INNER JOIN productos p ON c.id = p.categoria_id
    GROUP BY c.id, c.nombre
) AS subconsulta
WHERE promedio_precio > 500;

-- Top 3 clientes por ciudad
SELECT *
FROM (
    SELECT 
        ciudad,
        nombre,
        apellido,
        (SELECT COUNT(*) FROM pedidos p WHERE p.cliente_id = c.id) AS pedidos,
        ROW_NUMBER() OVER (PARTITION BY ciudad ORDER BY (
            SELECT COUNT(*) FROM pedidos p WHERE p.cliente_id = c.id
        ) DESC) AS ranking
    FROM clientes c
) AS ranked
WHERE ranking <= 3;

-- ============================================
-- SUBCONSULTAS CORRELACIONADAS
-- ============================================

-- Una subconsulta correlacionada referencia la consulta externa

-- Productos con precio mayor al promedio de su categoría
SELECT 
    p.nombre,
    p.precio,
    c.nombre AS categoria
FROM productos p
INNER JOIN categorias c ON p.categoria_id = c.id
WHERE p.precio > (
    SELECT AVG(precio)
    FROM productos p2
    WHERE p2.categoria_id = p.categoria_id
);

-- Último pedido de cada cliente
SELECT 
    c.nombre,
    c.apellido,
    (SELECT MAX(fecha_pedido) FROM pedidos p WHERE p.cliente_id = c.id) AS ultimo_pedido
FROM clientes c
WHERE EXISTS (SELECT 1 FROM pedidos p WHERE p.cliente_id = c.id);

-- Productos más vendidos de cada categoría
SELECT 
    p.nombre,
    c.nombre AS categoria,
    (SELECT SUM(cantidad) FROM detalle_pedidos dp WHERE dp.producto_id = p.id) AS vendidos
FROM productos p
INNER JOIN categorias c ON p.categoria_id = c.id
WHERE (
    SELECT SUM(cantidad)
    FROM detalle_pedidos dp
    WHERE dp.producto_id = p.id
) = (
    SELECT MAX(total_vendido)
    FROM (
        SELECT SUM(dp2.cantidad) AS total_vendido
        FROM detalle_pedidos dp2
        INNER JOIN productos p2 ON dp2.producto_id = p2.id
        WHERE p2.categoria_id = p.categoria_id
        GROUP BY dp2.producto_id
    )
);

-- ============================================
-- SUBCONSULTAS CON ANY, ALL
-- ============================================

-- Productos más caros que CUALQUIER producto de categoría 2
SELECT nombre, precio
FROM productos
WHERE precio > ANY (
    SELECT precio
    FROM productos
    WHERE categoria_id = 2
);

-- Productos más caros que TODOS los productos de categoría 2
SELECT nombre, precio
FROM productos
WHERE precio > ALL (
    SELECT precio
    FROM productos
    WHERE categoria_id = 2
);

-- ============================================
-- SUBCONSULTAS ANIDADAS
-- ============================================

-- Clientes que compraron productos de la categoría más cara
SELECT DISTINCT c.nombre, c.apellido
FROM clientes c
INNER JOIN pedidos p ON c.id = p.cliente_id
INNER JOIN detalle_pedidos dp ON p.id = dp.pedido_id
WHERE dp.producto_id IN (
    SELECT id
    FROM productos
    WHERE categoria_id = (
        SELECT categoria_id
        FROM productos
        GROUP BY categoria_id
        ORDER BY AVG(precio) DESC
        LIMIT 1
    )
);

-- ============================================
-- COMMON TABLE EXPRESSIONS (CTE) - WITH
-- ============================================

-- CTE hace las subconsultas más legibles

-- Ventas por producto
WITH ventas_producto AS (
    SELECT 
        producto_id,
        SUM(cantidad) AS total_vendido,
        SUM(subtotal) AS ingresos
    FROM detalle_pedidos
    GROUP BY producto_id
)
SELECT 
    p.nombre,
    COALESCE(v.total_vendido, 0) AS unidades_vendidas,
    COALESCE(v.ingresos, 0) AS ingresos_totales
FROM productos p
LEFT JOIN ventas_producto v ON p.id = v.producto_id
ORDER BY ingresos_totales DESC;

-- Múltiples CTEs
WITH 
clientes_activos AS (
    SELECT id, nombre, apellido
    FROM clientes
    WHERE activo = 1
),
pedidos_recientes AS (
    SELECT cliente_id, COUNT(*) AS total
    FROM pedidos
    WHERE fecha_pedido >= date('now', '-30 days')
    GROUP BY cliente_id
)
SELECT 
    ca.nombre,
    ca.apellido,
    COALESCE(pr.total, 0) AS pedidos_ultimo_mes
FROM clientes_activos ca
LEFT JOIN pedidos_recientes pr ON ca.id = pr.cliente_id
ORDER BY pedidos_ultimo_mes DESC;

-- CTE recursivo (ejemplo: jerarquía)
WITH RECURSIVE numeros(n) AS (
    SELECT 1
    UNION ALL
    SELECT n + 1 FROM numeros WHERE n < 10
)
SELECT n FROM numeros;

-- ============================================
-- CASOS PRÁCTICOS
-- ============================================

-- 1. Productos con ventas superiores al promedio
WITH promedio_ventas AS (
    SELECT AVG(total_vendido) AS promedio
    FROM (
        SELECT producto_id, SUM(cantidad) AS total_vendido
        FROM detalle_pedidos
        GROUP BY producto_id
    )
)
SELECT 
    p.nombre,
    SUM(dp.cantidad) AS vendidos
FROM productos p
INNER JOIN detalle_pedidos dp ON p.id = dp.producto_id
GROUP BY p.id, p.nombre
HAVING SUM(dp.cantidad) > (SELECT promedio FROM promedio_ventas);

-- 2. Clientes que gastaron más que el promedio
SELECT 
    c.nombre,
    c.apellido,
    SUM(p.total) AS total_gastado
FROM clientes c
INNER JOIN pedidos p ON c.id = p.cliente_id
GROUP BY c.id, c.nombre, c.apellido
HAVING SUM(p.total) > (
    SELECT AVG(total_por_cliente)
    FROM (
        SELECT SUM(total) AS total_por_cliente
        FROM pedidos
        GROUP BY cliente_id
    )
);

-- 3. Productos sin stock en categorías activas
SELECT p.nombre, c.nombre AS categoria
FROM productos p
INNER JOIN categorias c ON p.categoria_id = c.id
WHERE p.stock = 0
AND c.id IN (
    SELECT DISTINCT categoria_id
    FROM productos
    WHERE activo = 1
);

-- ============================================
-- CONCEPTOS CLAVE
-- ============================================

/*
1. SUBCONSULTA:
   - Consulta dentro de otra consulta
   - Se ejecuta primero (generalmente)
   - Debe estar entre paréntesis

2. TIPOS DE SUBCONSULTAS:
   - Escalar: Retorna un solo valor
   - Fila: Retorna una fila
   - Tabla: Retorna múltiples filas/columnas
   - Correlacionada: Referencia consulta externa

3. UBICACIÓN:
   - WHERE: Filtrar resultados
   - SELECT: Columnas calculadas
   - FROM: Tabla derivada
   - HAVING: Filtrar grupos

4. IN vs EXISTS:
   - IN: Para listas pequeñas
   - EXISTS: Más eficiente para grandes conjuntos
   - EXISTS se detiene al encontrar coincidencia

5. ANY vs ALL:
   - ANY: Al menos uno cumple condición
   - ALL: Todos cumplen condición
   - SQLite tiene soporte limitado

6. CTE (WITH):
   - Más legible que subconsultas anidadas
   - Se puede referenciar múltiples veces
   - Útil para consultas complejas
   - Puede ser recursivo

7. SUBCONSULTA CORRELACIONADA:
   - Depende de consulta externa
   - Se ejecuta por cada fila externa
   - Más lenta que no correlacionada
   - Útil para comparaciones por grupo

8. Buenas prácticas:
   - Usar CTE para mejor legibilidad
   - EXISTS en lugar de IN cuando sea posible
   - Evitar subconsultas en SELECT si hay alternativa
   - Indexar columnas usadas en subconsultas

9. Rendimiento:
   - Subconsultas no correlacionadas: Rápidas
   - Subconsultas correlacionadas: Lentas
   - JOIN suele ser más rápido que subconsulta
   - CTE puede mejorar rendimiento

10. Cuándo usar subconsultas:
    - Cálculos complejos
    - Filtros dinámicos
    - Comparaciones con agregados
    - Cuando JOIN no es suficiente
*/
