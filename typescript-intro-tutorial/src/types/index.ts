// 1. TIPOS BÁSICOS Y PRIMITIVOS
export type Priority = 'baja' | 'media' | 'alta' | 'urgente';
export type Status = 'pendiente' | 'en-progreso' | 'completada' | 'cancelada';

// 2. INTERFACES - Definen la estructura de objetos
export interface Task {
  id: number;
  title: string;
  description: string;
  priority: Priority;
  status: Status;
  createdAt: Date;
  completedAt?: Date; // Propiedad opcional con ?
  tags: string[];
}

// 3. TIPOS PERSONALIZADOS (Type Aliases)
export type TaskInput = Omit<Task, 'id' | 'createdAt' | 'completedAt'>;
export type TaskUpdate = Partial<Omit<Task, 'id' | 'createdAt'>>;

// 4. INTERFACES EXTENDIDAS
export interface User {
  id: number;
  name: string;
  email: string;
}

export interface TaskWithUser extends Task {
  assignedTo?: User;
}

// 5. TIPOS DE UTILIDAD (Utility Types)
export type ReadonlyTask = Readonly<Task>;
export type TaskKeys = keyof Task;
export type TaskRecord = Record<number, Task>;
