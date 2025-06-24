// TaskModel data model

import 'dart:convert';
import 'package:todolist/domain/entities/task_entity.dart';

class TaskModel{
  final int? id;
  final String title;
  final String description;
  final DateTime createdAt;
  final DateTime dueDate;
  final bool isCompleted;
  final DateTime? completedAt;
  
  TaskModel({
    this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.dueDate,
    this.isCompleted = false,
    this.completedAt,
  }); // Constructor - initialisation

  /// Creates a TaskModel from a TaskEntity.
  /// 
  /// This factory constructor converts a domain entity into a data model.
  /// Use this when you need to convert from domain layer to data layer.
  /// 
  /// [entity] The TaskEntity to convert from.
  factory TaskModel.fromEntity(TaskEntity entity) {
    return TaskModel(
      id: entity.id != null ? int.tryParse(entity.id!) : null,
      title: entity.title,
      description: entity.description,
      createdAt: entity.createdAt,
      dueDate: entity.dueDate,
      isCompleted: entity.isCompleted,
      completedAt: entity.completedAt,
    );
  }
  // Converting into a map 
  Map<String, Object?> toMap(){
    return {
      'id': id,
      'title':  title,
      'description':  description,
      'createdAt':  createdAt,
      'dueDate':  dueDate,
      'isCompleted':  isCompleted,
      'completedAt': completedAt,
    };
  }

  // converting into string
  @override
  String toString(){
    return 'TaskModel{id: $id, title: $title, description: $description, createdAt: $createdAt, dueDate: $dueDate, isCompleted: $isCompleted}';
  }

  /// Converts this Task into a JSON-compatible map.
  /// 
  /// Returns a Map with DateTime values converted to ISO8601 strings.
  /// Useful for API calls and JSON serialization.
  Map<String, dynamic> toJson(){
    return {
      'id': id,
      'title':  title,
      'description':  description,
      'createdAt':  createdAt.toIso8601String(),
      'dueDate':  dueDate.toIso8601String(),
      'isCompleted':  isCompleted,
      'completedAt': completedAt?.toIso8601String(),
     };
  }

  String toJson2(){
    return jsonEncode(toMap());
  }

  TaskEntity toEntity(){
    return TaskEntity(id: id.toString(), title: title, description: description, createdAt: createdAt, dueDate: dueDate, completedAt: completedAt);
  }
}