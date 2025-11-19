/**
 * EJEMPLOS DE TIPOS BÁSICOS EN TYPESCRIPT
 * Este archivo contiene ejemplos comentados de todos los tipos básicos
 */

// ============================================
// 1. TIPOS PRIMITIVOS
// ============================================

// String
const nombre: string = "Juan Pérez";
const apellido: string = 'García';
const nombreCompleto: string = `${nombre} ${apellido}`; // Template literals

// Number
const edad: number = 25;
const precio: number = 99.99;
const hexadecimal: number = 0xf00d;
const binario: number = 0b1010;

// Boolean
const esActivo: boolean = true;
const tienePermiso: boolean = false;

// ============================================
// 2. ARRAYS
// ============================================

// Array de números - Sintaxis 1
const numeros: number[] = [1, 2, 3, 4, 5];

// Array de strings - Sintaxis 2
const frutas: Array<string> = ["manzana", "pera", "uva"];

// Array de objetos
interface Producto {
  id: number;
  nombre: string;
  precio: number;
}

const productos: Producto[] = [
  { id: 1, nombre: "Laptop", precio: 1200 },
  { id: 2, nombre: "Mouse", precio: 25 },
];

// ============================================
// 3. TUPLAS
// ============================================

// Tupla - array con tipos y longitud fijos
let persona: [string, number, boolean];
persona = ["Ana", 30, true]; // ✓ Correcto
// persona = [30, "Ana", true]; // ✗ Error: orden incorrecto

// Tupla con nombres (TypeScript 4.0+)
type Coordenada = [x: number, y: number];
const punto: Coordenada = [10, 20];

// ============================================
// 4. ENUM
// ============================================

// Enum numérico
enum DiaSemana {
  Lunes,    // 0
  Martes,   // 1
  Miercoles, // 2
  Jueves,   // 3
  Viernes,  // 4
}

const hoy: DiaSemana = DiaSemana.Lunes;

// Enum con valores personalizados
enum HttpStatus {
  OK = 200,
  NotFound = 404,
  InternalError = 500,
}

// Enum de strings
enum Direccion {
  Norte = "NORTE",
  Sur = "SUR",
  Este = "ESTE",
  Oeste = "OESTE",
}

// ============================================
// 5. ANY, UNKNOWN, NEVER
// ============================================

// Any - evitar en lo posible
let cualquierCosa: any = "texto";
cualquierCosa = 42;
cualquierCosa = true;

// Unknown - más seguro que any
let valorDesconocido: unknown = 4;
// valorDesconocido.toFixed(); // Error: necesita type guard

if (typeof valorDesconocido === "number") {
  valorDesconocido.toFixed(2); // ✓ Correcto después del type guard
}

// Never - para funciones que nunca retornan
function error(mensaje: string): never {
  throw new Error(mensaje);
}

function loopInfinito(): never {
  while (true) {
    // Loop infinito
  }
}

// ============================================
// 6. VOID, NULL, UNDEFINED
// ============================================

// Void - función sin retorno
function saludar(): void {
  console.log("Hola");
}

// Null y Undefined
let valorNulo: null = null;
let valorIndefinido: undefined = undefined;

// Con strictNullChecks, null y undefined son tipos separados
let texto: string = "hola";
// texto = null; // Error con strictNullChecks

// Permitir null explícitamente
let textoOpcional: string | null = "hola";
textoOpcional = null; // ✓ Correcto

// ============================================
// 7. OBJECT
// ============================================

// Object genérico
let usuario: object = { nombre: "Juan", edad: 25 };

// Mejor: definir estructura específica
let usuarioTipado: { nombre: string; edad: number } = {
  nombre: "Juan",
  edad: 25,
};

// ============================================
// 8. UNION TYPES
// ============================================

// Puede ser uno de varios tipos
let id: number | string;
id = 123;      // ✓ Correcto
id = "ABC123"; // ✓ Correcto
// id = true;  // ✗ Error

// Union con tipos literales
type Respuesta = "si" | "no" | "tal vez";
let respuesta: Respuesta = "si";

// ============================================
// 9. INTERSECTION TYPES
// ============================================

// Combina múltiples tipos
interface Empleado {
  id: number;
  nombre: string;
}

interface Contacto {
  email: string;
  telefono: string;
}

type EmpleadoConContacto = Empleado & Contacto;

const empleado: EmpleadoConContacto = {
  id: 1,
  nombre: "María",
  email: "maria@example.com",
  telefono: "555-1234",
};

// ============================================
// 10. TYPE ASSERTIONS
// ============================================

// Cuando sabes más que TypeScript sobre el tipo
let algunValor: unknown = "esto es un string";

// Sintaxis 1: as
let longitudString: number = (algunValor as string).length;

// Sintaxis 2: angle-bracket (no usar en JSX/TSX)
let longitudString2: number = (<string>algunValor).length;

// ============================================
// 11. LITERAL TYPES
// ============================================

// Valores específicos como tipos
let direccion: "arriba" | "abajo" | "izquierda" | "derecha";
direccion = "arriba"; // ✓ Correcto
// direccion = "diagonal"; // ✗ Error

// Números literales
let dado: 1 | 2 | 3 | 4 | 5 | 6;
dado = 3; // ✓ Correcto

// ============================================
// EXPORTAR PARA USO EN OTROS ARCHIVOS
// ============================================

export {
  DiaSemana,
  HttpStatus,
  Direccion,
  type Producto,
  type Coordenada,
  type Respuesta,
  type EmpleadoConContacto,
};
