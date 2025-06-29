// Task entity
// The business entity of the task item 

class TaskEntity{
  final String? id;
  final String title;
  final String? description;
  final DateTime createdAt;
  final DateTime? dueDate;
  final bool isCompleted;
  final DateTime? completedAt;
  
  TaskEntity({
    this.id,
    required this.title,
    this.description,
    required this.createdAt,
    this.dueDate,
    this.isCompleted = false,
    this.completedAt,
  }); // Constructor - initialisation

  // converting into string
  @override
  String toString(){
    return 'TaskModel{title: $title, description: $description, createdAt: $createdAt, dueDate: $dueDate, isCompleted: $isCompleted, completedAt: $completedAt}';
  }
}