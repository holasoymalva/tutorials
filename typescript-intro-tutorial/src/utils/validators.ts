import { Priority, Status } from '../types';

// FUNCIONES con tipos explícitos

// Función con parámetros y retorno tipados
export function isValidEmail(email: string): boolean {
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return emailRegex.test(email);
}

// Función con type guards (guardias de tipo)
export function isPriority(value: string): value is Priority {
  return ['baja', 'media', 'alta', 'urgente'].includes(value);
}

export function isStatus(value: string): value is Status {
  return ['pendiente', 'en-progreso', 'completada', 'cancelada'].includes(value);
}

// Función con parámetros opcionales y valores por defecto
export function validateTaskTitle(
  title: string,
  minLength: number = 3,
  maxLength: number = 100
): { valid: boolean; error?: string } {
  if (title.length < minLength) {
    return {
      valid: false,
      error: `El título debe tener al menos ${minLength} caracteres`,
    };
  }
  
  if (title.length > maxLength) {
    return {
      valid: false,
      error: `El título no puede exceder ${maxLength} caracteres`,
    };
  }
  
  return { valid: true };
}

// Función genérica
export function filterByProperty<T, K extends keyof T>(
  items: T[],
  property: K,
  value: T[K]
): T[] {
  return items.filter(item => item[property] === value);
}

// Función con rest parameters
export function combineStrings(...strings: string[]): string {
  return strings.join(' ');
}

// Función que retorna otra función (Higher Order Function)
export function createLogger(prefix: string): (message: string) => void {
  return (message: string) => {
    console.log(`[${prefix}] ${message}`);
  };
}
