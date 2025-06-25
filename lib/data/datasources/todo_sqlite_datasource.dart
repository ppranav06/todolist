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
      List tasks = await db.query("select * from $_tableName;");
      return tasks.map((map) => TaskModel.fromMap(map)).toList();
    }  catch (err) {
      throw err;
    }
  }

  @override
  Future<TaskModel?> getTaskbyId(String id) async {
    try {
      Database db = await connect();
      final task = await db.query("select * from $_tableName where id=$id;");
      if (task == []) {
        return null; // empty list leads to no result obtained
      }
      return TaskModel.fromMap(task[0]);
    } catch (err) {
      throw err;
    }
  }

  @override
  Future<void> insertTask(TaskModel task) async {
    try {
      Database db = await connect();
      final result = db.query('''
        INSERT INTO $_tableName (${task.toMap().keys})  
        VALUES ${task.toMap().values}''');
      // apparently task.toMap().keys must return only the relevant keys. gotta test this method
    } catch (err) {
      throw err;
    }
  }

  @override
  Future<void> updateTask(TaskModel task) async {
    try {
      Database db = await connect();
      final result = db.query('''
      UPDATE $_tableName SET (${task.toMap().keys}) VALUES 
      (${task.toMap().values})
      '''); // similar to insert query 
    } catch (err) {
      throw err;
    }
  }

  @override
  Future<void> deleteTask(String id) async {
    try {
      Database db = await connect();
      final result = db.query('''DELETE FROM $_tableName WHERE id=$id''');
    } catch (err) {
      throw err;
    }
  }

  @override
  Future<List<TaskModel>> searchTasks(String query) async {
    try {
      Database db = await connect();
      List nameMatches = await db.query("select * from $_tableName where title=$query");
      List descriptionMatches = await db.query("select * from $_tableName where $query in description"); // CORRECT this query later
      // return the combined list with each element converted to TaskModel
      return [nameMatches, descriptionMatches].expand((element) => element).toList().map((m) => TaskModel.fromMap(m)).toList();
    } catch (err) {
      throw err;      
    }
  }

  @override
  Future<List<TaskModel>> getTasksbyStatus(bool isCompleted) async {
    try {
      Database db = await connect();
      List matches = await db.query("select * from $_tableName where isCompleted=$isCompleted");
      // return the combined list with each element converted to TaskModel
      return matches.map((m) => TaskModel.fromMap(m)).toList();
    } catch (err) {
      throw err;      
    }
  }
  
 
  @override
  Future<int> getTotalTasksCount() async {
    try {
      Database db = await connect();
      final result = await db.query("select count(*) from $_tableName");
      return result[0]; // return the count maybe here (yet to figure out parsing)
    } catch (err) {
      throw err;
    }
  }

  @override
  Future<int> getCompletedTasksCount() async {
    try {
      Database db = await connect();
      final result = db.query("select count(*) from $_tableName where isCompleted=true");
      return result[0];
    } catch (err) {
      throw err;
    }
  }
}