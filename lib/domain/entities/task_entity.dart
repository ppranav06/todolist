// Task entity
// The business entity of the task item 

import 'dart:convert';

class TaskEntity{
  final String id;
  final String title;
  final String description;
  final DateTime createdAt;
  final DateTime dueDate;
  final bool isCompleted;
  final DateTime? completedAt;
  
  TaskEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.dueDate,
    this.isCompleted = false,
    this.completedAt,
  }); // Constructor - initialisation

  // converting into string
  @override
  String toString(){
    return 'TaskModel{id: $id, title: $title, description: $description, createdAt: $createdAt, dueDate: $dueDate, isCompleted: $isCompleted}';
  }
}