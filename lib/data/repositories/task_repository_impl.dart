/// task_repository_impl.dart
/// 
/// Implementation of the (abstract) task repository 

import 'dart:async';

import 'package:todolist/domain/repositories/task_repository.dart';
import 'package:todolist/data/datasources/todo_sqlite_datasource.dart';
import 'package:todolist/domain/entities/task_entity.dart';
import 'package:todolist/data/models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final SqliteDataSource dataSource;

  TaskRepositoryImpl({
    required this.dataSource,
  });

  @override
  Future<List<TaskEntity>> getAllTasks() async {
    try{
      final List<TaskModel> taskModels = await dataSource.getAllTasks();
      return taskModels.map((model) => model.toEntity()).toList(); // using a map function to convert each model to entity
    } catch(err){
      throw Exception("An exception occured: $err");
    }
  }

  @override
  Future<TaskEntity?> getTaskbyId(int id) async {
    // requirement: to figure out if the ID does not exist
    try{
      final TaskModel? targetTask = await dataSource.getTaskbyId(id);
      return targetTask?.toEntity(); // returns the relevant task
    } catch(err){
      throw Exception("An exception with fetching task occurred: $err");
    }
  }

  @override
  Future<void> addTask(TaskEntity todo) async {
    try{
      final TaskModel taskModel = TaskModel.fromEntity(todo);
      await dataSource.insertTask(taskModel);
    } catch(err){
      throw Exception("An exception with adding tasks occurred: $err");
    }
  }
  @override
  Future<void> deleteTask(String id) async {
    try{
      dataSource.deleteTask(id);
    } catch (err) {
      throw Exception("An exception with deleting task: $err");
    }
  }

  @override
  Future<void> updateTask(TaskEntity todo) async {
    try{
      final TaskModel taskModel = TaskModel.fromEntity(todo);
      await dataSource.updateTask(taskModel);
    } catch (err) {
      throw Exception("An exception with updating task: $err");
    }
  }
  
  @override
  Future<List<TaskEntity>> searchTasks(String query) async {
    try{
      final List<TaskModel> resultTaskModels = await dataSource.searchTasks(query);
      return resultTaskModels.map((model) => model.toEntity()).toList();
    } catch (err) {
      throw Exception("An exception with searching for task: $err");
    }
  }
  
  @override
  Future<List<TaskEntity>> getTasksbyStatus(bool isCompleted) async {
    try{
      final List<TaskModel> completedTaskModels = await dataSource.getTasksbyStatus(isCompleted);
      return completedTaskModels.map((model) => model.toEntity()).toList();
    } catch (err) {
      throw Exception("An exception with looking for tasks: $err");
    }
  }

  @override
  Future<int> totalTasksCount() async {
    int taskCount = await dataSource.getTotalTasksCount();
    return taskCount;
  }

  @override
  Future<int> completedTasksCount() async {
    int completedTaskCount = await dataSource.getCompletedTasksCount();
    return completedTaskCount;
  }

}