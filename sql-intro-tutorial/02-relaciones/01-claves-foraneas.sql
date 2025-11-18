-- ============================================
-- RELACIONES: CLAVES FORÁNEAS
-- ============================================

-- Las claves foráneas establecen relaciones entre tablas

-- ============================================
-- HABILITAR CLAVES FORÁNEAS EN SQLITE
-- ============================================

-- SQLite requiere habilitar las claves foráneas en cada sesión
PRAGMA foreign_keys = ON;

-- Verificar si están habilitadas
PRAGMA foreign_keys;

-- ============================================
-- EJEMPLO: RELACIÓN UNO A MUCHOS (1:N)
-- ============================================

-- Una categoría puede tener muchos productos
-- Un producto pertenece a una sola categoría

DROP TABLE IF EXISTS pedidos;
DROP TABLE IF EXISTS detalle_pedidos;

-- Tabla de pedidos (relacionada con clientes)
CREATE TABLE pedidos (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    cliente_id INTEGER NOT NULL,
    fecha_pedido TEXT DEFAULT (datetime('now', 'localtime')),
    total REAL DEFAULT 0,
    estado TEXT DEFAULT 'Pendiente',
    
    FOREIGN KEY (cliente_id) REFERENCES clientes(id)
        ON DELETE CASCADE    -- Si se elimina el cliente, se eliminan sus pedidos
        ON UPDATE CASCADE,
    
    CHECK (estado IN ('Pendiente', 'Procesando', 'Enviado', 'Entregado', 'Cancelado'))
);

-- Tabla de detalle de pedidos (relacionada con pedidos y productos)
CREATE TABLE detalle_pedidos (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    pedido_id INTEGER NOT NULL,
    producto_id INTEGER NOT NULL,
    cantidad INTEGER NOT NULL CHECK(cantidad > 0),
    precio_unitario REAL NOT NULL CHECK(precio_unitario >= 0),
    subtotal REAL GENERATED ALWAYS AS (cantidad * precio_unitario) STORED,
    
    FOREIGN KEY (pedido_id) REFERENCES pedidos(id)
        ON DELETE CASCADE,
    FOREIGN KEY (producto_id) REFERENCES productos(id)
        ON DELETE RESTRICT   -- No permite eliminar producto si está en pedidos
);

-- ============================================
-- INSERTAR DATOS CON RELACIONES
-- ============================================

-- Insertar pedidos
INSERT INTO pedidos (cliente_id, total, estado) VALUES
    (1, 13299.98, 'Entregado'),
    (2, 849.98, 'Enviado'),
    (3, 2499.99, 'Procesando'),
    (1, 1699.98, 'Pendiente'),
    (4, 399.99, 'Entregado');

-- Insertar detalles de pedidos
INSERT INTO detalle_pedidos (pedido_id, producto_id, cantidad, precio_unitario) VALUES
    (1, 1, 1, 12999.99),  -- Pedido 1: 1 Laptop
    (1, 2, 1, 299.99),    -- Pedido 1: 1 Mouse
    (2, 3, 1, 899.99),    -- Pedido 2: 1 Teclado
    (3, 4, 1, 2499.99),   -- Pedido 3: 1 Monitor
    (4, 3, 1, 899.99),    -- Pedido 4: 1 Teclado
    (4, 2, 2, 299.99),    -- Pedido 4: 2 Mouse
    (5, 9, 1, 399.99);    -- Pedido 5: 1 Balón

-- ============================================
-- CONSULTAS CON RELACIONES
-- ============================================

-- Ver pedidos con información del cliente
SELECT 
    p.id AS pedido_id,
    c.nombre || ' ' || c.apellido AS cliente,
    p.fecha_pedido,
    p.total,
    p.estado
FROM pedidos p
INNER JOIN clientes c ON p.cliente_id = c.id;

-- Ver detalle de pedidos con productos
SELECT 
    dp.pedido_id,
    pr.nombre AS producto,
    dp.cantidad,
    dp.precio_unitario,
    dp.subtotal
FROM detalle_pedidos dp
INNER JOIN productos pr ON dp.producto_id = pr.id
ORDER BY dp.pedido_id;

-- ============================================
-- ACCIONES DE CLAVES FORÁNEAS
-- ============================================

/*
ON DELETE opciones:
- CASCADE: Elimina registros relacionados automáticamente
- RESTRICT: No permite eliminar si hay registros relacionados
- SET NULL: Pone NULL en la clave foránea
- SET DEFAULT: Pone valor por defecto
- NO ACTION: Similar a RESTRICT (por defecto)

ON UPDATE opciones:
- CASCADE: Actualiza claves foráneas automáticamente
- RESTRICT: No permite actualizar si hay relaciones
- SET NULL: Pone NULL en la clave foránea
- SET DEFAULT: Pone valor por defecto
*/

-- ============================================
-- PROBAR RESTRICCIONES
-- ============================================

-- Intentar eliminar un producto que está en pedidos (debe fallar con RESTRICT)
-- DELETE FROM productos WHERE id = 1;
-- Error: FOREIGN KEY constraint failed

-- Eliminar un cliente con CASCADE (elimina sus pedidos también)
-- DELETE FROM clientes WHERE id = 5;
-- Se eliminan automáticamente sus pedidos y detalles

-- ============================================
-- VERIFICAR INTEGRIDAD REFERENCIAL
-- ============================================

-- Verificar que no haya claves foráneas huérfanas
PRAGMA foreign_key_check;

-- Verificar claves foráneas de una tabla específica
PRAGMA foreign_key_check(pedidos);

-- ============================================
-- CONCEPTOS CLAVE
-- ============================================

/*
1. CLAVE FORÁNEA (Foreign Key):
   - Columna que referencia la clave primaria de otra tabla
   - Mantiene integridad referencial
   - Previene datos huérfanos

2. RELACIÓN UNO A MUCHOS (1:N):
   - La más común en bases de datos
   - Ejemplo: Un cliente tiene muchos pedidos
   - La clave foránea va en el lado "muchos"

3. INTEGRIDAD REFERENCIAL:
   - Garantiza que las relaciones sean válidas
   - No permite valores que no existen en tabla padre
   - Controla qué pasa al eliminar/actualizar

4. PRAGMA foreign_keys:
   - SQLite requiere habilitarlo explícitamente
   - Se debe ejecutar en cada conexión
   - Por defecto está deshabilitado

5. COLUMNAS GENERADAS:
   - GENERATED ALWAYS AS: Columna calculada automáticamente
   - STORED: Se guarda físicamente
   - VIRTUAL: Se calcula al consultar (no disponible en SQLite antiguo)

6. Buenas prácticas:
   - Siempre definir claves foráneas
   - Elegir acción apropiada (CASCADE, RESTRICT, etc.)
   - Indexar columnas de claves foráneas
   - Documentar relaciones en el diseño
*/
