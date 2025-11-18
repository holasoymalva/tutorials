-- ============================================
-- RELACIONES: MUCHOS A MUCHOS (N:M)
-- ============================================

-- Una relación muchos a muchos requiere una tabla intermedia (tabla puente)

PRAGMA foreign_keys = ON;

-- ============================================
-- EJEMPLO: PRODUCTOS Y ETIQUETAS
-- ============================================

-- Un producto puede tener múltiples etiquetas
-- Una etiqueta puede estar en múltiples productos

DROP TABLE IF EXISTS etiquetas;
DROP TABLE IF EXISTS productos_etiquetas;

-- Tabla de etiquetas
CREATE TABLE etiquetas (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre TEXT NOT NULL UNIQUE,
    descripcion TEXT,
    fecha_creacion TEXT DEFAULT (datetime('now', 'localtime'))
);

-- Tabla intermedia (tabla puente)
CREATE TABLE productos_etiquetas (
    producto_id INTEGER NOT NULL,
    etiqueta_id INTEGER NOT NULL,
    fecha_asignacion TEXT DEFAULT (datetime('now', 'localtime')),
    
    PRIMARY KEY (producto_id, etiqueta_id),  -- Clave primaria compuesta
    FOREIGN KEY (producto_id) REFERENCES productos(id) ON DELETE CASCADE,
    FOREIGN KEY (etiqueta_id) REFERENCES etiquetas(id) ON DELETE CASCADE
);

-- ============================================
-- INSERTAR DATOS
-- ============================================

-- Insertar etiquetas
INSERT INTO etiquetas (nombre, descripcion) VALUES
    ('Oferta', 'Productos en oferta especial'),
    ('Nuevo', 'Productos recién llegados'),
    ('Popular', 'Productos más vendidos'),
    ('Descuento', 'Productos con descuento'),
    ('Premium', 'Productos de alta gama'),
    ('Eco-Friendly', 'Productos ecológicos'),
    ('Importado', 'Productos importados');

-- Asignar etiquetas a productos
INSERT INTO productos_etiquetas (producto_id, etiqueta_id) VALUES
    (1, 2),  -- Laptop: Nuevo
    (1, 5),  -- Laptop: Premium
    (2, 1),  -- Mouse: Oferta
    (2, 3),  -- Mouse: Popular
    (3, 3),  -- Teclado: Popular
    (3, 5),  -- Teclado: Premium
    (4, 2),  -- Monitor: Nuevo
    (5, 1),  -- Camiseta: Oferta
    (5, 4),  -- Camiseta: Descuento
    (9, 3);  -- Balón: Popular

-- ============================================
-- CONSULTAS CON RELACIONES N:M
-- ============================================

-- 1. Productos con sus etiquetas
SELECT 
    p.nombre AS producto,
    e.nombre AS etiqueta
FROM productos p
INNER JOIN productos_etiquetas pe ON p.id = pe.producto_id
INNER JOIN etiquetas e ON pe.etiqueta_id = e.id
ORDER BY p.nombre;

-- 2. Productos con múltiples etiquetas (concatenadas)
SELECT 
    p.id,
    p.nombre AS producto,
    GROUP_CONCAT(e.nombre, ', ') AS etiquetas
FROM productos p
LEFT JOIN productos_etiquetas pe ON p.id = pe.producto_id
LEFT JOIN etiquetas e ON pe.etiqueta_id = e.id
GROUP BY p.id, p.nombre;

-- 3. Contar etiquetas por producto
SELECT 
    p.nombre AS producto,
    COUNT(pe.etiqueta_id) AS total_etiquetas
FROM productos p
LEFT JOIN productos_etiquetas pe ON p.id = pe.producto_id
GROUP BY p.id, p.nombre
ORDER BY total_etiquetas DESC;

-- 4. Productos con etiqueta específica
SELECT 
    p.nombre AS producto,
    p.precio
FROM productos p
INNER JOIN productos_etiquetas pe ON p.id = pe.producto_id
INNER JOIN etiquetas e ON pe.etiqueta_id = e.id
WHERE e.nombre = 'Popular';

-- 5. Etiquetas más usadas
SELECT 
    e.nombre AS etiqueta,
    COUNT(pe.producto_id) AS total_productos
FROM etiquetas e
LEFT JOIN productos_etiquetas pe ON e.id = pe.etiqueta_id
GROUP BY e.id, e.nombre
ORDER BY total_productos DESC;

-- 6. Productos sin etiquetas
SELECT 
    p.id,
    p.nombre,
    p.precio
FROM productos p
LEFT JOIN productos_etiquetas pe ON p.id = pe.producto_id
WHERE pe.etiqueta_id IS NULL;

-- 7. Productos con múltiples etiquetas específicas (AND)
SELECT p.nombre
FROM productos p
WHERE EXISTS (
    SELECT 1 FROM productos_etiquetas pe
    JOIN etiquetas e ON pe.etiqueta_id = e.id
    WHERE pe.producto_id = p.id AND e.nombre = 'Popular'
)
AND EXISTS (
    SELECT 1 FROM productos_etiquetas pe
    JOIN etiquetas e ON pe.etiqueta_id = e.id
    WHERE pe.producto_id = p.id AND e.nombre = 'Premium'
);

-- ============================================
-- OPERACIONES CON RELACIONES N:M
-- ============================================

-- Agregar etiqueta a producto
INSERT INTO productos_etiquetas (producto_id, etiqueta_id)
VALUES (1, 3);  -- Laptop ahora es Popular

-- Eliminar etiqueta de producto
DELETE FROM productos_etiquetas
WHERE producto_id = 2 AND etiqueta_id = 1;

-- Reemplazar todas las etiquetas de un producto
DELETE FROM productos_etiquetas WHERE producto_id = 5;
INSERT INTO productos_etiquetas (producto_id, etiqueta_id) VALUES
    (5, 1),
    (5, 4),
    (5, 6);

-- ============================================
-- EJEMPLO 2: AUTORES Y LIBROS
-- ============================================

DROP TABLE IF EXISTS autores;
DROP TABLE IF EXISTS libros;
DROP TABLE IF EXISTS libros_autores;

CREATE TABLE autores (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre TEXT NOT NULL,
    apellido TEXT NOT NULL,
    pais TEXT,
    fecha_nacimiento TEXT
);

CREATE TABLE libros (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    titulo TEXT NOT NULL,
    isbn TEXT UNIQUE,
    año_publicacion INTEGER,
    precio REAL
);

CREATE TABLE libros_autores (
    libro_id INTEGER NOT NULL,
    autor_id INTEGER NOT NULL,
    orden INTEGER DEFAULT 1,  -- Para coautores: orden de aparición
    
    PRIMARY KEY (libro_id, autor_id),
    FOREIGN KEY (libro_id) REFERENCES libros(id) ON DELETE CASCADE,
    FOREIGN KEY (autor_id) REFERENCES autores(id) ON DELETE CASCADE
);

-- Insertar datos
INSERT INTO autores (nombre, apellido, pais) VALUES
    ('Gabriel', 'García Márquez', 'Colombia'),
    ('Isabel', 'Allende', 'Chile'),
    ('Jorge Luis', 'Borges', 'Argentina'),
    ('Octavio', 'Paz', 'México');

INSERT INTO libros (titulo, isbn, año_publicacion, precio) VALUES
    ('Cien años de soledad', '978-0307474728', 1967, 299.99),
    ('El amor en los tiempos del cólera', '978-0307387738', 1985, 279.99),
    ('La casa de los espíritus', '978-1501117015', 1982, 259.99),
    ('Ficciones', '978-0802130303', 1944, 199.99);

INSERT INTO libros_autores (libro_id, autor_id, orden) VALUES
    (1, 1, 1),  -- Cien años de soledad - García Márquez
    (2, 1, 1),  -- El amor... - García Márquez
    (3, 2, 1),  -- La casa... - Isabel Allende
    (4, 3, 1);  -- Ficciones - Borges

-- Consulta: Libros con sus autores
SELECT 
    l.titulo,
    a.nombre || ' ' || a.apellido AS autor,
    l.año_publicacion
FROM libros l
INNER JOIN libros_autores la ON l.id = la.libro_id
INNER JOIN autores a ON la.autor_id = a.id
ORDER BY l.titulo;

-- Consulta: Autores con cantidad de libros
SELECT 
    a.nombre || ' ' || a.apellido AS autor,
    COUNT(la.libro_id) AS total_libros
FROM autores a
LEFT JOIN libros_autores la ON a.id = la.autor_id
GROUP BY a.id, a.nombre, a.apellido
ORDER BY total_libros DESC;

-- ============================================
-- CONCEPTOS CLAVE
-- ============================================

/*
1. RELACIÓN MUCHOS A MUCHOS (N:M):
   - Requiere tabla intermedia (tabla puente)
   - La tabla puente tiene claves foráneas a ambas tablas
   - Clave primaria compuesta (ambas claves foráneas)

2. TABLA INTERMEDIA:
   - Nombre: tabla1_tabla2 o tabla_puente
   - Mínimo: dos claves foráneas
   - Puede tener columnas adicionales (fecha, orden, etc.)

3. CLAVE PRIMARIA COMPUESTA:
   - PRIMARY KEY (columna1, columna2)
   - Garantiza que no haya duplicados
   - Ambas columnas juntas son únicas

4. GROUP_CONCAT:
   - Concatena valores de múltiples filas
   - Útil para mostrar relaciones N:M en una fila
   - Sintaxis: GROUP_CONCAT(columna, separador)

5. EXISTS:
   - Verifica si existe al menos un registro
   - Más eficiente que IN para subconsultas
   - Retorna true/false

6. Ejemplos comunes de N:M:
   - Estudiantes ↔ Cursos
   - Productos ↔ Etiquetas
   - Actores ↔ Películas
   - Autores ↔ Libros
   - Usuarios ↔ Roles

7. Buenas prácticas:
   - Usar CASCADE en DELETE para limpiar automáticamente
   - Indexar ambas claves foráneas
   - Considerar columnas adicionales (fecha, orden, etc.)
   - Nombrar tabla intermedia claramente

8. Diferencias entre relaciones:
   - 1:1 → Clave foránea única en una tabla
   - 1:N → Clave foránea en tabla "muchos"
   - N:M → Tabla intermedia con dos claves foráneas
*/
