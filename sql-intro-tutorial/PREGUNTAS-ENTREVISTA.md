# 💼 Preguntas Comunes de Entrevista SQL

## Nivel Junior - Básico

### 1. ¿Qué es SQL?
**Respuesta**: SQL (Structured Query Language) es un lenguaje estándar para gestionar y manipular bases de datos relacionales. Permite crear, leer, actualizar y eliminar datos (CRUD).

### 2. ¿Cuál es la diferencia entre DELETE y TRUNCATE?
**Respuesta**:
- **DELETE**: Elimina filas específicas, se puede usar con WHERE, más lento, se puede revertir con ROLLBACK
- **TRUNCATE**: Elimina todas las filas, más rápido, no se puede revertir, reinicia auto-increment

### 3. ¿Qué es una clave primaria (PRIMARY KEY)?
**Respuesta**: Es una columna o conjunto de columnas que identifica únicamente cada fila en una tabla. No puede contener valores NULL y debe ser única.

### 4. ¿Qué es una clave foránea (FOREIGN KEY)?
**Respuesta**: Es una columna que crea una relación entre dos tablas, referenciando la clave primaria de otra tabla. Mantiene la integridad referencial.

### 5. ¿Cuál es la diferencia entre WHERE y HAVING?
**Respuesta**:
- **WHERE**: Filtra filas antes de agrupar
- **HAVING**: Filtra grupos después de GROUP BY
- WHERE no puede usar funciones de agregación, HAVING sí

```sql
-- WHERE
SELECT * FROM productos WHERE precio > 100;

-- HAVING
SELECT categoria_id, AVG(precio) 
FROM productos 
GROUP BY categoria_id 
HAVING AVG(precio) > 500;
```

### 6. ¿Qué hace la cláusula DISTINCT?
**Respuesta**: Elimina filas duplicadas del resultado, retornando solo valores únicos.

```sql
SELECT DISTINCT ciudad FROM clientes;
```

### 7. ¿Qué es un índice?
**Respuesta**: Es una estructura de datos que mejora la velocidad de las consultas. Similar al índice de un libro, permite encontrar datos rápidamente sin escanear toda la tabla.

### 8. ¿Cuál es la diferencia entre INNER JOIN y LEFT JOIN?
**Respuesta**:
- **INNER JOIN**: Solo registros que coinciden en ambas tablas
- **LEFT JOIN**: Todos los registros de la tabla izquierda, con NULL si no hay coincidencia

```sql
-- INNER JOIN
SELECT * FROM productos p
INNER JOIN categorias c ON p.categoria_id = c.id;

-- LEFT JOIN
SELECT * FROM categorias c
LEFT JOIN productos p ON c.id = p.categoria_id;
```

### 9. ¿Qué es NULL en SQL?
**Respuesta**: NULL representa la ausencia de valor. No es lo mismo que 0 o cadena vacía. Se verifica con IS NULL o IS NOT NULL, no con = NULL.

### 10. ¿Qué hace ORDER BY?
**Respuesta**: Ordena los resultados. ASC para ascendente (por defecto), DESC para descendente.

```sql
SELECT * FROM productos ORDER BY precio DESC;
```

## Nivel Intermedio

### 11. ¿Qué es la normalización?
**Respuesta**: Es el proceso de organizar datos para reducir redundancia y mejorar integridad. Principales formas normales:
- **1NF**: Valores atómicos, sin grupos repetidos
- **2NF**: 1NF + sin dependencias parciales
- **3NF**: 2NF + sin dependencias transitivas

### 12. ¿Qué es una transacción?
**Respuesta**: Conjunto de operaciones que se ejecutan como una unidad. Sigue propiedades ACID:
- **A**tomicity: Todo o nada
- **C**onsistency: Estado válido
- **I**solation: Independencia
- **D**urability: Permanencia

```sql
BEGIN TRANSACTION;
UPDATE cuenta SET saldo = saldo - 100 WHERE id = 1;
UPDATE cuenta SET saldo = saldo + 100 WHERE id = 2;
COMMIT;
```

### 13. ¿Cuál es la diferencia entre UNION y UNION ALL?
**Respuesta**:
- **UNION**: Combina resultados eliminando duplicados
- **UNION ALL**: Combina resultados manteniendo duplicados (más rápido)

```sql
SELECT nombre FROM clientes
UNION
SELECT nombre FROM empleados;
```

### 14. ¿Qué es una subconsulta?
**Respuesta**: Una consulta dentro de otra consulta. Puede estar en WHERE, SELECT o FROM.

```sql
SELECT nombre FROM productos
WHERE precio > (SELECT AVG(precio) FROM productos);
```

### 15. ¿Qué hace GROUP BY?
**Respuesta**: Agrupa filas con valores similares. Se usa con funciones de agregación (COUNT, SUM, AVG, MAX, MIN).

```sql
SELECT categoria_id, COUNT(*) 
FROM productos 
GROUP BY categoria_id;
```

### 16. ¿Qué es un SELF JOIN?
**Respuesta**: Una tabla unida consigo misma. Útil para jerarquías o comparaciones dentro de la misma tabla.

```sql
SELECT e.nombre AS empleado, j.nombre AS jefe
FROM empleados e
LEFT JOIN empleados j ON e.jefe_id = j.id;
```

### 17. ¿Cuándo usar índices?
**Respuesta**: Usar en:
- Columnas en WHERE frecuentes
- Columnas en JOIN
- Claves foráneas
- Columnas en ORDER BY

No usar en:
- Tablas pequeñas
- Columnas que cambian mucho
- Columnas con pocos valores únicos

### 18. ¿Qué es una vista (VIEW)?
**Respuesta**: Una tabla virtual basada en una consulta. No almacena datos, solo la definición.

```sql
CREATE VIEW productos_caros AS
SELECT * FROM productos WHERE precio > 1000;
```

### 19. ¿Qué hace COALESCE?
**Respuesta**: Retorna el primer valor no nulo de una lista.

```sql
SELECT nombre, COALESCE(telefono, 'Sin teléfono') FROM clientes;
```

### 20. ¿Qué es un deadlock?
**Respuesta**: Situación donde dos transacciones se bloquean mutuamente esperando recursos. Se previene accediendo recursos en orden consistente.

## Nivel Avanzado

### 21. ¿Qué son las funciones de ventana (Window Functions)?
**Respuesta**: Funciones que operan sobre un conjunto de filas relacionadas sin agruparlas.

```sql
SELECT 
    nombre,
    precio,
    ROW_NUMBER() OVER (ORDER BY precio DESC) AS ranking
FROM productos;
```

### 22. ¿Qué es un CTE (Common Table Expression)?
**Respuesta**: Tabla temporal definida con WITH. Mejora legibilidad de consultas complejas.

```sql
WITH ventas_producto AS (
    SELECT producto_id, SUM(cantidad) AS total
    FROM detalle_pedidos
    GROUP BY producto_id
)
SELECT p.nombre, v.total
FROM productos p
JOIN ventas_producto v ON p.id = v.producto_id;
```

### 23. ¿Cómo optimizar una consulta lenta?
**Respuesta**:
1. Usar EXPLAIN QUERY PLAN
2. Agregar índices apropiados
3. Evitar SELECT *
4. Usar WHERE en lugar de HAVING cuando sea posible
5. Limitar resultados con LIMIT
6. Evitar funciones en columnas indexadas en WHERE

### 24. ¿Qué es la cardinalidad?
**Respuesta**: Número de valores únicos en una columna. Alta cardinalidad (muchos valores únicos) es mejor para índices.

### 25. ¿Cuál es la diferencia entre EXISTS y IN?
**Respuesta**:
- **EXISTS**: Más eficiente para grandes conjuntos, se detiene al encontrar coincidencia
- **IN**: Mejor para listas pequeñas

```sql
-- EXISTS
SELECT * FROM clientes c
WHERE EXISTS (SELECT 1 FROM pedidos p WHERE p.cliente_id = c.id);

-- IN
SELECT * FROM productos
WHERE categoria_id IN (1, 2, 3);
```

## Preguntas Prácticas

### 26. Encuentra el segundo salario más alto
```sql
SELECT MAX(salario) 
FROM empleados 
WHERE salario < (SELECT MAX(salario) FROM empleados);

-- O con LIMIT
SELECT DISTINCT salario 
FROM empleados 
ORDER BY salario DESC 
LIMIT 1 OFFSET 1;
```

### 27. Encuentra duplicados
```sql
SELECT email, COUNT(*) 
FROM clientes 
GROUP BY email 
HAVING COUNT(*) > 1;
```

### 28. Elimina duplicados manteniendo uno
```sql
DELETE FROM clientes 
WHERE id NOT IN (
    SELECT MIN(id) 
    FROM clientes 
    GROUP BY email
);
```

### 29. Encuentra clientes sin pedidos
```sql
SELECT c.* 
FROM clientes c
LEFT JOIN pedidos p ON c.id = p.cliente_id
WHERE p.id IS NULL;
```

### 30. Calcula diferencia con fila anterior
```sql
SELECT 
    fecha,
    ventas,
    ventas - LAG(ventas) OVER (ORDER BY fecha) AS diferencia
FROM ventas_diarias;
```

## Consejos para la Entrevista

1. **Piensa en voz alta**: Explica tu razonamiento
2. **Pregunta sobre el contexto**: Tamaño de datos, frecuencia de consultas
3. **Considera el rendimiento**: Menciona índices, optimización
4. **Maneja casos especiales**: NULL, duplicados, datos vacíos
5. **Escribe código limpio**: Usa alias, indentación, comentarios
6. **Conoce las diferencias**: Entre DBMS (MySQL, PostgreSQL, SQLite)
7. **Practica en papel**: Muchas entrevistas son sin computadora
8. **Repasa conceptos**: ACID, normalización, índices, transacciones

## Recursos para Practicar

- **LeetCode Database**: https://leetcode.com/problemset/database/
- **HackerRank SQL**: https://www.hackerrank.com/domains/sql
- **SQLZoo**: https://sqlzoo.net/
- **Mode Analytics SQL Tutorial**: https://mode.com/sql-tutorial/

¡Buena suerte en tu entrevista! 🍀
