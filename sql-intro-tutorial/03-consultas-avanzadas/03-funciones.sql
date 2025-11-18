-- ============================================
-- CONSULTAS AVANZADAS: FUNCIONES
-- ============================================

PRAGMA foreign_keys = ON;

-- ============================================
-- FUNCIONES DE TEXTO
-- ============================================

-- UPPER / LOWER: Convertir mayúsculas/minúsculas
SELECT 
    nombre,
    UPPER(nombre) AS mayusculas,
    LOWER(nombre) AS minusculas
FROM productos
LIMIT 5;

-- LENGTH: Longitud del texto
SELECT nombre, LENGTH(nombre) AS longitud
FROM productos
ORDER BY longitud DESC
LIMIT 5;

-- SUBSTR: Extraer subcadena
SELECT 
    nombre,
    SUBSTR(nombre, 1, 10) AS primeros_10,
    SUBSTR(nombre, -5) AS ultimos_5
FROM productos
LIMIT 5;

-- TRIM: Eliminar espacios
SELECT 
    '  texto  ' AS original,
    TRIM('  texto  ') AS sin_espacios,
    LTRIM('  texto  ') AS sin_izquierda,
    RTRIM('  texto  ') AS sin_derecha;

-- REPLACE: Reemplazar texto
SELECT 
    nombre,
    REPLACE(nombre, 'Laptop', 'Computadora') AS modificado
FROM productos
WHERE nombre LIKE '%Laptop%';

-- INSTR: Posición de subcadena
SELECT 
    nombre,
    INSTR(nombre, 'de') AS posicion
FROM productos
WHERE INSTR(nombre, 'de') > 0;

-- Concatenación con ||
SELECT 
    nombre || ' - $' || precio AS producto_precio,
    nombre || ' (' || stock || ' disponibles)' AS producto_stock
FROM productos
LIMIT 5;

-- ============================================
-- FUNCIONES NUMÉRICAS
-- ============================================

-- ROUND: Redondear
SELECT 
    precio,
    ROUND(precio) AS redondeado,
    ROUND(precio, 1) AS un_decimal,
    ROUND(precio * 1.16, 2) AS con_iva
FROM productos
LIMIT 5;

-- ABS: Valor absoluto
SELECT 
    precio,
    precio - 1000 AS diferencia,
    ABS(precio - 1000) AS diferencia_absoluta
FROM productos
LIMIT 5;

-- CAST: Convertir tipos
SELECT 
    precio,
    CAST(precio AS INTEGER) AS precio_entero,
    CAST(stock AS REAL) AS stock_real,
    CAST(precio AS TEXT) AS precio_texto
FROM productos
LIMIT 5;

-- Operaciones matemáticas
SELECT 
    precio,
    precio * 1.16 AS con_iva,
    precio * 0.85 AS con_descuento,
    precio / 12 AS mensualidad,
    precio % 100 AS modulo
FROM productos
LIMIT 5;

-- ============================================
-- FUNCIONES DE FECHA Y HORA
-- ============================================

-- Fecha y hora actual
SELECT 
    date('now') AS fecha_hoy,
    time('now') AS hora_actual,
    datetime('now') AS fecha_hora,
    datetime('now', 'localtime') AS fecha_hora_local;

-- Formatear fechas con strftime
SELECT 
    fecha_pedido,
    strftime('%Y', fecha_pedido) AS año,
    strftime('%m', fecha_pedido) AS mes,
    strftime('%d', fecha_pedido) AS dia,
    strftime('%Y-%m', fecha_pedido) AS año_mes,
    strftime('%d/%m/%Y', fecha_pedido) AS formato_latino,
    strftime('%W', fecha_pedido) AS semana_del_año
FROM pedidos
LIMIT 5;

-- Operaciones con fechas
SELECT 
    fecha_pedido,
    date(fecha_pedido, '+7 days') AS en_una_semana,
    date(fecha_pedido, '-1 month') AS hace_un_mes,
    date(fecha_pedido, '+1 year') AS en_un_año,
    date(fecha_pedido, 'start of month') AS inicio_mes,
    date(fecha_pedido, 'start of year') AS inicio_año
FROM pedidos
LIMIT 5;

-- Diferencia entre fechas (en días)
SELECT 
    fecha_pedido,
    julianday('now') - julianday(fecha_pedido) AS dias_desde_pedido,
    CAST(julianday('now') - julianday(fecha_pedido) AS INTEGER) AS dias_enteros
FROM pedidos
LIMIT 5;

-- Día de la semana
SELECT 
    fecha_pedido,
    CASE CAST(strftime('%w', fecha_pedido) AS INTEGER)
        WHEN 0 THEN 'Domingo'
        WHEN 1 THEN 'Lunes'
        WHEN 2 THEN 'Martes'
        WHEN 3 THEN 'Miércoles'
        WHEN 4 THEN 'Jueves'
        WHEN 5 THEN 'Viernes'
        WHEN 6 THEN 'Sábado'
    END AS dia_semana
FROM pedidos
LIMIT 5;

-- ============================================
-- FUNCIONES DE AGREGACIÓN
-- ============================================

-- Ya vistas en 01-agregaciones.sql, aquí algunos ejemplos adicionales

-- GROUP_CONCAT: Concatenar valores agrupados
SELECT 
    c.nombre AS categoria,
    GROUP_CONCAT(p.nombre, ' | ') AS productos
FROM categorias c
INNER JOIN productos p ON c.id = p.categoria_id
GROUP BY c.id, c.nombre;

-- TOTAL: Como SUM pero retorna 0.0 en lugar de NULL
SELECT 
    categoria_id,
    SUM(stock) AS suma_normal,
    TOTAL(stock) AS suma_total
FROM productos
GROUP BY categoria_id;

-- ============================================
-- FUNCIONES CONDICIONALES
-- ============================================

-- CASE: Lógica condicional
SELECT 
    nombre,
    precio,
    CASE 
        WHEN precio < 300 THEN 'Económico'
        WHEN precio < 1000 THEN 'Medio'
        WHEN precio < 3000 THEN 'Alto'
        ELSE 'Premium'
    END AS rango_precio,
    CASE 
        WHEN stock = 0 THEN '❌ Agotado'
        WHEN stock < 10 THEN '⚠️ Bajo'
        WHEN stock < 30 THEN '✓ Medio'
        ELSE '✓✓ Alto'
    END AS estado_stock
FROM productos;

-- IIF: IF inline (SQLite 3.32+)
SELECT 
    nombre,
    stock,
    IIF(stock > 0, 'Disponible', 'Agotado') AS disponibilidad
FROM productos
LIMIT 5;

-- COALESCE: Primer valor no nulo
SELECT 
    nombre,
    COALESCE(descripcion, 'Sin descripción') AS descripcion,
    COALESCE(categoria_id, 0) AS categoria
FROM productos
LIMIT 5;

-- NULLIF: Retorna NULL si son iguales
SELECT 
    nombre,
    stock,
    NULLIF(stock, 0) AS stock_o_null,
    precio / NULLIF(stock, 0) AS precio_por_unidad
FROM productos
LIMIT 5;

-- ============================================
-- FUNCIONES DE VENTANA (Window Functions)
-- ============================================

-- ROW_NUMBER: Número de fila
SELECT 
    nombre,
    precio,
    ROW_NUMBER() OVER (ORDER BY precio DESC) AS ranking
FROM productos
LIMIT 10;

-- RANK: Ranking con empates
SELECT 
    nombre,
    precio,
    RANK() OVER (ORDER BY precio DESC) AS ranking,
    DENSE_RANK() OVER (ORDER BY precio DESC) AS ranking_denso
FROM productos
LIMIT 10;

-- PARTITION BY: Ranking por grupo
SELECT 
    c.nombre AS categoria,
    p.nombre AS producto,
    p.precio,
    ROW_NUMBER() OVER (PARTITION BY c.id ORDER BY p.precio DESC) AS ranking_categoria
FROM productos p
INNER JOIN categorias c ON p.categoria_id = c.id
ORDER BY c.nombre, ranking_categoria;

-- LAG / LEAD: Valor anterior/siguiente
SELECT 
    nombre,
    precio,
    LAG(precio) OVER (ORDER BY precio) AS precio_anterior,
    LEAD(precio) OVER (ORDER BY precio) AS precio_siguiente,
    precio - LAG(precio) OVER (ORDER BY precio) AS diferencia
FROM productos
LIMIT 10;

-- FIRST_VALUE / LAST_VALUE
SELECT 
    nombre,
    precio,
    FIRST_VALUE(precio) OVER (ORDER BY precio) AS precio_minimo,
    LAST_VALUE(precio) OVER (ORDER BY precio ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS precio_maximo
FROM productos
LIMIT 10;

-- ============================================
-- FUNCIONES PERSONALIZADAS (Ejemplos conceptuales)
-- ============================================

-- SQLite permite crear funciones personalizadas en código
-- Aquí mostramos cómo se usarían (requieren implementación en aplicación)

/*
-- Ejemplo de uso de función personalizada
SELECT 
    nombre,
    precio,
    calcular_descuento(precio, 0.15) AS precio_descuento
FROM productos;

-- Función para validar email
SELECT 
    email,
    validar_email(email) AS es_valido
FROM clientes;
*/

-- ============================================
-- CASOS PRÁCTICOS COMBINADOS
-- ============================================

-- 1. Reporte de productos con análisis completo
SELECT 
    p.nombre,
    c.nombre AS categoria,
    '$' || ROUND(p.precio, 2) AS precio_formateado,
    p.stock,
    CASE 
        WHEN p.stock = 0 THEN 'Agotado'
        WHEN p.stock < 20 THEN 'Bajo'
        ELSE 'Disponible'
    END AS estado,
    COALESCE(ventas.total, 0) AS unidades_vendidas,
    ROUND(p.precio * p.stock, 2) AS valor_inventario,
    ROW_NUMBER() OVER (PARTITION BY c.id ORDER BY p.precio DESC) AS ranking_categoria
FROM productos p
INNER JOIN categorias c ON p.categoria_id = c.id
LEFT JOIN (
    SELECT producto_id, SUM(cantidad) AS total
    FROM detalle_pedidos
    GROUP BY producto_id
) ventas ON p.id = ventas.producto_id
ORDER BY c.nombre, ranking_categoria;

-- 2. Análisis temporal de pedidos
SELECT 
    strftime('%Y-%m', fecha_pedido) AS mes,
    COUNT(*) AS total_pedidos,
    ROUND(AVG(total), 2) AS ticket_promedio,
    ROUND(SUM(total), 2) AS ingresos,
    LAG(SUM(total)) OVER (ORDER BY strftime('%Y-%m', fecha_pedido)) AS ingresos_mes_anterior,
    ROUND(
        (SUM(total) - LAG(SUM(total)) OVER (ORDER BY strftime('%Y-%m', fecha_pedido))) * 100.0 / 
        NULLIF(LAG(SUM(total)) OVER (ORDER BY strftime('%Y-%m', fecha_pedido)), 0),
        2
    ) AS crecimiento_porcentual
FROM pedidos
GROUP BY strftime('%Y-%m', fecha_pedido)
ORDER BY mes DESC;

-- 3. Clientes con formato completo
SELECT 
    UPPER(SUBSTR(nombre, 1, 1)) || LOWER(SUBSTR(nombre, 2)) || ' ' ||
    UPPER(SUBSTR(apellido, 1, 1)) || LOWER(SUBSTR(apellido, 2)) AS nombre_completo,
    LOWER(email) AS email,
    COALESCE(telefono, 'Sin teléfono') AS telefono,
    ciudad || ', ' || pais AS ubicacion,
    CAST(julianday('now') - julianday(fecha_registro) AS INTEGER) || ' días' AS antiguedad,
    CASE 
        WHEN activo = 1 THEN '✓ Activo'
        ELSE '✗ Inactivo'
    END AS estado
FROM clientes
ORDER BY fecha_registro DESC;

-- ============================================
-- CONCEPTOS CLAVE
-- ============================================

/*
1. FUNCIONES DE TEXTO:
   - UPPER/LOWER: Cambiar caso
   - LENGTH: Longitud
   - SUBSTR: Extraer parte
   - TRIM: Eliminar espacios
   - REPLACE: Reemplazar texto
   - ||: Concatenar

2. FUNCIONES NUMÉRICAS:
   - ROUND: Redondear
   - ABS: Valor absoluto
   - CAST: Convertir tipos
   - Operadores: +, -, *, /, %

3. FUNCIONES DE FECHA:
   - date/time/datetime: Obtener fecha/hora
   - strftime: Formatear fechas
   - julianday: Calcular diferencias
   - Modificadores: '+1 day', '-1 month', etc.

4. FUNCIONES CONDICIONALES:
   - CASE: Lógica compleja
   - IIF: IF simple
   - COALESCE: Primer no nulo
   - NULLIF: NULL si iguales

5. FUNCIONES DE VENTANA:
   - ROW_NUMBER: Número secuencial
   - RANK: Ranking con empates
   - LAG/LEAD: Valores anteriores/siguientes
   - PARTITION BY: Agrupar ventanas
   - FIRST_VALUE/LAST_VALUE: Primero/último

6. strftime formatos comunes:
   - %Y: Año (4 dígitos)
   - %m: Mes (01-12)
   - %d: Día (01-31)
   - %H: Hora (00-23)
   - %M: Minuto (00-59)
   - %S: Segundo (00-59)
   - %w: Día semana (0-6)
   - %W: Semana del año

7. Modificadores de fecha:
   - '+N days/months/years'
   - '-N days/months/years'
   - 'start of month/year'
   - 'weekday N'
   - 'localtime'

8. Buenas prácticas:
   - Usar funciones para formateo
   - COALESCE para manejar NULL
   - CAST para conversiones explícitas
   - Funciones de ventana para rankings
   - strftime para análisis temporal

9. Rendimiento:
   - Funciones en WHERE pueden ser lentas
   - Indexar columnas antes de aplicar funciones
   - Funciones de ventana son eficientes
   - Evitar funciones en columnas indexadas

10. Compatibilidad:
    - SQLite tiene menos funciones que otros DBMS
    - Algunas funciones requieren versiones recientes
    - Funciones personalizadas requieren código
*/
