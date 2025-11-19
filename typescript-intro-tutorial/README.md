# Fundamentos Prácticos de TypeScript

## 📚 Introducción

Este proyecto es una guía práctica completa para aprender TypeScript desde cero hasta un nivel Junior Developer. A través de una aplicación de gestión de tareas (Task Manager), aprenderás todos los conceptos fundamentales que necesitas dominar para una entrevista técnica.

## 🎯 ¿Qué aprenderás?

- ✅ Tipos básicos y primitivos
- ✅ Interfaces y Type Aliases
- ✅ Clases y Programación Orientada a Objetos
- ✅ Funciones tipadas
- ✅ Genéricos (Generics)
- ✅ Enums
- ✅ Utility Types
- ✅ Type Guards
- ✅ Manejo de errores con tipos
- ✅ Configuración de proyectos TypeScript

## 🚀 Instalación y Ejecución

### Requisitos previos
- Node.js (versión 16 o superior)
- npm o yarn

### Pasos para ejecutar el proyecto

```bash
# 1. Instalar dependencias
npm install

# 2. Compilar el proyecto
npm run build

# 3. Ejecutar el proyecto compilado
npm start

# O ejecutar directamente en modo desarrollo
npm run dev
```

## 📖 Conceptos Fundamentales

### 1. Tipos Básicos

TypeScript extiende JavaScript añadiendo tipos estáticos. Los tipos básicos incluyen:

```typescript
// Tipos primitivos
let nombre: string = "Juan";
let edad: number = 25;
let activo: boolean = true;

// Arrays
let numeros: number[] = [1, 2, 3];
let palabras: Array<string> = ["hola", "mundo"];

// Tuplas - arrays con tipos fijos
let persona: [string, number] = ["Ana", 30];

// Any - evitar en lo posible
let cualquierCosa: any = "puede ser cualquier tipo";

// Unknown - más seguro que any
let desconocido: unknown = 4;
```

**Ubicación en el proyecto:** `src/types/index.ts`

### 2. Interfaces

Las interfaces definen la estructura de un objeto. Son contratos que especifican qué propiedades debe tener un objeto.

```typescript
interface Task {
  id: number;
  title: string;
  description: string;
  priority: Priority;
  status: Status;
  createdAt: Date;
  completedAt?: Date; // Opcional con ?
  tags: string[];
}
```

**Características clave:**
- Definen la forma de un objeto
- Pueden extenderse con `extends`
- Propiedades opcionales con `?`
- Propiedades de solo lectura con `readonly`

**Ubicación en el proyecto:** `src/types/index.ts`

### 3. Type Aliases (Tipos Personalizados)

Los type aliases permiten crear nombres para tipos complejos.

```typescript
// Tipos literales
type Priority = 'baja' | 'media' | 'alta' | 'urgente';
type Status = 'pendiente' | 'en-progreso' | 'completada' | 'cancelada';

// Tipos basados en otros
type TaskInput = Omit<Task, 'id' | 'createdAt'>;
```

**Diferencia entre Interface y Type:**
- Interfaces son mejores para objetos y pueden extenderse
- Types son más flexibles y pueden representar uniones, intersecciones, etc.

**Ubicación en el proyecto:** `src/types/index.ts`

### 4. Clases con TypeScript

Las clases en TypeScript añaden tipos a la POO tradicional de JavaScript.

```typescript
export class TaskManager {
  // Propiedades privadas
  private tasks: Task[] = [];
  private nextId: number = 1;

  // Constructor tipado
  constructor(initialTasks: Task[] = []) {
    this.tasks = initialTasks;
  }

  // Método público con tipo de retorno
  public createTask(taskInput: TaskInput): Task {
    const newTask: Task = {
      id: this.nextId++,
      ...taskInput,
      createdAt: new Date(),
    };
    this.tasks.push(newTask);
    return newTask;
  }

  // Getter
  public get taskCount(): number {
    return this.tasks.length;
  }
}
```

**Conceptos clave:**
- Modificadores de acceso: `public`, `private`, `protected`
- Constructores tipados
- Métodos con tipos de retorno
- Getters y setters
- Propiedades readonly

**Ubicación en el proyecto:** `src/models/TaskManager.ts`


### 5. Funciones Tipadas

TypeScript permite tipar parámetros y valores de retorno de funciones.

```typescript
// Función con tipos explícitos
function validateTaskTitle(
  title: string,
  minLength: number = 3,
  maxLength: number = 100
): { valid: boolean; error?: string } {
  if (title.length < minLength) {
    return { valid: false, error: "Título muy corto" };
  }
  return { valid: true };
}

// Función que retorna void
function logMessage(message: string): void {
  console.log(message);
}

// Función con parámetros opcionales
function greet(name: string, greeting?: string): string {
  return `${greeting || 'Hola'}, ${name}`;
}

// Rest parameters
function combineStrings(...strings: string[]): string {
  return strings.join(' ');
}
```

**Conceptos clave:**
- Parámetros tipados
- Tipos de retorno
- Parámetros opcionales con `?`
- Valores por defecto
- Rest parameters con `...`

**Ubicación en el proyecto:** `src/utils/validators.ts`

### 6. Genéricos (Generics)

Los genéricos permiten crear componentes reutilizables que funcionan con múltiples tipos.

```typescript
// Función genérica
function filterByProperty<T, K extends keyof T>(
  items: T[],
  property: K,
  value: T[K]
): T[] {
  return items.filter(item => item[property] === value);
}

// Uso
const tasks: Task[] = [...];
const highPriority = filterByProperty(tasks, 'priority', 'alta');
```

**Ventajas:**
- Reutilización de código
- Type safety (seguridad de tipos)
- Flexibilidad sin perder tipado

**Ubicación en el proyecto:** `src/utils/validators.ts`, `src/services/StatisticsService.ts`

### 7. Enums

Los enums permiten definir un conjunto de constantes nombradas.

```typescript
enum Color {
  Reset = '\x1b[0m',
  Red = '\x1b[31m',
  Green = '\x1b[32m',
  Yellow = '\x1b[33m',
}

// Uso
console.log(`${Color.Green}Éxito${Color.Reset}`);
```

**Tipos de enums:**
- Numéricos (por defecto)
- String (como en el ejemplo)
- Heterogéneos (mezcla de ambos)

**Ubicación en el proyecto:** `src/utils/formatters.ts`

### 8. Utility Types

TypeScript incluye tipos de utilidad para transformar tipos existentes.

```typescript
// Omit - excluye propiedades
type TaskInput = Omit<Task, 'id' | 'createdAt'>;

// Partial - hace todas las propiedades opcionales
type TaskUpdate = Partial<Task>;

// Readonly - hace todas las propiedades de solo lectura
type ReadonlyTask = Readonly<Task>;

// Pick - selecciona solo ciertas propiedades
type TaskPreview = Pick<Task, 'id' | 'title' | 'status'>;

// Record - crea un objeto con claves y valores específicos
type TaskRecord = Record<number, Task>;

// keyof - obtiene las claves de un tipo
type TaskKeys = keyof Task; // 'id' | 'title' | 'description' | ...
```

**Utility Types más comunes:**
- `Partial<T>` - Hace todas las propiedades opcionales
- `Required<T>` - Hace todas las propiedades requeridas
- `Readonly<T>` - Hace todas las propiedades de solo lectura
- `Pick<T, K>` - Selecciona propiedades específicas
- `Omit<T, K>` - Excluye propiedades específicas
- `Record<K, T>` - Crea un tipo de objeto con claves K y valores T

**Ubicación en el proyecto:** `src/types/index.ts`

### 9. Type Guards

Los type guards permiten verificar tipos en tiempo de ejecución.

```typescript
// Type guard personalizado
function isPriority(value: string): value is Priority {
  return ['baja', 'media', 'alta', 'urgente'].includes(value);
}

// Uso
const input = "alta";
if (isPriority(input)) {
  // TypeScript sabe que input es de tipo Priority aquí
  console.log(input.toUpperCase());
}

// Type guard con instanceof
if (error instanceof Error) {
  console.error(error.message);
}

// Type guard con typeof
if (typeof value === "string") {
  console.log(value.toLowerCase());
}
```

**Tipos de type guards:**
- `typeof` - para tipos primitivos
- `instanceof` - para instancias de clases
- Type predicates personalizados con `is`

**Ubicación en el proyecto:** `src/utils/validators.ts`, `src/index.ts`

### 10. Union Types y Literal Types

```typescript
// Union types - puede ser uno de varios tipos
type Result = string | number;
type Response = Success | Error;

// Literal types - valores específicos
type Priority = 'baja' | 'media' | 'alta' | 'urgente';

// Combinación
type Status = 'pendiente' | 'en-progreso' | 'completada' | 'cancelada';
```

**Ubicación en el proyecto:** `src/types/index.ts`

### 11. Manejo de Errores con Tipos

```typescript
try {
  main();
} catch (error) {
  // Type guard para Error
  if (error instanceof Error) {
    console.error(`Error: ${error.message}`);
  } else {
    console.error('Error desconocido');
  }
}
```

**Ubicación en el proyecto:** `src/index.ts`

## 🏗️ Estructura del Proyecto

```
typescript-fundamentos-practicos/
├── src/
│   ├── index.ts                    # Punto de entrada principal
│   ├── types/
│   │   └── index.ts                # Definiciones de tipos e interfaces
│   ├── models/
│   │   └── TaskManager.ts          # Clase principal con lógica de negocio
│   ├── services/
│   │   └── StatisticsService.ts    # Servicio con métodos estáticos
│   └── utils/
│       ├── formatters.ts           # Funciones de formateo
│       └── validators.ts           # Funciones de validación
├── dist/                           # Código JavaScript compilado
├── tsconfig.json                   # Configuración de TypeScript
├── package.json                    # Dependencias y scripts
└── README.md                       # Este archivo
```

## 🔧 Configuración de TypeScript (tsconfig.json)

```json
{
  "compilerOptions": {
    "target": "ES2020",              // Versión de JavaScript objetivo
    "module": "commonjs",            // Sistema de módulos
    "lib": ["ES2020"],               // Librerías disponibles
    "outDir": "./dist",              // Carpeta de salida
    "rootDir": "./src",              // Carpeta de código fuente
    "strict": true,                  // Modo estricto (recomendado)
    "esModuleInterop": true,         // Interoperabilidad con módulos ES
    "skipLibCheck": true,            // Omitir verificación de librerías
    "forceConsistentCasingInFileNames": true
  }
}
```

**Opciones importantes:**
- `strict: true` - Activa todas las verificaciones estrictas
- `noImplicitAny` - Error si hay tipos `any` implícitos
- `strictNullChecks` - Verificación estricta de null/undefined
- `noUnusedLocals` - Error si hay variables sin usar


## 💡 Conceptos Clave para Entrevistas

### 1. ¿Cuándo usar Interface vs Type?

**Interface:**
- Para definir objetos y contratos
- Cuando necesitas extender (extends)
- Para definir APIs públicas
- Pueden ser implementadas por clases

**Type:**
- Para uniones y tipos complejos
- Para tipos primitivos y literales
- Para intersecciones
- Más flexible en general

### 2. ¿Qué es el modo strict?

El modo `strict` en TypeScript activa todas las verificaciones estrictas:
- `noImplicitAny` - No permite tipos any implícitos
- `strictNullChecks` - Verifica null y undefined
- `strictFunctionTypes` - Verificación estricta de funciones
- `strictBindCallApply` - Verificación de bind, call, apply
- `strictPropertyInitialization` - Propiedades deben inicializarse

### 3. ¿Qué son los Generics y por qué son útiles?

Los genéricos permiten crear componentes reutilizables que funcionan con múltiples tipos manteniendo la seguridad de tipos. Son esenciales para:
- Crear funciones y clases reutilizables
- Mantener type safety
- Evitar duplicación de código

### 4. ¿Qué es Type Inference?

TypeScript puede inferir tipos automáticamente:

```typescript
// TypeScript infiere que x es number
let x = 10;

// TypeScript infiere el tipo de retorno
function suma(a: number, b: number) {
  return a + b; // Infiere que retorna number
}
```

### 5. ¿Qué es el operador Non-null Assertion (!)?

El operador `!` le dice a TypeScript que un valor no es null ni undefined:

```typescript
const task = getTaskById(1)!; // Aseguramos que no es undefined
```

**Usar con precaución:** Solo cuando estés 100% seguro de que el valor existe.

### 6. ¿Qué son los Type Guards?

Son funciones o expresiones que permiten verificar tipos en tiempo de ejecución:

```typescript
function isString(value: unknown): value is string {
  return typeof value === 'string';
}
```

### 7. ¿Qué es el tipo never?

El tipo `never` representa valores que nunca ocurren:
- Funciones que siempre lanzan errores
- Funciones con loops infinitos
- Verificación exhaustiva en switch

```typescript
function error(message: string): never {
  throw new Error(message);
}
```

## 📝 Ejercicios Prácticos Sugeridos

Para reforzar tu aprendizaje, intenta estos ejercicios:

1. **Agregar nuevas propiedades a Task**
   - Añade una propiedad `dueDate` (fecha límite)
   - Añade una propiedad `subtasks` (array de subtareas)

2. **Crear nuevos métodos en TaskManager**
   - `searchTasks(query: string)` - Buscar tareas por título
   - `getOverdueTasks()` - Obtener tareas vencidas
   - `sortTasksByPriority()` - Ordenar por prioridad

3. **Implementar un sistema de usuarios**
   - Crear una clase `User`
   - Asignar tareas a usuarios
   - Obtener tareas por usuario

4. **Agregar persistencia de datos**
   - Guardar tareas en un archivo JSON
   - Cargar tareas desde un archivo
   - Usar tipos para el manejo de archivos

5. **Crear validaciones adicionales**
   - Validar fechas
   - Validar que las etiquetas no estén vacías
   - Validar prioridades y estados

## 🎓 Recursos Adicionales

- [Documentación oficial de TypeScript](https://www.typescriptlang.org/docs/)
- [TypeScript Playground](https://www.typescriptlang.org/play) - Prueba código en el navegador
- [TypeScript Deep Dive](https://basarat.gitbook.io/typescript/) - Guía completa
- [Effective TypeScript](https://effectivetypescript.com/) - Mejores prácticas

## 🐛 Debugging y Errores Comunes

### Error: "Cannot find module"
```bash
# Solución: Instalar dependencias
npm install
```

### Error: "Property does not exist on type"
```typescript
// Problema: Propiedad no definida en la interfaz
interface User {
  name: string;
}
const user: User = { name: "Ana", age: 25 }; // Error

// Solución: Agregar la propiedad a la interfaz
interface User {
  name: string;
  age: number;
}
```

### Error: "Type 'undefined' is not assignable to type"
```typescript
// Problema: Valor puede ser undefined
const task = getTaskById(1);
console.log(task.title); // Error

// Solución 1: Optional chaining
console.log(task?.title);

// Solución 2: Type guard
if (task) {
  console.log(task.title);
}

// Solución 3: Non-null assertion (usar con cuidado)
console.log(task!.title);
```

## 🚀 Siguientes Pasos

Después de dominar estos fundamentos, considera aprender:

1. **TypeScript Avanzado**
   - Conditional Types
   - Mapped Types
   - Template Literal Types
   - Decorators

2. **TypeScript con Frameworks**
   - React + TypeScript
   - Node.js + Express + TypeScript
   - NestJS (framework backend con TypeScript)

3. **Testing con TypeScript**
   - Jest + TypeScript
   - Testing Library
   - Tipos para tests

4. **Herramientas del Ecosistema**
   - ESLint con TypeScript
   - Prettier
   - ts-node
   - nodemon

## 📊 Checklist de Preparación para Entrevistas

Asegúrate de poder explicar y demostrar:

- [ ] Diferencia entre `interface` y `type`
- [ ] Qué son los genéricos y cómo usarlos
- [ ] Utility types más comunes (Partial, Pick, Omit, etc.)
- [ ] Type guards y type narrowing
- [ ] Modificadores de acceso en clases (public, private, protected)
- [ ] Tipos de retorno de funciones
- [ ] Parámetros opcionales vs valores por defecto
- [ ] Union types y literal types
- [ ] El operador `!` (non-null assertion)
- [ ] Optional chaining (`?.`) y nullish coalescing (`??`)
- [ ] Configuración básica de tsconfig.json
- [ ] Cómo compilar y ejecutar código TypeScript

## 🎯 Conclusión

Este proyecto cubre todos los fundamentos esenciales de TypeScript que necesitas para:
- Desarrollar aplicaciones TypeScript profesionales
- Aprobar entrevistas técnicas de nivel Junior
- Entender código TypeScript en proyectos reales
- Continuar aprendiendo conceptos avanzados

**Recuerda:** La práctica es clave. Ejecuta el proyecto, modifica el código, experimenta con los tipos y crea tus propias funcionalidades.

## 📄 Licencia

MIT - Siéntete libre de usar este proyecto para aprender y practicar.

---

**¡Buena suerte en tu aprendizaje de TypeScript y en tus entrevistas! 🚀**
