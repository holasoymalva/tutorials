# 📁 Estructura Visual del Proyecto

## 🌳 Árbol de Archivos

```
typescript-fundamentos-practicos/
│
├── 📄 README.md                      ⭐ GUÍA PRINCIPAL - Empieza aquí
├── 📄 INICIO-RAPIDO.md               🚀 Instalación en 3 pasos
├── 📄 EJERCICIOS.md                  💪 Práctica hands-on
├── 📄 PREGUNTAS-ENTREVISTA.md        🎤 Preparación de entrevistas
├── 📄 RESUMEN-PROYECTO.md            📋 Visión general
├── 📄 ESTRUCTURA-VISUAL.md           📁 Este archivo
│
├── ⚙️  tsconfig.json                  Configuración de TypeScript
├── 📦 package.json                   Dependencias y scripts
├── 🚫 .gitignore                     Archivos ignorados por Git
│
├── 📂 src/                           CÓDIGO FUENTE
│   │
│   ├── 🎯 index.ts                   ⭐ APLICACIÓN PRINCIPAL
│   │                                 Ejecuta todo el proyecto
│   │
│   ├── 📂 types/                     DEFINICIONES DE TIPOS
│   │   └── index.ts                  • Interfaces
│   │                                 • Type Aliases
│   │                                 • Union Types
│   │
│   ├── 📂 models/                    CLASES Y LÓGICA
│   │   └── TaskManager.ts            • Clase principal
│   │                                 • POO con TypeScript
│   │                                 • Métodos tipados
│   │
│   ├── 📂 services/                  SERVICIOS
│   │   └── StatisticsService.ts      • Métodos estáticos
│   │                                 • Genéricos
│   │                                 • Cálculos complejos
│   │
│   ├── 📂 utils/                     UTILIDADES
│   │   ├── formatters.ts             • Enums
│   │   │                             • Funciones de formato
│   │   └── validators.ts             • Type Guards
│   │                                 • Validaciones
│   │
│   └── 📂 examples/                  EJEMPLOS EDUCATIVOS
│       ├── basic-types.ts            • Tipos básicos
│       │                             • Primitivos
│       │                             • Arrays y tuplas
│       └── advanced-concepts.ts      • Utility Types
│                                     • Mapped Types
│                                     • Conditional Types
│
└── 📂 dist/                          CÓDIGO COMPILADO
    └── (generado con npm run build)  JavaScript resultante
```

## 🎯 Flujo de Aprendizaje Recomendado

```
┌─────────────────────────────────────────────────────────────┐
│  PASO 1: INSTALACIÓN                                        │
│  📄 Lee: INICIO-RAPIDO.md                                   │
│  💻 Ejecuta: npm install && npm run dev                     │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│  PASO 2: CONCEPTOS BÁSICOS                                  │
│  📄 Lee: README.md (secciones 1-5)                          │
│  📝 Explora: src/types/index.ts                             │
│  📝 Explora: src/examples/basic-types.ts                    │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│  PASO 3: CONCEPTOS INTERMEDIOS                              │
│  📄 Lee: README.md (secciones 6-8)                          │
│  📝 Explora: src/models/TaskManager.ts                      │
│  📝 Explora: src/utils/validators.ts                        │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│  PASO 4: CONCEPTOS AVANZADOS                                │
│  📄 Lee: README.md (secciones 9-11)                         │
│  📝 Explora: src/services/StatisticsService.ts              │
│  📝 Explora: src/examples/advanced-concepts.ts              │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│  PASO 5: APLICACIÓN COMPLETA                                │
│  📝 Explora: src/index.ts                                   │
│  💻 Ejecuta: npm run dev                                    │
│  🔍 Observa cómo todo funciona junto                        │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│  PASO 6: PRÁCTICA                                           │
│  📄 Lee: EJERCICIOS.md                                      │
│  💪 Completa los ejercicios                                 │
│  🔨 Modifica el código existente                            │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│  PASO 7: PREPARACIÓN DE ENTREVISTAS                         │
│  📄 Lee: PREGUNTAS-ENTREVISTA.md                            │
│  🎤 Practica explicar conceptos                             │
│  💻 Resuelve ejercicios de código en vivo                   │
└─────────────────────────────────────────────────────────────┘
```

## 📊 Mapa de Conceptos por Archivo

### 🎯 src/index.ts
```
┌─────────────────────────────────────┐
│ APLICACIÓN PRINCIPAL                │
├─────────────────────────────────────┤
│ ✓ Imports tipados                   │
│ ✓ Uso de clases                     │
│ ✓ Manejo de errores con tipos       │
│ ✓ Type guards (instanceof)          │
│ ✓ Arrays tipados                    │
│ ✓ Funciones con tipos de retorno    │
└─────────────────────────────────────┘
```

### 📝 src/types/index.ts
```
┌─────────────────────────────────────┐
│ DEFINICIONES DE TIPOS               │
├─────────────────────────────────────┤
│ ✓ Type Aliases                      │
│ ✓ Interfaces                        │
│ ✓ Union Types                       │
│ ✓ Literal Types                     │
│ ✓ Utility Types (Omit, Partial)    │
│ ✓ Propiedades opcionales            │
│ ✓ Interfaces extendidas             │
└─────────────────────────────────────┘
```

### 🏗️ src/models/TaskManager.ts
```
┌─────────────────────────────────────┐
│ CLASE CON POO                       │
├─────────────────────────────────────┤
│ ✓ Propiedades privadas              │
│ ✓ Constructor tipado                │
│ ✓ Métodos públicos                  │
│ ✓ Tipos de retorno                  │
│ ✓ Parámetros opcionales             │
│ ✓ Getters                           │
│ ✓ Manejo de errores                 │
└─────────────────────────────────────┘
```

### 📊 src/services/StatisticsService.ts
```
┌─────────────────────────────────────┐
│ SERVICIO CON MÉTODOS ESTÁTICOS      │
├─────────────────────────────────────┤
│ ✓ Métodos estáticos                 │
│ ✓ Genéricos (Generics)              │
│ ✓ Interfaces complejas              │
│ ✓ Record types                      │
│ ✓ Métodos de arrays tipados         │
│ ✓ Tipos de retorno complejos        │
└─────────────────────────────────────┘
```

### 🎨 src/utils/formatters.ts
```
┌─────────────────────────────────────┐
│ FORMATEO Y ENUMS                    │
├─────────────────────────────────────┤
│ ✓ Enums                             │
│ ✓ Switch con tipos literales        │
│ ✓ Template literals                 │
│ ✓ Funciones con tipos de retorno    │
│ ✓ Verificación exhaustiva (never)   │
└─────────────────────────────────────┘
```

### ✅ src/utils/validators.ts
```
┌─────────────────────────────────────┐
│ VALIDACIONES Y TYPE GUARDS          │
├─────────────────────────────────────┤
│ ✓ Type Guards personalizados        │
│ ✓ Funciones genéricas               │
│ ✓ Parámetros con valores default    │
│ ✓ Rest parameters                   │
│ ✓ Higher Order Functions            │
│ ✓ Tipos de retorno complejos        │
└─────────────────────────────────────┘
```

### 📚 src/examples/basic-types.ts
```
┌─────────────────────────────────────┐
│ EJEMPLOS DE TIPOS BÁSICOS           │
├─────────────────────────────────────┤
│ ✓ Primitivos (string, number, bool) │
│ ✓ Arrays                            │
│ ✓ Tuplas                            │
│ ✓ Enums                             │
│ ✓ Any, Unknown, Never               │
│ ✓ Union Types                       │
│ ✓ Intersection Types                │
│ ✓ Type Assertions                   │
│ ✓ Literal Types                     │
└─────────────────────────────────────┘
```

### 🚀 src/examples/advanced-concepts.ts
```
┌─────────────────────────────────────┐
│ CONCEPTOS AVANZADOS                 │
├─────────────────────────────────────┤
│ ✓ Utility Types completos           │
│ ✓ Mapped Types                      │
│ ✓ Conditional Types                 │
│ ✓ Template Literal Types            │
│ ✓ Discriminated Unions              │
│ ✓ Index Signatures                  │
│ ✓ Function Overloads                │
│ ✓ Abstract Classes                  │
│ ✓ Decorators                        │
│ ✓ Namespaces                        │
└─────────────────────────────────────┘
```

## 🎓 Documentación por Nivel

### 📗 Nivel Principiante
```
1. INICIO-RAPIDO.md          → Instalación y primeros pasos
2. README.md (secciones 1-4) → Tipos básicos e interfaces
3. src/examples/basic-types.ts → Ejemplos prácticos
```

### 📘 Nivel Intermedio
```
1. README.md (secciones 5-8) → Funciones, genéricos, enums
2. src/models/TaskManager.ts → POO con TypeScript
3. src/utils/validators.ts   → Type guards y validaciones
4. EJERCICIOS.md (1-6)       → Práctica intermedia
```

### 📕 Nivel Avanzado
```
1. README.md (secciones 9-11)      → Utility types, type guards
2. src/services/StatisticsService.ts → Genéricos avanzados
3. src/examples/advanced-concepts.ts → Conceptos avanzados
4. EJERCICIOS.md (7-10)            → Práctica avanzada
5. PREGUNTAS-ENTREVISTA.md         → Preparación completa
```

## 🔄 Ciclo de Desarrollo

```
┌──────────────┐
│   Escribir   │
│    Código    │
└──────┬───────┘
       │
       ↓
┌──────────────┐
│   Compilar   │
│ npm run build│
└──────┬───────┘
       │
       ↓
┌──────────────┐
│   Ejecutar   │
│  npm start   │
└──────┬───────┘
       │
       ↓
┌──────────────┐
│   Verificar  │
│   Errores    │
└──────┬───────┘
       │
       ↓
┌──────────────┐
│   Modificar  │
│  y Aprender  │
└──────┬───────┘
       │
       └──────→ (Repetir)
```

## 📈 Progreso de Aprendizaje

```
Conceptos Básicos (40%)
████████████░░░░░░░░░░░░░░░░░░
├─ Tipos primitivos        ✓
├─ Arrays y tuplas         ✓
├─ Interfaces              ✓
└─ Type aliases            ✓

Conceptos Intermedios (35%)
████████████████████░░░░░░░░░░
├─ Clases                  ✓
├─ Funciones tipadas       ✓
├─ Enums                   ✓
└─ Type guards             ✓

Conceptos Avanzados (25%)
████████████████████████████░░
├─ Genéricos               ✓
├─ Utility Types           ✓
├─ Mapped Types            ✓
└─ Conditional Types       ✓
```

## 🎯 Comandos Rápidos

```bash
# Instalación
npm install

# Desarrollo (recomendado para aprender)
npm run dev

# Compilar
npm run build

# Ejecutar compilado
npm start

# Compilar en modo watch
npm run watch
```

## 📞 Ayuda Rápida

¿Tienes dudas sobre...?

- **Tipos básicos** → `src/examples/basic-types.ts`
- **Interfaces** → `src/types/index.ts`
- **Clases** → `src/models/TaskManager.ts`
- **Genéricos** → `src/services/StatisticsService.ts`
- **Type Guards** → `src/utils/validators.ts`
- **Conceptos avanzados** → `src/examples/advanced-concepts.ts`
- **Ejercicios** → `EJERCICIOS.md`
- **Entrevistas** → `PREGUNTAS-ENTREVISTA.md`

---

**¡Navega por el proyecto y aprende TypeScript de forma práctica! 🚀**
