import { Task, TaskInput, TaskUpdate, Priority, Status } from '../types';

// CLASE con TypeScript - Demuestra POO con tipos
export class TaskManager {
  // Propiedades privadas
  private tasks: Task[] = [];
  private nextId: number = 1;

  // Constructor con parámetros tipados
  constructor(initialTasks: Task[] = []) {
    this.tasks = initialTasks;
    if (initialTasks.length > 0) {
      this.nextId = Math.max(...initialTasks.map(t => t.id)) + 1;
    }
  }

  // Método público que retorna un tipo específico
  public createTask(taskInput: TaskInput): Task {
    const newTask: Task = {
      id: this.nextId++,
      ...taskInput,
      createdAt: new Date(),
    };
    
    this.tasks.push(newTask);
    return newTask;
  }

  // Método con parámetros opcionales
  public getAllTasks(filterByStatus?: Status): Task[] {
    if (filterByStatus) {
      return this.tasks.filter(task => task.status === filterByStatus);
    }
    return [...this.tasks]; // Retorna copia para inmutabilidad
  }

  // Método que puede retornar undefined
  public getTaskById(id: number): Task | undefined {
    return this.tasks.find(task => task.id === id);
  }

  // Método con tipo de retorno void
  public updateTask(id: number, updates: TaskUpdate): void {
    const taskIndex = this.tasks.findIndex(task => task.id === id);
    
    if (taskIndex === -1) {
      throw new Error(`Tarea con ID ${id} no encontrada`);
    }

    this.tasks[taskIndex] = {
      ...this.tasks[taskIndex],
      ...updates,
    };
  }

  // Método que retorna boolean
  public deleteTask(id: number): boolean {
    const initialLength = this.tasks.length;
    this.tasks = this.tasks.filter(task => task.id !== id);
    return this.tasks.length < initialLength;
  }

  // Método con múltiples parámetros tipados
  public completeTask(id: number, completedAt: Date = new Date()): Task {
    const task = this.getTaskById(id);
    
    if (!task) {
      throw new Error(`Tarea con ID ${id} no encontrada`);
    }

    this.updateTask(id, {
      status: 'completada',
      completedAt,
    });

    return this.getTaskById(id)!; // ! indica que sabemos que no es undefined
  }

  // Getter - propiedad computada
  public get taskCount(): number {
    return this.tasks.length;
  }

  // Método con array de tipos específicos
  public getTasksByPriority(priority: Priority): Task[] {
    return this.tasks.filter(task => task.priority === priority);
  }
}
