/// Interface for data sources

import 'package:todolist/data/models/task_model.dart';

/// DataSource 
/// 
/// Abstract interface class for creating data sources

abstract class DataSource{
  Future<List<TaskModel>> getAllTasks();
  Future<void> insertTask(TaskModel todo);
  Future<void> updateTask(TaskModel todo);
  Future<void> deleteTask(String id);

  Future<TaskModel?> getTaskbyId(String id);
  Future<List<TaskModel>> searchTasks(String query);
  Future<List<TaskModel>> getTasksbyStatus(bool isCompleted);

  Future<int> getTotalTasksCount();
  Future<int> getCompletedTasksCount();
}