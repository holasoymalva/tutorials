# 💪 Ejercicios Prácticos de TypeScript

## Nivel Básico

### Ejercicio 1: Tipos Básicos
Crea variables con los siguientes tipos y asígnales valores apropiados:
- Un nombre (string)
- Una edad (number)
- Un estado activo (boolean)
- Una lista de hobbies (array de strings)
- Una tupla con nombre y edad

```typescript
// Tu código aquí
```

### Ejercicio 2: Interfaces
Crea una interfaz `Libro` con las siguientes propiedades:
- titulo (string)
- autor (string)
- año (number)
- disponible (boolean, opcional)
- generos (array de strings)

Luego crea un objeto que implemente esta interfaz.

```typescript
// Tu código aquí
```

### Ejercicio 3: Funciones Tipadas
Crea una función `calcularDescuento` que:
- Reciba un precio (number) y un porcentaje de descuento (number)
- Retorne el precio con descuento aplicado (number)
- El porcentaje debe tener un valor por defecto de 10

```typescript
// Tu código aquí
```

## Nivel Intermedio

### Ejercicio 4: Clases
Crea una clase `CuentaBancaria` con:
- Propiedades privadas: `saldo` (number), `titular` (string)
- Constructor que inicialice el titular con saldo 0
- Método `depositar(cantidad: number): void`
- Método `retirar(cantidad: number): boolean` (retorna false si no hay fondos)
- Getter `getSaldo(): number`

```typescript
// Tu código aquí
```

### Ejercicio 5: Genéricos
Crea una función genérica `obtenerPrimero` que:
- Reciba un array de cualquier tipo
- Retorne el primer elemento o undefined si el array está vacío
- Mantenga el tipo del elemento

```typescript
// Tu código aquí
```

### Ejercicio 6: Type Guards
Crea una función `procesarValor` que:
- Reciba un parámetro de tipo `string | number | boolean`
- Si es string, retorne su longitud
- Si es number, retorne su cuadrado
- Si es boolean, retorne "Sí" o "No"

```typescript
// Tu código aquí
```

## Nivel Avanzado

### Ejercicio 7: Utility Types
Dado el siguiente tipo:

```typescript
interface Producto {
  id: number;
  nombre: string;
  precio: number;
  descripcion: string;
  stock: number;
}
```

Crea los siguientes tipos usando Utility Types:
- `ProductoInput`: Producto sin id
- `ProductoUpdate`: Producto con todas las propiedades opcionales excepto id
- `ProductoResumen`: Solo id, nombre y precio

```typescript
// Tu código aquí
```

### Ejercicio 8: Discriminated Unions
Crea un sistema de formas geométricas:
- Define tipos para Círculo (radio), Cuadrado (lado), Rectángulo (ancho, alto)
- Cada tipo debe tener una propiedad `tipo` discriminante
- Crea una función `calcularArea` que use un switch para calcular el área según el tipo

```typescript
// Tu código aquí
```

### Ejercicio 9: Clase con Genéricos
Crea una clase genérica `Cola<T>` (Queue) que:
- Tenga un array privado de elementos
- Método `agregar(elemento: T): void` - añade al final
- Método `remover(): T | undefined` - remueve del inicio
- Método `ver(): T | undefined` - ve el primero sin remover
- Getter `tamaño: number`

```typescript
// Tu código aquí
```

### Ejercicio 10: Sistema Completo
Crea un mini sistema de gestión de estudiantes:

1. Interface `Estudiante`:
   - id (number)
   - nombre (string)
   - edad (number)
   - calificaciones (array de numbers)

2. Clase `GestorEstudiantes`:
   - Array privado de estudiantes
   - `agregarEstudiante(estudiante: Omit<Estudiante, 'id'>): Estudiante`
   - `obtenerEstudiante(id: number): Estudiante | undefined`
   - `calcularPromedio(id: number): number | undefined`
   - `obtenerMejorEstudiante(): Estudiante | undefined`

```typescript
// Tu código aquí
```

## 🎯 Desafíos Extra

### Desafío 1: API de Tareas Mejorada
Extiende el proyecto principal agregando:
- Subtareas (cada tarea puede tener un array de subtareas)
- Fechas límite con validación
- Categorías personalizadas
- Sistema de recordatorios

### Desafío 2: Sistema de Tipos Avanzado
Crea un sistema de tipos para un carrito de compras que:
- Maneje diferentes tipos de productos (físicos, digitales, servicios)
- Calcule impuestos según el tipo
- Aplique descuentos con reglas complejas
- Use discriminated unions y genéricos

### Desafío 3: Validador de Formularios
Crea un sistema de validación de formularios con:
- Reglas de validación tipadas
- Mensajes de error personalizados
- Validación asíncrona
- Composición de validadores

## 📚 Soluciones

Las soluciones a estos ejercicios están disponibles en la carpeta `soluciones/` (crear después de intentar resolverlos por tu cuenta).

## 💡 Consejos

1. **Intenta resolver sin mirar las soluciones primero**
2. **Usa el autocompletado de tu editor** - TypeScript te ayudará
3. **Lee los mensajes de error** - son muy descriptivos
4. **Experimenta con diferentes enfoques** - hay múltiples formas de resolver cada ejercicio
5. **Compila frecuentemente** - `npm run build` para verificar errores

## 🎓 Preguntas de Entrevista Relacionadas

Después de completar estos ejercicios, deberías poder responder:

1. ¿Cuál es la diferencia entre `interface` y `type`?
2. ¿Qué son los genéricos y cuándo los usarías?
3. ¿Qué es un type guard y por qué es útil?
4. ¿Qué hace el modificador `readonly`?
5. ¿Cuál es la diferencia entre `unknown` y `any`?
6. ¿Qué son los utility types y cuáles son los más comunes?
7. ¿Cómo manejas valores opcionales en TypeScript?
8. ¿Qué es el operador `!` (non-null assertion)?
9. ¿Qué son las discriminated unions?
10. ¿Cómo funciona la inferencia de tipos en TypeScript?

---

¡Buena suerte con los ejercicios! 🚀
