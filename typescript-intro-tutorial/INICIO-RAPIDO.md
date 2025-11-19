# 🚀 Inicio Rápido

## Instalación y Ejecución en 3 Pasos

### 1️⃣ Instalar Dependencias

```bash
npm install
```

Esto instalará:
- TypeScript
- ts-node (para ejecutar TypeScript directamente)
- @types/node (definiciones de tipos para Node.js)

### 2️⃣ Ejecutar el Proyecto

Tienes dos opciones:

**Opción A: Modo Desarrollo (Recomendado para aprender)**
```bash
npm run dev
```

**Opción B: Compilar y Ejecutar**
```bash
npm run build
npm start
```

### 3️⃣ Explorar el Código

Abre los archivos en este orden para entender el proyecto:

1. `src/types/index.ts` - Tipos e interfaces básicas
2. `src/examples/basic-types.ts` - Ejemplos de tipos básicos
3. `src/models/TaskManager.ts` - Clase principal con POO
4. `src/utils/validators.ts` - Funciones y genéricos
5. `src/services/StatisticsService.ts` - Métodos estáticos
6. `src/index.ts` - Aplicación completa funcionando

## 📝 Scripts Disponibles

```bash
# Ejecutar en modo desarrollo (sin compilar)
npm run dev

# Compilar TypeScript a JavaScript
npm run build

# Ejecutar el código compilado
npm start

# Compilar en modo watch (recompila automáticamente)
npm run watch
```

## 🎯 ¿Qué Verás al Ejecutar?

El proyecto ejecutará una demostración completa que:
- ✅ Crea tareas con diferentes prioridades
- ✅ Actualiza y completa tareas
- ✅ Filtra tareas por estado
- ✅ Calcula estadísticas
- ✅ Muestra las etiquetas más usadas
- ✅ Agrupa tareas por prioridad

Todo esto mientras demuestra los conceptos fundamentales de TypeScript.

## 💡 Consejos para Aprender

1. **Lee el código con atención** - Cada archivo tiene comentarios explicativos
2. **Modifica el código** - Cambia valores, agrega funciones, experimenta
3. **Rompe el código** - Intenta cometer errores para ver cómo TypeScript te ayuda
4. **Usa el autocompletado** - Tu editor te mostrará los tipos disponibles
5. **Lee el README.md** - Contiene explicaciones detalladas de cada concepto

## 🐛 Solución de Problemas

### Error: "Cannot find module 'typescript'"
```bash
npm install
```

### Error: "tsc: command not found"
```bash
# Usar el script de npm en lugar del comando directo
npm run build
```

### El código no se actualiza
```bash
# Asegúrate de recompilar después de cambios
npm run build
npm start
```

## 🎓 Siguiente Paso

Lee el archivo `README.md` para una explicación completa de todos los conceptos de TypeScript utilizados en este proyecto.

¡Buena suerte con tu aprendizaje! 🚀
