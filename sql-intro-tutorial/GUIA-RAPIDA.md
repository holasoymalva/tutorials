# 🚀 Guía Rápida de Uso

## Instalación de SQLite

### macOS
```bash
# SQLite viene preinstalado, verifica la versión:
sqlite3 --version

# O instala la última versión con Homebrew:
brew install sqlite3
```

### Linux (Ubuntu/Debian)
```bash
sudo apt-get update
sudo apt-get install sqlite3
```

### Windows
Descarga desde [sqlite.org/download.html](https://www.sqlite.org/download.html)

## Cómo Ejecutar los Scripts

### Método 1: Ejecutar script completo
```bash
# Crear base de datos y ejecutar script
sqlite3 database/tienda.db < 01-fundamentos/01-crear-tablas.sql
```

### Método 2: Modo interactivo (Recomendado para aprender)
```bash
# Abrir SQLite
sqlite3 database/tienda.db

# Configurar salida legible
.mode column
.headers on

# Ejecutar script
.read 01-fundamentos/01-crear-tablas.sql

# Ver tablas creadas
.tables

# Ver esquema
.schema productos

# Ejecutar consulta
SELECT * FROM productos LIMIT 5;

# Salir
.quit
```

### Método 3: Consulta directa
```bash
sqlite3 database/tienda.db "SELECT * FROM productos;"
```

## Ruta de Aprendizaje Sugerida

### Día 1-2: Fundamentos
```bash
sqlite3 database/tienda.db
.read 01-fundamentos/01-crear-tablas.sql
.read 01-fundamentos/02-insertar-datos.sql
.read 01-fundamentos/03-consultas-basicas.sql
.read 01-fundamentos/04-actualizar-eliminar.sql
```

### Día 3-4: Relaciones
```bash
.read 02-relaciones/01-claves-foraneas.sql
.read 02-relaciones/02-joins.sql
.read 02-relaciones/03-relaciones-muchos-a-muchos.sql
```

### Día 5-6: Consultas Avanzadas
```bash
.read 03-consultas-avanzadas/01-agregaciones.sql
.read 03-consultas-avanzadas/02-subconsultas.sql
.read 03-consultas-avanzadas/03-funciones.sql
```

### Día 7: Optimización
```bash
.read 04-optimizacion/01-indices.sql
.read 04-optimizacion/02-transacciones.sql
```

### Día 8-10: Proyecto Final
```bash
.read 05-proyecto-final/sistema-gestion-tienda.sql
```

## Comandos Útiles de SQLite

```bash
# Ver todas las tablas
.tables

# Ver esquema de una tabla
.schema nombre_tabla

# Ver todos los esquemas
.schema

# Cambiar modo de salida
.mode column      # Columnas alineadas
.mode csv         # Formato CSV
.mode json        # Formato JSON
.mode markdown    # Formato Markdown

# Activar/desactivar encabezados
.headers on
.headers off

# Exportar resultados a archivo
.output resultados.txt
SELECT * FROM productos;
.output stdout

# Importar CSV
.mode csv
.import datos.csv tabla

# Ver configuración actual
.show

# Medir tiempo de ejecución
.timer on

# Ver ayuda
.help

# Salir
.quit
```

## Ejercicios Prácticos

### Ejercicio 1: Crear tu primera tabla
```sql
CREATE TABLE mis_productos (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    precio REAL
);

INSERT INTO mis_productos VALUES (1, 'Laptop', 999.99);
SELECT * FROM mis_productos;
```

### Ejercicio 2: Consulta con filtros
```sql
SELECT nombre, precio 
FROM productos 
WHERE precio > 500 
ORDER BY precio DESC 
LIMIT 5;
```

### Ejercicio 3: JOIN básico
```sql
SELECT p.nombre, c.nombre AS categoria
FROM productos p
INNER JOIN categorias c ON p.categoria_id = c.id;
```

### Ejercicio 4: Agregación
```sql
SELECT 
    categoria_id,
    COUNT(*) AS total,
    AVG(precio) AS promedio
FROM productos
GROUP BY categoria_id;
```

## Solución de Problemas

### Error: "database is locked"
```bash
# Cerrar todas las conexiones abiertas
# O esperar unos segundos y reintentar
```

### Error: "foreign key constraint failed"
```bash
# Asegúrate de habilitar claves foráneas
PRAGMA foreign_keys = ON;
```

### Resetear base de datos
```bash
# Eliminar base de datos
rm database/tienda.db

# Recrear desde cero
sqlite3 database/tienda.db < 05-proyecto-final/sistema-gestion-tienda.sql
```

## Recursos Adicionales

- **Documentación oficial**: https://www.sqlite.org/docs.html
- **Tutorial interactivo**: https://sqlbolt.com/
- **Práctica**: https://leetcode.com/problemset/database/
- **Cheat Sheet**: https://www.sqlitetutorial.net/sqlite-cheat-sheet/

## Próximos Pasos

1. Completa todos los scripts en orden
2. Practica modificando las consultas
3. Crea tus propias tablas y consultas
4. Resuelve los ejercicios al final de cada script
5. Construye tu propio proyecto

¡Buena suerte en tu aprendizaje de SQL! 🎓
