import { Task, Priority, Status } from '../types';

// Interfaz para el resultado de estadísticas
interface TaskStatistics {
  total: number;
  byStatus: Record<Status, number>;
  byPriority: Record<Priority, number>;
  completionRate: number;
  averageCompletionTime?: number;
}

// CLASE con métodos estáticos
export class StatisticsService {
  // Método estático - no requiere instancia de la clase
  static calculateStatistics(tasks: Task[]): TaskStatistics {
    const stats: TaskStatistics = {
      total: tasks.length,
      byStatus: {
        'pendiente': 0,
        'en-progreso': 0,
        'completada': 0,
        'cancelada': 0,
      },
      byPriority: {
        'baja': 0,
        'media': 0,
        'alta': 0,
        'urgente': 0,
      },
      completionRate: 0,
    };

    // Uso de métodos de array con tipos
    tasks.forEach(task => {
      stats.byStatus[task.status]++;
      stats.byPriority[task.priority]++;
    });

    // Cálculo de tasa de completación
    if (tasks.length > 0) {
      stats.completionRate = (stats.byStatus.completada / tasks.length) * 100;
    }

    // Cálculo de tiempo promedio de completación
    const completedTasks = tasks.filter(
      task => task.status === 'completada' && task.completedAt
    );

    if (completedTasks.length > 0) {
      const totalTime = completedTasks.reduce((sum, task) => {
        const completionTime = task.completedAt!.getTime() - task.createdAt.getTime();
        return sum + completionTime;
      }, 0);

      stats.averageCompletionTime = totalTime / completedTasks.length;
    }

    return stats;
  }

  // Método estático con genéricos
  static groupBy<T, K extends keyof T>(items: T[], key: K): Map<T[K], T[]> {
    return items.reduce((map, item) => {
      const keyValue = item[key];
      const group = map.get(keyValue) || [];
      group.push(item);
      map.set(keyValue, group);
      return map;
    }, new Map<T[K], T[]>());
  }

  // Método con tipo de retorno complejo
  static getMostCommonTags(tasks: Task[], limit: number = 5): Array<{ tag: string; count: number }> {
    const tagCounts = new Map<string, number>();

    tasks.forEach(task => {
      task.tags.forEach(tag => {
        tagCounts.set(tag, (tagCounts.get(tag) || 0) + 1);
      });
    });

    return Array.from(tagCounts.entries())
      .map(([tag, count]) => ({ tag, count }))
      .sort((a, b) => b.count - a.count)
      .slice(0, limit);
  }
}
