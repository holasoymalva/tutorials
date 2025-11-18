# Fundamentos de Backend Development con SQL

## 📚 Introducción

Este proyecto está diseñado para aprender los fundamentos de SQL desde cero, preparándote para entrevistas de trabajo como desarrollador Back-End Junior. Trabajaremos exclusivamente con SQL puro usando SQLite como motor de base de datos.

## 🎯 Objetivos del Proyecto

- Dominar los comandos SQL fundamentales (DDL, DML, DQL)
- Entender el diseño de bases de datos relacionales
- Practicar consultas complejas con JOINs, subconsultas y agregaciones
- Aprender sobre índices, transacciones y optimización
- Prepararse para preguntas técnicas de entrevistas

## 📋 Requisitos Previos

- SQLite3 instalado en tu sistema
  - **macOS**: `brew install sqlite3` (o ya viene preinstalado)
  - **Linux**: `sudo apt-get install sqlite3`
  - **Windows**: Descargar desde [sqlite.org](https://www.sqlite.org/download.html)

## 🗂️ Estructura del Proyecto

```
sql-fundamentals/
├── README.md
├── 01-fundamentos/
│   ├── 01-crear-tablas.sql
│   ├── 02-insertar-datos.sql
│   ├── 03-consultas-basicas.sql
│   └── 04-actualizar-eliminar.sql
├── 02-relaciones/
│   ├── 01-claves-foraneas.sql
│   ├── 02-joins.sql
│   └── 03-relaciones-muchos-a-muchos.sql
├── 03-consultas-avanzadas/
│   ├── 01-agregaciones.sql
│   ├── 02-subconsultas.sql
│   └── 03-funciones.sql
├── 04-optimizacion/
│   ├── 01-indices.sql
│   └── 02-transacciones.sql
├── 05-proyecto-final/
│   └── sistema-gestion-tienda.sql
└── database/
    └── tienda.db
```

## 🚀 Cómo Usar Este Proyecto

### Opción 1: Ejecutar scripts individuales
```bash
# Crear la base de datos y ejecutar un script
sqlite3 database/tienda.db < 01-fundamentos/01-crear-tablas.sql
```

### Opción 2: Modo interactivo
```bash
# Abrir SQLite en modo interactivo
sqlite3 database/tienda.db

# Dentro de SQLite, ejecutar un script
.read 01-fundamentos/01-crear-tablas.sql

# Ver las tablas creadas
.tables

# Ver el esquema de una tabla
.schema clientes

# Salir
.quit
```

### Opción 3: Ejecutar consultas directamente
```bash
sqlite3 database/tienda.db "SELECT * FROM clientes;"
```

## 📖 Conceptos Fundamentales de SQL

### 1. DDL (Data Definition Language)
Comandos para definir la estructura de la base de datos:
- **CREATE**: Crear tablas, índices, vistas
- **ALTER**: Modificar estructura de tablas
- **DROP**: Eliminar tablas o bases de datos
- **TRUNCATE**: Vaciar tablas

### 2. DML (Data Manipulation Language)
Comandos para manipular datos:
- **INSERT**: Insertar registros
- **UPDATE**: Actualizar registros
- **DELETE**: Eliminar registros

### 3. DQL (Data Query Language)
Comandos para consultar datos:
- **SELECT**: Recuperar datos de la base de datos

### 4. DCL (Data Control Language)
Comandos para control de acceso:
- **GRANT**: Otorgar permisos
- **REVOKE**: Revocar permisos

### 5. TCL (Transaction Control Language)
Comandos para control de transacciones:
- **BEGIN**: Iniciar transacción
- **COMMIT**: Confirmar cambios
- **ROLLBACK**: Revertir cambios

## 🔑 Conceptos Clave

### Tipos de Datos en SQLite
- **INTEGER**: Números enteros
- **REAL**: Números decimales
- **TEXT**: Cadenas de texto
- **BLOB**: Datos binarios
- **NULL**: Valor nulo

### Restricciones (Constraints)
- **PRIMARY KEY**: Identificador único de cada registro
- **FOREIGN KEY**: Relación con otra tabla
- **UNIQUE**: Valores únicos en la columna
- **NOT NULL**: No permite valores nulos
- **CHECK**: Validación personalizada
- **DEFAULT**: Valor por defecto

### Tipos de Relaciones
1. **Uno a Uno (1:1)**: Un registro se relaciona con exactamente un registro
2. **Uno a Muchos (1:N)**: Un registro se relaciona con múltiples registros
3. **Muchos a Muchos (N:M)**: Múltiples registros se relacionan con múltiples registros

### Tipos de JOINs
- **INNER JOIN**: Registros que coinciden en ambas tablas
- **LEFT JOIN**: Todos los registros de la tabla izquierda
- **RIGHT JOIN**: Todos los registros de la tabla derecha (SQLite no lo soporta nativamente)
- **FULL OUTER JOIN**: Todos los registros de ambas tablas (SQLite no lo soporta nativamente)
- **CROSS JOIN**: Producto cartesiano de ambas tablas

### Funciones de Agregación
- **COUNT()**: Contar registros
- **SUM()**: Sumar valores
- **AVG()**: Promedio
- **MAX()**: Valor máximo
- **MIN()**: Valor mínimo
- **GROUP BY**: Agrupar resultados
- **HAVING**: Filtrar grupos

### Índices
Los índices mejoran el rendimiento de las consultas:
- Aceleran las búsquedas
- Ralentizan las inserciones/actualizaciones
- Usar en columnas frecuentemente consultadas

### Transacciones (ACID)
- **Atomicity**: Todo o nada
- **Consistency**: Mantiene integridad
- **Isolation**: Transacciones independientes
- **Durability**: Cambios permanentes

## 💼 Preguntas Comunes de Entrevista

### Nivel Básico
1. ¿Qué es una clave primaria?
2. ¿Cuál es la diferencia entre DELETE y TRUNCATE?
3. ¿Qué es una clave foránea?
4. ¿Qué hace la cláusula WHERE?
5. ¿Cómo ordenar resultados con ORDER BY?

### Nivel Intermedio
1. ¿Cuál es la diferencia entre INNER JOIN y LEFT JOIN?
2. ¿Qué es una subconsulta?
3. ¿Cómo funciona GROUP BY con HAVING?
4. ¿Qué es la normalización de bases de datos?
5. ¿Cuándo usar un índice?

### Nivel Avanzado
1. ¿Qué es una transacción y por qué es importante?
2. Explica las propiedades ACID
3. ¿Cómo optimizar una consulta lenta?
4. ¿Qué es un deadlock?
5. ¿Cuándo usar una vista (VIEW)?

## 🎓 Ruta de Aprendizaje

### Semana 1: Fundamentos
- Crear y modificar tablas
- Insertar, actualizar y eliminar datos
- Consultas básicas con SELECT, WHERE, ORDER BY

### Semana 2: Relaciones
- Claves primarias y foráneas
- Diferentes tipos de JOINs
- Relaciones muchos a muchos

### Semana 3: Consultas Avanzadas
- Funciones de agregación
- Subconsultas
- Funciones de fecha y texto

### Semana 4: Optimización y Proyecto Final
- Índices y rendimiento
- Transacciones
- Proyecto completo: Sistema de gestión de tienda

## 📝 Comandos Útiles de SQLite

```bash
# Mostrar tablas
.tables

# Ver esquema de una tabla
.schema nombre_tabla

# Modo de salida en columnas
.mode column

# Mostrar encabezados
.headers on

# Exportar a CSV
.mode csv
.output datos.csv
SELECT * FROM clientes;
.output stdout

# Importar desde CSV
.mode csv
.import datos.csv clientes

# Ver configuración actual
.show

# Ayuda
.help
```

## 🏆 Proyecto Final: Sistema de Gestión de Tienda

El proyecto final integra todos los conceptos aprendidos:
- Gestión de clientes
- Catálogo de productos
- Procesamiento de pedidos
- Inventario
- Reportes y análisis

## 📚 Recursos Adicionales

- [Documentación oficial de SQLite](https://www.sqlite.org/docs.html)
- [SQL Tutorial - W3Schools](https://www.w3schools.com/sql/)
- [SQLBolt - Interactive SQL Tutorial](https://sqlbolt.com/)
- [LeetCode Database Problems](https://leetcode.com/problemset/database/)

## 🤝 Contribuciones

Este es un proyecto educativo. Siéntete libre de:
- Agregar más ejercicios
- Mejorar la documentación
- Compartir con otros estudiantes

## 📄 Licencia

Proyecto educativo de código abierto para aprender SQL.

---

**¡Comienza tu viaje en SQL y conviértete en un desarrollador Back-End!** 🚀
