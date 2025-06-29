// task_repository

// Abstract structure of the task handler

import 'package:todolist/domain/entities/task_entity.dart';

abstract class TaskRepository{
  // defining the required members and attributes

  Future<List<TaskEntity>> getAllTasks();
  Future<TaskEntity?> getTaskbyId(String id);
  Future<void> addTask(TaskEntity todo);
  Future<void> updateTask(TaskEntity todo);
  Future<void> deleteTask(String id);
  Future<List<TaskEntity>> searchTasks(String query);
  Future<List<TaskEntity>> getTasksbyStatus(bool isCompleted);

  Future<int> totalTasksCount();
  Future<int> completedTasksCount();
}