// TaskModel data model

import 'dart:convert';
import 'package:todolist/domain/entities/task_entity.dart';

class TaskModel{
  final int? id;
  final String title;
  final String? description;
  final DateTime createdAt;
  final DateTime? dueDate;
  final bool isCompleted;
  final DateTime? completedAt;
  
  TaskModel({
    this.id,
    required this.title,
    this.description,
    required this.createdAt,
    this.dueDate,
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
  /// Creates a TaskModel from a Map
  /// 
  /// This factory constructor converts a map (sqlite response type) into a data model.
  /// Use this when you need to convert from a map to data layer.
  /// 
  /// [map] The map to convert from.
  factory TaskModel.fromMap(Map map) {
    try {
      return TaskModel(
        id: map['id'],
        title: map['title'],
        description: map['description'],
        createdAt: map['createdAt'] is int 
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt']) 
          : DateTime.parse(map['createdAt'].toString()),
        dueDate: map['dueDate'] != null 
          ? (map['dueDate'] is int 
            ? DateTime.fromMillisecondsSinceEpoch(map['dueDate']) 
            : DateTime.parse(map['dueDate'].toString()))
          : null,
        isCompleted: map['isCompleted'] == 1, // Convert from SQLite integer to bool
        completedAt: map['completedAt'] != null 
          ? (map['completedAt'] is int 
            ? DateTime.fromMillisecondsSinceEpoch(map['completedAt']) 
            : DateTime.parse(map['completedAt'].toString()))
          : null,
      );
    } catch (err) {
      throw err;
    }
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
      'dueDate':  dueDate?.toIso8601String(),
      'isCompleted':  isCompleted,
      'completedAt': completedAt?.toIso8601String(),
     };
  }

  String toJson2(){
    return jsonEncode(toMap());
  }

  TaskEntity toEntity(){
    return TaskEntity(id: id!.toString(), title: title, description: description!, createdAt: createdAt, dueDate: dueDate!, completedAt: completedAt!);
  }
}