import { Task, Priority, Status } from '../types';

// ENUMS - Enumeraciones
export enum Color {
  Reset = '\x1b[0m',
  Red = '\x1b[31m',
  Green = '\x1b[32m',
  Yellow = '\x1b[33m',
  Blue = '\x1b[34m',
  Magenta = '\x1b[35m',
}

// Función con switch y tipos literales
export function getPriorityColor(priority: Priority): Color {
  switch (priority) {
    case 'baja':
      return Color.Blue;
    case 'media':
      return Color.Yellow;
    case 'alta':
      return Color.Magenta;
    case 'urgente':
      return Color.Red;
    default:
      // TypeScript verifica que todos los casos estén cubiertos
      const _exhaustive: never = priority;
      return Color.Reset;
  }
}

export function getStatusColor(status: Status): Color {
  switch (status) {
    case 'pendiente':
      return Color.Yellow;
    case 'en-progreso':
      return Color.Blue;
    case 'completada':
      return Color.Green;
    case 'cancelada':
      return Color.Red;
    default:
      const _exhaustive: never = status;
      return Color.Reset;
  }
}

// Función con template literals tipados
export function formatTask(task: Task): string {
  const priorityColor = getPriorityColor(task.priority);
  const statusColor = getStatusColor(task.status);
  
  return `
${Color.Blue}ID:${Color.Reset} ${task.id}
${Color.Blue}Título:${Color.Reset} ${task.title}
${Color.Blue}Descripción:${Color.Reset} ${task.description}
${Color.Blue}Prioridad:${Color.Reset} ${priorityColor}${task.priority}${Color.Reset}
${Color.Blue}Estado:${Color.Reset} ${statusColor}${task.status}${Color.Reset}
${Color.Blue}Etiquetas:${Color.Reset} ${task.tags.join(', ')}
${Color.Blue}Creada:${Color.Reset} ${task.createdAt.toLocaleDateString('es-ES')}
${task.completedAt ? `${Color.Blue}Completada:${Color.Reset} ${task.completedAt.toLocaleDateString('es-ES')}` : ''}
  `.trim();
}

// Función con arrays tipados
export function formatTaskList(tasks: Task[]): string {
  if (tasks.length === 0) {
    return 'No hay tareas para mostrar.';
  }
  
  return tasks
    .map((task, index) => `\n${index + 1}. ${task.title} [${task.status}] - Prioridad: ${task.priority}`)
    .join('\n');
}
