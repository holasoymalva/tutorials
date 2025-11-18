-- ============================================
-- OPTIMIZACIÓN: TRANSACCIONES
-- ============================================

-- Las transacciones garantizan integridad de datos

PRAGMA foreign_keys = ON;

-- ============================================
-- ¿QUÉ ES UNA TRANSACCIÓN?
-- ============================================

/*
Una transacción es un conjunto de operaciones que se ejecutan como una unidad.
O se ejecutan TODAS o NO se ejecuta NINGUNA.

Ejemplo: Transferencia bancaria
- Restar dinero de cuenta A
- Sumar dinero a cuenta B
Ambas operaciones deben completarse o ninguna.
*/

-- ============================================
-- PROPIEDADES ACID
-- ============================================

/*
A - ATOMICITY (Atomicidad):
    Todo o nada. Si falla una operación, se revierten todas.

C - CONSISTENCY (Consistencia):
    La base de datos pasa de un estado válido a otro estado válido.
    Se mantienen todas las restricciones.

I - ISOLATION (Aislamiento):
    Las transacciones son independientes entre sí.
    Una transacción no ve cambios de otra hasta que se complete.

D - DURABILITY (Durabilidad):
    Una vez confirmada, los cambios son permanentes.
    Sobreviven a fallos del sistema.
*/

-- ============================================
-- SINTAXIS BÁSICA
-- ============================================

-- Iniciar transacción
BEGIN TRANSACTION;

-- Operaciones...
UPDATE productos SET stock = stock - 1 WHERE id = 1;
INSERT INTO pedidos (cliente_id, total) VALUES (1, 299.99);

-- Confirmar cambios (hacer permanentes)
COMMIT;

-- O revertir cambios (deshacer todo)
-- ROLLBACK;

-- ============================================
-- EJEMPLO: PROCESAR PEDIDO
-- ============================================

-- Transacción completa para crear un pedido

BEGIN TRANSACTION;

-- 1. Crear el pedido
INSERT INTO pedidos (cliente_id, total, estado)
VALUES (1, 13299.98, 'Procesando');

-- Obtener el ID del pedido recién creado
-- En aplicación real: last_insert_rowid()

-- 2. Agregar detalle del pedido
INSERT INTO detalle_pedidos (pedido_id, producto_id, cantidad, precio_unitario)
VALUES 
    (last_insert_rowid(), 1, 1, 12999.99),
    (last_insert_rowid(), 2, 1, 299.99);

-- 3. Actualizar stock de productos
UPDATE productos SET stock = stock - 1 WHERE id = 1;
UPDATE productos SET stock = stock - 1 WHERE id = 2;

-- 4. Verificar que hay stock suficiente
-- Si algún producto tiene stock negativo, hacer ROLLBACK

-- Si todo está bien, confirmar
COMMIT;

-- Si algo falla, revertir
-- ROLLBACK;

-- ============================================
-- MANEJO DE ERRORES
-- ============================================

-- Ejemplo conceptual (en aplicación real)
/*
BEGIN TRANSACTION;

try {
    -- Operaciones
    UPDATE productos SET stock = stock - 10 WHERE id = 1;
    
    -- Verificar resultado
    if (stock < 0) {
        ROLLBACK;
        return "Stock insuficiente";
    }
    
    COMMIT;
    return "Éxito";
} catch (error) {
    ROLLBACK;
    return "Error: " + error;
}
*/

-- ============================================
-- SAVEPOINTS (Puntos de guardado)
-- ============================================

-- Savepoints permiten revertir parcialmente

BEGIN TRANSACTION;

-- Operación 1
INSERT INTO categorias (nombre) VALUES ('Nueva Categoría');

-- Crear punto de guardado
SAVEPOINT punto1;

-- Operación 2
INSERT INTO productos (nombre, precio, categoria_id) 
VALUES ('Producto Temporal', 99.99, last_insert_rowid());

-- Si algo falla, revertir solo hasta el savepoint
ROLLBACK TO punto1;

-- La categoría se mantiene, el producto se revierte

-- Confirmar todo
COMMIT;

-- ============================================
-- NIVELES DE AISLAMIENTO
-- ============================================

/*
SQLite soporta diferentes niveles de aislamiento:

1. DEFERRED (por defecto):
   - No bloquea hasta que se necesite
   - Permite múltiples lecturas simultáneas

2. IMMEDIATE:
   - Bloquea escritura inmediatamente
   - Permite lecturas simultáneas

3. EXCLUSIVE:
   - Bloquea todo (lectura y escritura)
   - Máximo aislamiento
*/

-- Transacción diferida (por defecto)
BEGIN DEFERRED TRANSACTION;
-- operaciones...
COMMIT;

-- Transacción inmediata
BEGIN IMMEDIATE TRANSACTION;
-- operaciones...
COMMIT;

-- Transacción exclusiva
BEGIN EXCLUSIVE TRANSACTION;
-- operaciones...
COMMIT;

-- ============================================
-- TRANSACCIONES IMPLÍCITAS
-- ============================================

/*
SQLite usa transacciones implícitas:
- Cada comando SQL está en una transacción automática
- Si no usas BEGIN, cada comando es auto-commit

Ejemplo:
UPDATE productos SET precio = 100;  -- Auto-commit

Para mejor rendimiento con múltiples operaciones:
Usar transacción explícita
*/

-- ============================================
-- OPTIMIZACIÓN CON TRANSACCIONES
-- ============================================

-- MAL: Sin transacción (muy lento)
-- Cada INSERT es una transacción separada
INSERT INTO productos (nombre, precio) VALUES ('Producto 1', 100);
INSERT INTO productos (nombre, precio) VALUES ('Producto 2', 200);
INSERT INTO productos (nombre, precio) VALUES ('Producto 3', 300);
-- ... 1000 inserts más

-- BIEN: Con transacción (mucho más rápido)
BEGIN TRANSACTION;
INSERT INTO productos (nombre, precio) VALUES ('Producto 1', 100);
INSERT INTO productos (nombre, precio) VALUES ('Producto 2', 200);
INSERT INTO productos (nombre, precio) VALUES ('Producto 3', 300);
-- ... 1000 inserts más
COMMIT;

-- Puede ser 100x más rápido con transacciones

-- ============================================
-- CASOS PRÁCTICOS
-- ============================================

-- 1. Transferencia de inventario entre almacenes
BEGIN TRANSACTION;

-- Restar de almacén origen
UPDATE productos SET stock = stock - 10 WHERE id = 1;

-- Verificar que no quedó negativo
-- Si stock < 0, hacer ROLLBACK

-- Sumar a almacén destino
-- UPDATE almacen_destino SET stock = stock + 10 WHERE producto_id = 1;

COMMIT;

-- 2. Cancelar pedido (revertir stock)
BEGIN TRANSACTION;

-- Obtener productos del pedido
-- Devolver stock
UPDATE productos 
SET stock = stock + (
    SELECT cantidad 
    FROM detalle_pedidos 
    WHERE pedido_id = 1 AND producto_id = productos.id
)
WHERE id IN (SELECT producto_id FROM detalle_pedidos WHERE pedido_id = 1);

-- Actualizar estado del pedido
UPDATE pedidos SET estado = 'Cancelado' WHERE id = 1;

COMMIT;

-- 3. Importación masiva de datos
BEGIN TRANSACTION;

-- Deshabilitar verificaciones temporalmente (más rápido)
PRAGMA foreign_keys = OFF;

-- Insertar miles de registros
-- INSERT INTO productos ...
-- INSERT INTO productos ...
-- ...

-- Rehabilitar verificaciones
PRAGMA foreign_keys = ON;

COMMIT;

-- ============================================
-- BLOQUEOS (LOCKS)
-- ============================================

/*
SQLite usa bloqueos a nivel de base de datos:

1. UNLOCKED: Sin bloqueo
2. SHARED: Múltiples lecturas simultáneas
3. RESERVED: Preparando para escribir
4. PENDING: Esperando escrituras activas
5. EXCLUSIVE: Bloqueado para escritura

Transacción de lectura: SHARED lock
Transacción de escritura: EXCLUSIVE lock
*/

-- Ver estado de bloqueos
PRAGMA locking_mode;

-- Cambiar modo de bloqueo
PRAGMA locking_mode = EXCLUSIVE;  -- Mantener lock después de transacción
PRAGMA locking_mode = NORMAL;     -- Liberar lock (por defecto)

-- ============================================
-- TIMEOUT DE BLOQUEO
-- ============================================

-- Configurar tiempo de espera para bloqueos (en milisegundos)
PRAGMA busy_timeout = 5000;  -- Esperar 5 segundos

-- ============================================
-- WAL MODE (Write-Ahead Logging)
-- ============================================

/*
WAL mejora concurrencia:
- Lecturas no bloquean escrituras
- Escrituras no bloquean lecturas
- Mejor rendimiento en aplicaciones concurrentes
*/

-- Habilitar WAL mode
PRAGMA journal_mode = WAL;

-- Ver modo actual
PRAGMA journal_mode;

-- Volver a modo normal
PRAGMA journal_mode = DELETE;

-- ============================================
-- MEJORES PRÁCTICAS
-- ============================================

/*
1. USAR TRANSACCIONES:
   - Siempre para operaciones relacionadas
   - Para múltiples INSERT/UPDATE/DELETE
   - Para mantener integridad

2. MANTENER TRANSACCIONES CORTAS:
   - Menos tiempo bloqueado
   - Mejor concurrencia
   - Menos riesgo de deadlock

3. ORDEN CONSISTENTE:
   - Acceder tablas en mismo orden
   - Evita deadlocks
   - Más predecible

4. MANEJO DE ERRORES:
   - Siempre capturar errores
   - ROLLBACK en caso de error
   - No dejar transacciones abiertas

5. VERIFICAR ANTES DE COMMIT:
   - Validar datos
   - Verificar restricciones
   - Confirmar estado válido

6. USAR SAVEPOINTS:
   - Para operaciones complejas
   - Revertir parcialmente
   - Mejor control

7. OPTIMIZACIÓN:
   - Agrupar operaciones en transacciones
   - Usar WAL mode para concurrencia
   - Configurar busy_timeout apropiado

8. NO HACER EN TRANSACCIONES:
   - Operaciones lentas (llamadas API)
   - Esperar input del usuario
   - Operaciones de I/O pesadas
*/

-- ============================================
-- CONCEPTOS CLAVE
-- ============================================

/*
1. TRANSACCIÓN:
   - Unidad atómica de trabajo
   - Todo o nada
   - Garantiza integridad

2. BEGIN/COMMIT/ROLLBACK:
   - BEGIN: Iniciar transacción
   - COMMIT: Confirmar cambios
   - ROLLBACK: Revertir cambios

3. ACID:
   - Atomicity: Todo o nada
   - Consistency: Estado válido
   - Isolation: Independencia
   - Durability: Permanencia

4. SAVEPOINT:
   - Punto de guardado dentro de transacción
   - Permite rollback parcial
   - Útil para operaciones complejas

5. NIVELES DE AISLAMIENTO:
   - DEFERRED: Por defecto
   - IMMEDIATE: Bloqueo temprano
   - EXCLUSIVE: Bloqueo total

6. BLOQUEOS:
   - SHARED: Lectura
   - EXCLUSIVE: Escritura
   - Previenen inconsistencias

7. WAL MODE:
   - Write-Ahead Logging
   - Mejor concurrencia
   - Lecturas no bloquean escrituras

8. BUSY TIMEOUT:
   - Tiempo de espera para bloqueos
   - Evita errores inmediatos
   - Configurable

9. AUTO-COMMIT:
   - Cada comando es transacción
   - Sin BEGIN explícito
   - Menos eficiente para múltiples operaciones

10. DEADLOCK:
    - Dos transacciones esperándose mutuamente
    - Evitar con orden consistente
    - SQLite lo detecta y aborta una
*/

-- ============================================
-- EJERCICIOS
-- ============================================

/*
1. Crear transacción para procesar pedido completo
2. Implementar cancelación de pedido con rollback
3. Importar datos masivos con transacción
4. Manejar errores con savepoints
5. Comparar rendimiento con/sin transacciones
*/

-- ============================================
-- EJEMPLO COMPLETO: SISTEMA DE PEDIDOS
-- ============================================

-- Función conceptual para procesar pedido
/*
FUNCTION procesar_pedido(cliente_id, items[]):
    BEGIN TRANSACTION;
    
    try:
        -- 1. Verificar cliente existe
        if not exists(SELECT 1 FROM clientes WHERE id = cliente_id):
            ROLLBACK;
            return "Cliente no existe";
        
        -- 2. Crear pedido
        INSERT INTO pedidos (cliente_id, total, estado)
        VALUES (cliente_id, 0, 'Procesando');
        
        pedido_id = last_insert_rowid();
        total = 0;
        
        -- 3. Procesar cada item
        for item in items:
            -- Verificar stock
            stock_actual = SELECT stock FROM productos WHERE id = item.producto_id;
            
            if stock_actual < item.cantidad:
                ROLLBACK;
                return "Stock insuficiente para producto " + item.producto_id;
            
            -- Agregar detalle
            INSERT INTO detalle_pedidos (pedido_id, producto_id, cantidad, precio_unitario)
            VALUES (pedido_id, item.producto_id, item.cantidad, item.precio);
            
            -- Actualizar stock
            UPDATE productos 
            SET stock = stock - item.cantidad 
            WHERE id = item.producto_id;
            
            total += item.cantidad * item.precio;
        
        -- 4. Actualizar total del pedido
        UPDATE pedidos SET total = total WHERE id = pedido_id;
        
        -- 5. Confirmar todo
        COMMIT;
        return "Pedido creado: " + pedido_id;
        
    catch error:
        ROLLBACK;
        return "Error: " + error;
*/
