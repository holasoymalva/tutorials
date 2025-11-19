# 🎤 Preguntas Comunes de Entrevista - TypeScript

## Preguntas Básicas

### 1. ¿Qué es TypeScript?
**Respuesta:** TypeScript es un superset de JavaScript que añade tipado estático opcional. Se compila a JavaScript puro y puede ejecutarse en cualquier lugar donde JavaScript funcione. Fue desarrollado por Microsoft.

**Ventajas:**
- Detección de errores en tiempo de compilación
- Mejor autocompletado y refactorización
- Documentación implícita a través de tipos
- Facilita el mantenimiento de código a gran escala

### 2. ¿Cuál es la diferencia entre `interface` y `type`?
**Respuesta:**

**Interface:**
- Puede extenderse con `extends`
- Puede ser implementada por clases
- Puede fusionarse (declaration merging)
- Mejor para definir objetos y contratos

```typescript
interface Usuario {
  nombre: string;
}

interface Usuario {
  edad: number; // Se fusiona con la anterior
}
```

**Type:**
- Más flexible, puede representar uniones, intersecciones, primitivos
- No puede fusionarse
- Mejor para tipos complejos

```typescript
type ID = string | number;
type Usuario = { nombre: string } & { edad: number };
```

### 3. ¿Qué son los genéricos (Generics)?
**Respuesta:** Los genéricos permiten crear componentes reutilizables que funcionan con múltiples tipos manteniendo la seguridad de tipos.

```typescript
function obtenerPrimero<T>(array: T[]): T | undefined {
  return array[0];
}

const numero = obtenerPrimero([1, 2, 3]); // number | undefined
const texto = obtenerPrimero(["a", "b"]); // string | undefined
```

### 4. ¿Qué es el modo `strict` en TypeScript?
**Respuesta:** El modo strict activa todas las verificaciones estrictas de tipos. Incluye:
- `noImplicitAny`: Error si hay tipos `any` implícitos
- `strictNullChecks`: Verificación estricta de null/undefined
- `strictFunctionTypes`: Verificación estricta de tipos de funciones
- `strictBindCallApply`: Verificación de bind, call, apply
- `strictPropertyInitialization`: Propiedades deben inicializarse

Se recomienda siempre usar `"strict": true` en proyectos nuevos.

### 5. ¿Qué es un Type Guard?
**Respuesta:** Un type guard es una expresión que realiza una verificación en tiempo de ejecución y garantiza el tipo en un scope específico.

```typescript
function procesarValor(valor: string | number) {
  if (typeof valor === "string") {
    // TypeScript sabe que aquí valor es string
    return valor.toUpperCase();
  } else {
    // TypeScript sabe que aquí valor es number
    return valor.toFixed(2);
  }
}

// Type guard personalizado
function esString(valor: unknown): valor is string {
  return typeof valor === "string";
}
```

## Preguntas Intermedias

### 6. ¿Cuál es la diferencia entre `any`, `unknown` y `never`?
**Respuesta:**

**`any`:**
- Desactiva la verificación de tipos
- Puede asignarse a cualquier tipo y viceversa
- Evitar en lo posible

**`unknown`:**
- Tipo seguro para valores desconocidos
- Requiere verificación antes de usar
- Preferir sobre `any`

```typescript
let valor: unknown = "hola";
// valor.toUpperCase(); // Error
if (typeof valor === "string") {
  valor.toUpperCase(); // OK
}
```

**`never`:**
- Representa valores que nunca ocurren
- Funciones que siempre lanzan errores
- Verificación exhaustiva

```typescript
function error(mensaje: string): never {
  throw new Error(mensaje);
}
```

### 7. ¿Qué son los Utility Types?
**Respuesta:** Son tipos predefinidos en TypeScript para transformar tipos existentes.

**Los más comunes:**

```typescript
interface Usuario {
  id: number;
  nombre: string;
  email: string;
}

// Partial - todas las propiedades opcionales
type UsuarioParcial = Partial<Usuario>;

// Required - todas las propiedades requeridas
type UsuarioCompleto = Required<Usuario>;

// Readonly - todas las propiedades de solo lectura
type UsuarioInmutable = Readonly<Usuario>;

// Pick - seleccionar propiedades
type UsuarioResumen = Pick<Usuario, "id" | "nombre">;

// Omit - excluir propiedades
type UsuarioSinId = Omit<Usuario, "id">;

// Record - crear objeto con claves y valores específicos
type UsuariosPorId = Record<number, Usuario>;
```

### 8. ¿Qué son las Discriminated Unions?
**Respuesta:** Son uniones de tipos que comparten una propiedad literal común (discriminante) que permite distinguir entre los tipos.

```typescript
interface Exito {
  tipo: "exito";
  datos: any;
}

interface Error {
  tipo: "error";
  mensaje: string;
}

type Respuesta = Exito | Error;

function manejar(respuesta: Respuesta) {
  switch (respuesta.tipo) {
    case "exito":
      console.log(respuesta.datos); // TypeScript sabe que es Exito
      break;
    case "error":
      console.log(respuesta.mensaje); // TypeScript sabe que es Error
      break;
  }
}
```

### 9. ¿Qué es el operador `!` (Non-null Assertion)?
**Respuesta:** El operador `!` le dice a TypeScript que un valor definitivamente no es `null` ni `undefined`.

```typescript
function obtenerUsuario(id: number): Usuario | undefined {
  // ...
}

const usuario = obtenerUsuario(1)!; // Aseguramos que no es undefined
console.log(usuario.nombre); // No hay error
```

**Precaución:** Solo usar cuando estés 100% seguro de que el valor existe, de lo contrario puede causar errores en runtime.

### 10. ¿Qué es Optional Chaining y Nullish Coalescing?
**Respuesta:**

**Optional Chaining (`?.`):**
Accede a propiedades que pueden ser null/undefined de forma segura.

```typescript
const nombre = usuario?.perfil?.nombre;
// Si usuario o perfil son null/undefined, retorna undefined
```

**Nullish Coalescing (`??`):**
Proporciona un valor por defecto solo si el valor es null o undefined.

```typescript
const puerto = config.puerto ?? 3000;
// Usa config.puerto si existe, sino 3000
// A diferencia de ||, 0 y "" son valores válidos
```

## Preguntas Avanzadas

### 11. ¿Qué son los Mapped Types?
**Respuesta:** Los mapped types permiten crear nuevos tipos transformando las propiedades de un tipo existente.

```typescript
type Readonly<T> = {
  readonly [P in keyof T]: T[P];
};

type Optional<T> = {
  [P in keyof T]?: T[P];
};

interface Usuario {
  nombre: string;
  edad: number;
}

type UsuarioReadonly = Readonly<Usuario>;
// { readonly nombre: string; readonly edad: number; }
```

### 12. ¿Qué son los Conditional Types?
**Respuesta:** Los conditional types permiten crear tipos que dependen de una condición.

```typescript
type EsArray<T> = T extends any[] ? true : false;

type A = EsArray<number[]>; // true
type B = EsArray<string>;   // false

// Extraer tipo de retorno
type ReturnType<T> = T extends (...args: any[]) => infer R ? R : never;
```

### 13. ¿Qué es `keyof` y cómo se usa?
**Respuesta:** `keyof` obtiene las claves de un tipo como una unión de literales.

```typescript
interface Usuario {
  nombre: string;
  edad: number;
  email: string;
}

type ClavesUsuario = keyof Usuario; // "nombre" | "edad" | "email"

function obtenerPropiedad<T, K extends keyof T>(obj: T, key: K): T[K] {
  return obj[key];
}

const usuario: Usuario = { nombre: "Ana", edad: 25, email: "ana@example.com" };
const nombre = obtenerPropiedad(usuario, "nombre"); // string
```

### 14. ¿Qué son los Template Literal Types?
**Respuesta:** Permiten crear tipos usando template literals.

```typescript
type Evento = "click" | "focus" | "blur";
type EventoHandler = `on${Capitalize<Evento>}`;
// "onClick" | "onFocus" | "onBlur"

type Color = "red" | "blue";
type Tamaño = "small" | "large";
type Clase = `${Color}-${Tamaño}`;
// "red-small" | "red-large" | "blue-small" | "blue-large"
```

### 15. ¿Cómo funcionan los Decorators?
**Respuesta:** Los decorators son funciones especiales que pueden modificar clases, métodos, propiedades o parámetros. Son una característica experimental.

```typescript
// Requiere "experimentalDecorators": true en tsconfig.json

function log(target: any, propertyKey: string, descriptor: PropertyDescriptor) {
  const metodoOriginal = descriptor.value;
  
  descriptor.value = function(...args: any[]) {
    console.log(`Llamando a ${propertyKey}`);
    return metodoOriginal.apply(this, args);
  };
}

class Calculadora {
  @log
  sumar(a: number, b: number): number {
    return a + b;
  }
}
```

## Preguntas de Código en Vivo

### 16. Implementa una función que filtre un array por propiedad

```typescript
function filtrarPor<T, K extends keyof T>(
  items: T[],
  propiedad: K,
  valor: T[K]
): T[] {
  return items.filter(item => item[propiedad] === valor);
}

// Uso
interface Producto {
  id: number;
  nombre: string;
  categoria: string;
}

const productos: Producto[] = [
  { id: 1, nombre: "Laptop", categoria: "electrónica" },
  { id: 2, nombre: "Mesa", categoria: "muebles" },
];

const electronicos = filtrarPor(productos, "categoria", "electrónica");
```

### 17. Crea un tipo que haga profundamente readonly

```typescript
type DeepReadonly<T> = {
  readonly [P in keyof T]: T[P] extends object
    ? DeepReadonly<T[P]>
    : T[P];
};

interface Config {
  servidor: {
    puerto: number;
    host: string;
  };
}

type ConfigInmutable = DeepReadonly<Config>;
// Todas las propiedades, incluso anidadas, son readonly
```

### 18. Implementa un sistema de eventos tipado

```typescript
type EventMap = {
  click: { x: number; y: number };
  keypress: { key: string };
  load: void;
};

class EventEmitter<T extends Record<string, any>> {
  private listeners: { [K in keyof T]?: Array<(data: T[K]) => void> } = {};

  on<K extends keyof T>(evento: K, callback: (data: T[K]) => void): void {
    if (!this.listeners[evento]) {
      this.listeners[evento] = [];
    }
    this.listeners[evento]!.push(callback);
  }

  emit<K extends keyof T>(evento: K, data: T[K]): void {
    this.listeners[evento]?.forEach(callback => callback(data));
  }
}

const emitter = new EventEmitter<EventMap>();
emitter.on("click", ({ x, y }) => console.log(x, y));
emitter.emit("click", { x: 10, y: 20 });
```

## Consejos para la Entrevista

1. **Explica tu razonamiento** - No solo escribas código, explica por qué
2. **Pregunta si no entiendes** - Es mejor aclarar que asumir
3. **Empieza simple** - Luego mejora la solución
4. **Menciona trade-offs** - Muestra que entiendes las implicaciones
5. **Usa ejemplos** - Ayuda a clarificar conceptos abstractos
6. **Conoce los fundamentos** - Tipos básicos, interfaces, clases
7. **Practica código en vivo** - Usa TypeScript Playground
8. **Lee mensajes de error** - TypeScript tiene errores muy descriptivos

## Recursos para Preparación

- [TypeScript Handbook](https://www.typescriptlang.org/docs/handbook/intro.html)
- [TypeScript Playground](https://www.typescriptlang.org/play)
- [Type Challenges](https://github.com/type-challenges/type-challenges)
- [Effective TypeScript](https://effectivetypescript.com/)

---

¡Buena suerte en tu entrevista! 🚀
