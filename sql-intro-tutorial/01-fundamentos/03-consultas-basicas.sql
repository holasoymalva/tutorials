-- ============================================
-- FUNDAMENTOS DE SQL: CONSULTAS BÁSICAS (DQL)
-- ============================================

-- DQL (Data Query Language) se usa para consultar datos

-- ============================================
-- SELECT: Consulta básica
-- ============================================

-- Seleccionar todas las columnas
SELECT * FROM productos;

-- Seleccionar columnas específicas
SELECT nombre, precio FROM productos;

-- Seleccionar con alias (renombrar columnas)
SELECT 
    nombre AS producto,
    precio AS precio_actual,
    precio * 0.9 AS precio_descuento
FROM productos;

-- ============================================
-- WHERE: Filtrar resultados
-- ============================================

-- Filtro simple
SELECT * FROM productos WHERE precio > 1000;

-- Múltiples condiciones con AND
SELECT * FROM productos 
WHERE precio > 500 AND stock > 20;

-- Múltiples condiciones con OR
SELECT * FROM productos 
WHERE categoria_id = 1 OR categoria_id = 2;

-- Operador IN (más limpio que múltiples OR)
SELECT * FROM productos 
WHERE categoria_id IN (1, 2, 3);

-- Operador BETWEEN (rango inclusivo)
SELECT * FROM productos 
WHERE precio BETWEEN 300 AND 1000;

-- Operador LIKE (búsqueda de patrones)
SELECT * FROM productos WHERE nombre LIKE '%Laptop%';  -- Contiene "Laptop"
SELECT * FROM productos WHERE nombre LIKE 'Mouse%';    -- Empieza con "Mouse"
SELECT * FROM productos WHERE nombre LIKE '%RGB';      -- Termina con "RGB"

-- Operador NOT
SELECT * FROM productos WHERE NOT categoria_id = 1;
SELECT * FROM productos WHERE precio NOT BETWEEN 300 AND 1000;

-- IS NULL / IS NOT NULL
SELECT * FROM productos WHERE descripcion IS NULL;
SELECT * FROM productos WHERE descripcion IS NOT NULL;

-- ============================================
-- ORDER BY: Ordenar resultados
-- ============================================

-- Orden ascendente (por defecto)
SELECT * FROM productos ORDER BY precio;
SELECT * FROM productos ORDER BY precio ASC;

-- Orden descendente
SELECT * FROM productos ORDER BY precio DESC;

-- Ordenar por múltiples columnas
SELECT * FROM productos 
ORDER BY categoria_id ASC, precio DESC;

-- Ordenar por alias
SELECT nombre, precio * 0.9 AS precio_descuento
FROM productos
ORDER BY precio_descuento DESC;

-- ============================================
-- LIMIT: Limitar número de resultados
-- ============================================

-- Primeros 5 productos
SELECT * FROM productos LIMIT 5;

-- Productos más caros (top 3)
SELECT nombre, precio FROM productos 
ORDER BY precio DESC 
LIMIT 3;

-- OFFSET: Saltar registros (útil para paginación)
SELECT * FROM productos LIMIT 5 OFFSET 5;  -- Registros 6-10

-- Paginación: Página 2, 5 registros por página
SELECT * FROM productos 
ORDER BY id
LIMIT 5 OFFSET 5;

-- ============================================
-- DISTINCT: Eliminar duplicados
-- ============================================

-- Categorías únicas de productos
SELECT DISTINCT categoria_id FROM productos;

-- Ciudades únicas de clientes
SELECT DISTINCT ciudad FROM clientes;

-- Combinación única de columnas
SELECT DISTINCT categoria_id, activo FROM productos;

-- ============================================
-- OPERADORES ARITMÉTICOS
-- ============================================

-- Calcular precio con IVA (16%)
SELECT 
    nombre,
    precio AS precio_sin_iva,
    precio * 1.16 AS precio_con_iva,
    ROUND(precio * 1.16, 2) AS precio_redondeado
FROM productos;

-- Calcular valor del inventario
SELECT 
    nombre,
    precio,
    stock,
    precio * stock AS valor_inventario
FROM productos;

-- ============================================
-- FUNCIONES DE TEXTO
-- ============================================

-- Convertir a mayúsculas/minúsculas
SELECT 
    nombre,
    UPPER(nombre) AS mayusculas,
    LOWER(nombre) AS minusculas
FROM productos;

-- Longitud del texto
SELECT nombre, LENGTH(nombre) AS longitud FROM productos;

-- Concatenar texto
SELECT 
    nombre || ' - $' || precio AS producto_precio
FROM productos;

-- Extraer subcadena
SELECT 
    nombre,
    SUBSTR(nombre, 1, 10) AS nombre_corto
FROM productos;

-- Reemplazar texto
SELECT 
    nombre,
    REPLACE(nombre, 'Laptop', 'Computadora') AS nombre_modificado
FROM productos;

-- ============================================
-- FUNCIONES NUMÉRICAS
-- ============================================

-- Redondear
SELECT 
    precio,
    ROUND(precio) AS redondeado,
    ROUND(precio, 1) AS un_decimal
FROM productos;

-- Valor absoluto
SELECT ABS(-100) AS valor_absoluto;

-- Máximo y mínimo entre valores
SELECT MAX(10, 20, 5) AS maximo;
SELECT MIN(10, 20, 5) AS minimo;

-- ============================================
-- CASE: Lógica condicional
-- ============================================

-- Clasificar productos por precio
SELECT 
    nombre,
    precio,
    CASE 
        WHEN precio < 500 THEN 'Económico'
        WHEN precio BETWEEN 500 AND 2000 THEN 'Medio'
        ELSE 'Premium'
    END AS categoria_precio
FROM productos;

-- Estado del stock
SELECT 
    nombre,
    stock,
    CASE 
        WHEN stock = 0 THEN 'Agotado'
        WHEN stock < 10 THEN 'Stock Bajo'
        WHEN stock < 30 THEN 'Stock Medio'
        ELSE 'Stock Alto'
    END AS estado_stock
FROM productos;

-- ============================================
-- CONSULTAS COMBINADAS
-- ============================================

-- Ejemplo completo: Productos en oferta
SELECT 
    nombre AS producto,
    precio AS precio_original,
    ROUND(precio * 0.85, 2) AS precio_oferta,
    ROUND(precio * 0.15, 2) AS ahorro,
    stock,
    CASE 
        WHEN stock > 50 THEN 'Disponible'
        WHEN stock > 0 THEN 'Últimas unidades'
        ELSE 'Agotado'
    END AS disponibilidad
FROM productos
WHERE precio > 300 AND activo = 1
ORDER BY precio DESC
LIMIT 10;

-- ============================================
-- CONCEPTOS CLAVE
-- ============================================

/*
1. SELECT: Recuperar datos de la base de datos
   - * selecciona todas las columnas
   - Especificar columnas es más eficiente

2. WHERE: Filtrar registros
   - Operadores: =, !=, <, >, <=, >=
   - Lógicos: AND, OR, NOT
   - Especiales: IN, BETWEEN, LIKE, IS NULL

3. ORDER BY: Ordenar resultados
   - ASC: Ascendente (por defecto)
   - DESC: Descendente

4. LIMIT: Limitar número de resultados
   - OFFSET: Saltar registros (paginación)

5. DISTINCT: Eliminar duplicados

6. Operadores LIKE:
   - %: Cualquier secuencia de caracteres
   - _: Un solo carácter
   - Ejemplo: 'A%' = empieza con A
   - Ejemplo: '%Z' = termina con Z
   - Ejemplo: '%SQL%' = contiene SQL

7. CASE: Lógica condicional (similar a if-else)

8. Funciones comunes:
   - Texto: UPPER, LOWER, LENGTH, SUBSTR, REPLACE
   - Numéricas: ROUND, ABS, MAX, MIN
   - Fecha: datetime, date, time

9. Alias (AS): Renombrar columnas o tablas
   - Hace las consultas más legibles
   - Necesario para columnas calculadas

10. Orden de ejecución SQL:
    FROM → WHERE → SELECT → ORDER BY → LIMIT
*/

-- ============================================
-- EJERCICIOS PRÁCTICOS
-- ============================================

-- 1. Productos con precio mayor a 1000 ordenados por nombre
-- SELECT nombre, precio FROM productos WHERE precio > 1000 ORDER BY nombre;

-- 2. Clientes de Ciudad de México
-- SELECT * FROM clientes WHERE ciudad = 'Ciudad de México';

-- 3. Top 5 productos más caros
-- SELECT nombre, precio FROM productos ORDER BY precio DESC LIMIT 5;

-- 4. Productos cuyo nombre contiene "de"
-- SELECT * FROM productos WHERE nombre LIKE '%de%';

-- 5. Productos con stock bajo (menos de 20 unidades)
-- SELECT nombre, stock FROM productos WHERE stock < 20 ORDER BY stock;
