/// SQLite Data Source
/// 
/// Interfaces with SQLite for CRUD operations, providing results in TaskModel type

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:todolist/data/datasources/todo_datasource.dart';
import 'package:todolist/data/models/task_model.dart';

/// SQLite Data Source
/// 
/// This is implemented with SQFLite module to perform CRUD operations
class SqliteDataSource implements DataSource{
  // Important variables
  final String _databaseName = 'todolist_database.db';
  final int _databaseVersion = 1;
  final String _tableName = 'tasks';
  // Singleton database (static)
  static Database? _database;

  /// connect: Creates a connection to the database and returns [Database] object
  Future<Database> connect() async {
    if (_database != null) {
      // connection already exists
      return _database!;
    }

    // Getting path of db
    String dbPath = join(await getDatabasesPath(), _databaseName);
    // Create connection
    _database = await openDatabase(
      dbPath,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
    
    return _database!;
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $_tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT, 
        title TEXT NOT NULL,
        description TEXT,
        createdAt INTEGER NOT NULL,
        updatedAt INTEGER,
        dueDate INTEGER,
        isCompleted BOOLEAN DEFAULT false NOT NULL, 
        completedAt INTEGER
      );
''');
  }

  @override
  Future<List<TaskModel>> getAllTasks() async {
    try {
      Database db = await connect();
      List<Map<String, dynamic>> tasks = await db.query(_tableName);
      return tasks.map((map) => TaskModel.fromMap(map)).toList();
    } catch (err) {
      rethrow;
    }
  }

  @override
  Future<TaskModel?> getTaskbyId(String id) async {
    try {
      Database db = await connect();
      final List<Map<String, dynamic>> task = await db.query(
        _tableName,
        where: 'id = ?',
        whereArgs: [int.parse(id)],
      );
      
      if (task.isEmpty) {
        return null; // empty list leads to no result obtained
      }
      return TaskModel.fromMap(task.first);
    } catch (err) {
      rethrow;
    }
  }

  @override
  Future<void> insertTask(TaskModel task) async {
    try {
      Database db = await connect();
      
      // Create a map without the ID if it's null (for auto-increment)
      Map<String, Object?> taskMap = task.toMap();
      if (task.id == null) {
        taskMap.remove('id');
      }
      
      // Handle DateTime objects correctly
      taskMap['createdAt'] = task.createdAt.millisecondsSinceEpoch;
      if (task.dueDate != null) {
        taskMap['dueDate'] = task.dueDate!.millisecondsSinceEpoch;
      }
      if (task.completedAt != null) {
        taskMap['completedAt'] = task.completedAt!.millisecondsSinceEpoch;
      }
      
      await db.insert(_tableName, taskMap);
    } catch (err) {
      rethrow;
    }
  }

  @override
  Future<void> updateTask(TaskModel task) async {
    try {
      Database db = await connect();
      
      if (task.id == null) {
        throw Exception("Cannot update task without an ID");
      }
      
      // Create map for update
      Map<String, Object?> taskMap = task.toMap();
      taskMap.remove('id'); // Remove ID from update values
      
      // Handle DateTime objects correctly
      taskMap['createdAt'] = task.createdAt.millisecondsSinceEpoch;
      if (task.dueDate != null) {
        taskMap['dueDate'] = task.dueDate!.millisecondsSinceEpoch;
      }
      if (task.completedAt != null) {
        taskMap['completedAt'] = task.completedAt!.millisecondsSinceEpoch;
      }
      
      await db.update(
        _tableName, 
        taskMap,
        where: 'id = ?',
        whereArgs: [task.id]
      );
    } catch (err) {
      rethrow;
    }
  }

  @override
  Future<void> deleteTask(String id) async {
    try {
      Database db = await connect();
      await db.delete(
        _tableName,
        where: 'id = ?',
        whereArgs: [int.parse(id)]
      );
    } catch (err) {
      rethrow;
    }
  }

  @override
  Future<List<TaskModel>> searchTasks(String query) async {
    try {
      Database db = await connect();
      
      // Use LIKE operator with % wildcards for partial matches
      String searchPattern = '%$query%';
      
      // Query for matches in title or description
      List<Map<String, dynamic>> matches = await db.rawQuery(
        "SELECT * FROM $_tableName WHERE title LIKE ? OR description LIKE ?",
        [searchPattern, searchPattern]
      );
      
      // Convert to TaskModel list
      return matches.map((m) => TaskModel.fromMap(m)).toList();
    } catch (err) {
      rethrow;      
    }
  }

  @override
  Future<List<TaskModel>> getTasksbyStatus(bool isCompleted) async {
    try {
      Database db = await connect();
      
      // Use parameterized query
      List<Map<String, dynamic>> matches = await db.query(
        _tableName,
        where: 'isCompleted = ?',
        whereArgs: [isCompleted ? 1 : 0], // SQLite uses 1/0 for boolean
      );
      
      // Convert to TaskModel list
      return matches.map((m) => TaskModel.fromMap(m)).toList();
    } catch (err) {
      rethrow;      
    }
  }
  
 
  @override
  Future<int> getTotalTasksCount() async {
    try {
      Database db = await connect();
      final result = await db.rawQuery("SELECT COUNT(*) as count FROM $_tableName");
      return Sqflite.firstIntValue(result) ?? 0;
    } catch (err) {
      rethrow;
    }
  }

  @override
  Future<int> getCompletedTasksCount() async {
    try {
      Database db = await connect();
      final result = await db.rawQuery("SELECT COUNT(*) as count FROM $_tableName WHERE isCompleted = 1");
      return Sqflite.firstIntValue(result) ?? 0;
    } catch (err) {
      rethrow;
    }
  }
}