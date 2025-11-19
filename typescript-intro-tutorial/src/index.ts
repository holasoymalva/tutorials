import { TaskManager } from './models/TaskManager';
import { StatisticsService } from './services/StatisticsService';
import { formatTask, formatTaskList, Color } from './utils/formatters';
import { validateTaskTitle } from './utils/validators';
import { TaskInput } from './types';

// FUNCIÓN PRINCIPAL - Demostración del proyecto
function main(): void {
  console.log(`${Color.Green}=== FUNDAMENTOS PRÁCTICOS DE TYPESCRIPT ===${Color.Reset}\n`);

  // 1. Crear instancia de TaskManager
  const taskManager = new TaskManager();

  console.log(`${Color.Magenta}1. CREANDO TAREAS${Color.Reset}`);
  
  // 2. Crear tareas con tipos definidos
  const tasksToCreate: TaskInput[] = [
    {
      title: 'Aprender tipos básicos de TypeScript',
      description: 'Estudiar string, number, boolean, arrays y tuplas',
      priority: 'alta',
      status: 'completada',
      tags: ['typescript', 'fundamentos', 'tipos'],
    },
    {
      title: 'Dominar interfaces y types',
      description: 'Entender la diferencia y cuándo usar cada uno',
      priority: 'alta',
      status: 'completada',
      tags: ['typescript', 'interfaces', 'types'],
    },
    {
      title: 'Practicar con clases',
      description: 'Crear clases con propiedades y métodos tipados',
      priority: 'media',
      status: 'en-progreso',
      tags: ['typescript', 'POO', 'clases'],
    },
    {
      title: 'Estudiar genéricos',
      description: 'Aprender a crear funciones y clases genéricas',
      priority: 'media',
      status: 'pendiente',
      tags: ['typescript', 'genéricos', 'avanzado'],
    },
    {
      title: 'Preparar entrevista técnica',
      description: 'Repasar todos los conceptos y practicar ejercicios',
      priority: 'urgente',
      status: 'pendiente',
      tags: ['entrevista', 'práctica'],
    },
  ];

  // Validar y crear tareas
  tasksToCreate.forEach(taskInput => {
    const validation = validateTaskTitle(taskInput.title);
    
    if (validation.valid) {
      const task = taskManager.createTask(taskInput);
      console.log(`✓ Tarea creada: ${task.title}`);
    } else {
      console.log(`✗ Error: ${validation.error}`);
    }
  });

  // 3. Completar tareas
  console.log(`\n${Color.Magenta}2. COMPLETANDO TAREAS${Color.Reset}`);
  taskManager.completeTask(1);
  taskManager.completeTask(2);
  console.log('✓ Tareas 1 y 2 marcadas como completadas');

  // 4. Mostrar todas las tareas
  console.log(`\n${Color.Magenta}3. LISTA DE TODAS LAS TAREAS${Color.Reset}`);
  const allTasks = taskManager.getAllTasks();
  console.log(formatTaskList(allTasks));

  // 5. Filtrar tareas por estado
  console.log(`\n${Color.Magenta}4. TAREAS PENDIENTES${Color.Reset}`);
  const pendingTasks = taskManager.getAllTasks('pendiente');
  console.log(formatTaskList(pendingTasks));

  // 6. Mostrar detalle de una tarea
  console.log(`\n${Color.Magenta}5. DETALLE DE TAREA${Color.Reset}`);
  const task = taskManager.getTaskById(1);
  if (task) {
    console.log(formatTask(task));
  }

  // 7. Actualizar una tarea
  console.log(`\n${Color.Magenta}6. ACTUALIZANDO TAREA${Color.Reset}`);
  taskManager.updateTask(3, {
    status: 'completada',
    completedAt: new Date(),
  });
  console.log('✓ Tarea 3 actualizada');

  // 8. Estadísticas
  console.log(`\n${Color.Magenta}7. ESTADÍSTICAS${Color.Reset}`);
  const stats = StatisticsService.calculateStatistics(allTasks);
  console.log(`Total de tareas: ${stats.total}`);
  console.log(`Completadas: ${stats.byStatus.completada}`);
  console.log(`En progreso: ${stats.byStatus['en-progreso']}`);
  console.log(`Pendientes: ${stats.byStatus.pendiente}`);
  console.log(`Tasa de completación: ${stats.completionRate.toFixed(2)}%`);

  // 9. Etiquetas más comunes
  console.log(`\n${Color.Magenta}8. ETIQUETAS MÁS USADAS${Color.Reset}`);
  const topTags = StatisticsService.getMostCommonTags(allTasks, 3);
  topTags.forEach((item, index) => {
    console.log(`${index + 1}. ${item.tag}: ${item.count} veces`);
  });

  // 10. Agrupar por prioridad
  console.log(`\n${Color.Magenta}9. TAREAS POR PRIORIDAD${Color.Reset}`);
  const tasksByPriority = StatisticsService.groupBy(allTasks, 'priority');
  tasksByPriority.forEach((tasks, priority) => {
    console.log(`${priority}: ${tasks.length} tarea(s)`);
  });

  // 11. Información final
  console.log(`\n${Color.Green}=== PROYECTO COMPLETADO ===${Color.Reset}`);
  console.log(`Total de tareas gestionadas: ${taskManager.taskCount}`);
  console.log(`\n${Color.Yellow}¡Felicidades! Has completado el tutorial de TypeScript.${Color.Reset}`);
  console.log(`${Color.Yellow}Revisa el código fuente para entender cada concepto.${Color.Reset}\n`);
}

// Manejo de errores con tipos
try {
  main();
} catch (error) {
  if (error instanceof Error) {
    console.error(`${Color.Red}Error: ${error.message}${Color.Reset}`);
  } else {
    console.error(`${Color.Red}Error desconocido${Color.Reset}`);
  }
  process.exit(1);
}
