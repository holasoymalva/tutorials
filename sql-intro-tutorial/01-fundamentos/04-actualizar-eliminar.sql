-- ============================================
-- FUNDAMENTOS DE SQL: ACTUALIZAR Y ELIMINAR (DML)
-- ============================================

-- ============================================
-- UPDATE: Actualizar registros existentes
-- ============================================

-- Actualizar un solo registro por ID
UPDATE productos 
SET precio = 11999.99 
WHERE id = 1;

-- Actualizar múltiples columnas
UPDATE productos 
SET precio = 279.99, stock = 55 
WHERE id = 2;

-- Actualizar con cálculos
UPDATE productos 
SET precio = precio * 1.10  -- Incrementar precio 10%
WHERE categoria_id = 1;

-- Actualizar basado en condición
UPDATE productos 
SET activo = 0 
WHERE stock = 0;

-- Actualizar con subconsulta
UPDATE productos 
SET precio = precio * 0.9 
WHERE categoria_id IN (SELECT id FROM categorias WHERE nombre = 'Ropa');

-- ============================================
-- DELETE: Eliminar registros
-- ============================================

-- Eliminar un registro específico
DELETE FROM productos WHERE id = 100;

-- Eliminar con condición
DELETE FROM productos WHERE stock = 0 AND activo = 0;

-- Eliminar registros antiguos
DELETE FROM clientes 
WHERE fecha_registro < date('now', '-2 years');

-- ============================================
-- PRECAUCIÓN: UPDATE y DELETE sin WHERE
-- ============================================

-- ¡PELIGRO! Esto actualiza TODOS los registros
-- UPDATE productos SET precio = 0;

-- ¡PELIGRO! Esto elimina TODOS los registros
-- DELETE FROM productos;

-- Siempre usa WHERE a menos que realmente quieras afectar todos los registros

-- ============================================
-- TRUNCATE (en SQLite se usa DELETE)
-- ============================================

-- Vaciar tabla completamente (más rápido que DELETE)
-- DELETE FROM productos;

-- Reiniciar el contador de autoincremento
-- DELETE FROM sqlite_sequence WHERE name = 'productos';

-- ============================================
-- EJEMPLOS PRÁCTICOS
-- ============================================

-- 1. Desactivar productos sin stock
UPDATE productos 
SET activo = 0 
WHERE stock = 0;

-- 2. Aplicar descuento a categoría específica
UPDATE productos 
SET precio = ROUND(precio * 0.85, 2) 
WHERE categoria_id = 2;

-- 3. Actualizar información de cliente
UPDATE clientes 
SET telefono = '5559876543', ciudad = 'Tijuana' 
WHERE email = 'juan.perez@email.com';

-- 4. Incrementar stock después de recibir inventario
UPDATE productos 
SET stock = stock + 50 
WHERE id IN (1, 2, 3);

-- 5. Eliminar clientes inactivos sin compras
DELETE FROM clientes 
WHERE activo = 0 
AND id NOT IN (SELECT DISTINCT cliente_id FROM pedidos);

-- ============================================
-- VERIFICAR CAMBIOS
-- ============================================

-- Ver productos actualizados
SELECT id, nombre, precio, stock, activo FROM productos;

-- Ver clientes actualizados
SELECT id, nombre, apellido, email, telefono, ciudad FROM clientes;

-- Contar registros afectados
SELECT changes() AS registros_afectados;

-- ============================================
-- CONCEPTOS CLAVE
-- ============================================

/*
1. UPDATE: Modificar registros existentes
   Sintaxis: UPDATE tabla SET columna = valor WHERE condición;
   
2. DELETE: Eliminar registros
   Sintaxis: DELETE FROM tabla WHERE condición;

3. WHERE es CRÍTICO:
   - Sin WHERE afecta TODOS los registros
   - Siempre verifica tu condición primero con SELECT

4. Buenas prácticas:
   - Siempre usar WHERE (excepto casos específicos)
   - Probar con SELECT antes de UPDATE/DELETE
   - Usar transacciones para cambios importantes
   - Hacer respaldo antes de operaciones masivas

5. Funciones útiles:
   - changes(): Número de filas afectadas por último comando
   - last_insert_rowid(): ID del último registro insertado

6. Soft Delete vs Hard Delete:
   - Hard Delete: DELETE FROM (elimina físicamente)
   - Soft Delete: UPDATE SET activo = 0 (marca como inactivo)
   - Soft Delete es preferible para mantener historial

7. Orden de ejecución:
   FROM → WHERE → UPDATE/DELETE

8. TRUNCATE vs DELETE:
   - DELETE: Elimina fila por fila, más lento
   - TRUNCATE: Vacía tabla completa, más rápido
   - SQLite no tiene TRUNCATE, usa DELETE
*/

-- ============================================
-- EJERCICIOS PRÁCTICOS
-- ============================================

-- 1. Aumentar 5% el precio de productos de categoría Electrónica
-- UPDATE productos SET precio = precio * 1.05 WHERE categoria_id = 1;

-- 2. Desactivar clientes sin teléfono
-- UPDATE clientes SET activo = 0 WHERE telefono IS NULL;

-- 3. Eliminar productos descontinuados (activo = 0 y stock = 0)
-- DELETE FROM productos WHERE activo = 0 AND stock = 0;

-- 4. Actualizar ciudad de todos los clientes de 'CDMX' a 'Ciudad de México'
-- UPDATE clientes SET ciudad = 'Ciudad de México' WHERE ciudad = 'CDMX';

-- 5. Reducir stock en 1 para productos vendidos
-- UPDATE productos SET stock = stock - 1 WHERE id = ?;
