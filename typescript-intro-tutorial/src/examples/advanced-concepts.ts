/**
 * CONCEPTOS AVANZADOS DE TYPESCRIPT
 * Ejemplos de características más avanzadas para preparación de entrevistas
 */

// ============================================
// 1. UTILITY TYPES
// ============================================

interface Usuario {
  id: number;
  nombre: string;
  email: string;
  edad: number;
  activo: boolean;
}

// Partial - Todas las propiedades opcionales
type UsuarioParcial = Partial<Usuario>;
const actualizarUsuario: UsuarioParcial = {
  nombre: "Juan", // Solo actualizar nombre
};

// Required - Todas las propiedades requeridas
type UsuarioCompleto = Required<Usuario>;

// Readonly - Todas las propiedades de solo lectura
type UsuarioInmutable = Readonly<Usuario>;
const usuario: UsuarioInmutable = {
  id: 1,
  nombre: "Ana",
  email: "ana@example.com",
  edad: 25,
  activo: true,
};
// usuario.nombre = "María"; // Error: no se puede modificar

// Pick - Seleccionar propiedades específicas
type UsuarioResumen = Pick<Usuario, "id" | "nombre">;
const resumen: UsuarioResumen = {
  id: 1,
  nombre: "Pedro",
};

// Omit - Excluir propiedades específicas
type UsuarioSinId = Omit<Usuario, "id">;
const nuevoUsuario: UsuarioSinId = {
  nombre: "Laura",
  email: "laura@example.com",
  edad: 28,
  activo: true,
};

// Record - Crear objeto con claves y valores específicos
type UsuariosPorId = Record<number, Usuario>;
const usuarios: UsuariosPorId = {
  1: { id: 1, nombre: "Ana", email: "ana@example.com", edad: 25, activo: true },
  2: { id: 2, nombre: "Juan", email: "juan@example.com", edad: 30, activo: true },
};

// ============================================
// 2. MAPPED TYPES
// ============================================

// Hacer todas las propiedades opcionales manualmente
type Opcional<T> = {
  [P in keyof T]?: T[P];
};

type UsuarioOpcional = Opcional<Usuario>;

// Hacer todas las propiedades de solo lectura manualmente
type SoloLectura<T> = {
  readonly [P in keyof T]: T[P];
};

// ============================================
// 3. CONDITIONAL TYPES
// ============================================

// Type que verifica si T es un array
type EsArray<T> = T extends any[] ? true : false;

type Resultado1 = EsArray<number[]>; // true
type Resultado2 = EsArray<string>;   // false

// Extraer el tipo de retorno de una función
type ReturnType<T> = T extends (...args: any[]) => infer R ? R : never;

function obtenerUsuario(): Usuario {
  return { id: 1, nombre: "Test", email: "test@example.com", edad: 25, activo: true };
}

type TipoRetorno = ReturnType<typeof obtenerUsuario>; // Usuario

// ============================================
// 4. TEMPLATE LITERAL TYPES
// ============================================

type Evento = "click" | "focus" | "blur";
type EventoHandler = `on${Capitalize<Evento>}`; // "onClick" | "onFocus" | "onBlur"

type Color = "red" | "blue" | "green";
type Tamaño = "small" | "medium" | "large";
type EstiloBoton = `${Color}-${Tamaño}`; // "red-small" | "red-medium" | ...

// ============================================
// 5. DISCRIMINATED UNIONS
// ============================================

// Uniones discriminadas para manejar diferentes tipos de respuestas
interface RespuestaExito {
  tipo: "exito";
  datos: any;
}

interface RespuestaError {
  tipo: "error";
  mensaje: string;
  codigo: number;
}

interface RespuestaCargando {
  tipo: "cargando";
}

type Respuesta = RespuestaExito | RespuestaError | RespuestaCargando;

function manejarRespuesta(respuesta: Respuesta): void {
  switch (respuesta.tipo) {
    case "exito":
      console.log("Datos:", respuesta.datos);
      break;
    case "error":
      console.error(`Error ${respuesta.codigo}: ${respuesta.mensaje}`);
      break;
    case "cargando":
      console.log("Cargando...");
      break;
    default:
      // TypeScript verifica que todos los casos estén cubiertos
      const _exhaustive: never = respuesta;
  }
}

// ============================================
// 6. INDEX SIGNATURES
// ============================================

// Objeto con claves dinámicas
interface Diccionario {
  [clave: string]: string;
}

const traducciones: Diccionario = {
  hola: "hello",
  adios: "goodbye",
  gracias: "thank you",
};

// Con tipos más específicos
interface ConfiguracionApp {
  nombre: string;
  version: string;
  [opcion: string]: string | number | boolean;
}

const config: ConfiguracionApp = {
  nombre: "Mi App",
  version: "1.0.0",
  debug: true,
  puerto: 3000,
};

// ============================================
// 7. FUNCTION OVERLOADS
// ============================================

// Sobrecarga de funciones
function formatear(valor: string): string;
function formatear(valor: number): string;
function formatear(valor: boolean): string;
function formatear(valor: string | number | boolean): string {
  if (typeof valor === "string") {
    return valor.toUpperCase();
  } else if (typeof valor === "number") {
    return valor.toFixed(2);
  } else {
    return valor ? "Sí" : "No";
  }
}

const texto = formatear("hola");     // string
const numero = formatear(42);        // string
const booleano = formatear(true);    // string

// ============================================
// 8. ABSTRACT CLASSES
// ============================================

// Clase abstracta - no se puede instanciar directamente
abstract class Forma {
  abstract calcularArea(): number;
  abstract calcularPerimetro(): number;

  // Método concreto
  describir(): string {
    return `Área: ${this.calcularArea()}, Perímetro: ${this.calcularPerimetro()}`;
  }
}

class Rectangulo extends Forma {
  constructor(private ancho: number, private alto: number) {
    super();
  }

  calcularArea(): number {
    return this.ancho * this.alto;
  }

  calcularPerimetro(): number {
    return 2 * (this.ancho + this.alto);
  }
}

class Circulo extends Forma {
  constructor(private radio: number) {
    super();
  }

  calcularArea(): number {
    return Math.PI * this.radio ** 2;
  }

  calcularPerimetro(): number {
    return 2 * Math.PI * this.radio;
  }
}

// ============================================
// 9. DECORATORS (Experimental)
// ============================================

// Nota: Requiere "experimentalDecorators": true en tsconfig.json

// Decorador de método simple
function log(target: any, propertyKey: string, descriptor: PropertyDescriptor) {
  const metodoOriginal = descriptor.value;

  descriptor.value = function (...args: any[]) {
    console.log(`Llamando a ${propertyKey} con argumentos:`, args);
    const resultado = metodoOriginal.apply(this, args);
    console.log(`${propertyKey} retornó:`, resultado);
    return resultado;
  };

  return descriptor;
}

class Calculadora {
  @log
  sumar(a: number, b: number): number {
    return a + b;
  }
}

// ============================================
// 10. NAMESPACE
// ============================================

namespace Validaciones {
  export function esEmail(texto: string): boolean {
    return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(texto);
  }

  export function esNumero(texto: string): boolean {
    return !isNaN(Number(texto));
  }

  export function longitudMinima(texto: string, min: number): boolean {
    return texto.length >= min;
  }
}

// Uso
const emailValido = Validaciones.esEmail("test@example.com");
const esNum = Validaciones.esNumero("123");

// ============================================
// EXPORTAR PARA USO
// ============================================

export {
  type UsuarioParcial,
  type UsuarioResumen,
  type Respuesta,
  Rectangulo,
  Circulo,
  Validaciones,
};
