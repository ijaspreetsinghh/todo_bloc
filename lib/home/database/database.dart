import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:todo_bloc/home/bloc/tasks/task_state.dart';
import 'package:todo_bloc/home/bloc/users/user_state.dart';

class DatabaseHelper {
  static Database? _database;

  // Singleton pattern: create a single instance of DatabaseHelper
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  DatabaseHelper._privateConstructor();

  // Get or create a database instance
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await _initDatabase();
      return _database!;
    }
  }

  // Initialize the database
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'my_database.db');
    return await openDatabase(path, version: 1, onCreate: _createTables);
  }

  // Create tables
  Future<void> _createTables(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL
      )
    ''');
    await db.execute('''
  CREATE TABLE tasks (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT,
    description TEXT,
    user_id INTEGER,
    FOREIGN KEY (user_id) REFERENCES users(id)
  );
  ''');
  }

  // Insert a user into the database
  Future<int> insertUser({required Map<String, dynamic> data}) async {
    Database db = await instance.database;
    return await db.insert('users', data);
  }

  // Insert a task into the database
  Future<int> insertTask({required Map<String, dynamic> data}) async {
    Database db = await instance.database;
    return await db.insert('tasks', data);
  }

  Future<List<User>> getUsers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('users');

    return List.generate(maps.length, (i) {
      return User(
        id: maps[i]['id'],
        name: maps[i]['name'],
        email: maps[i]['email'],
      );
    });
  } // Get all tasks with their assigned users

  Future<List<Task>> getTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT tasks.id AS task_id, tasks.title, tasks.description, tasks.user_id, users.id AS user_id, users.name, users.email
      FROM tasks
      JOIN users ON tasks.user_id = users.id
    ''');

    List<Task> tasks = [];
    for (var map in maps) {
      User user = User(
        id: map['user_id'],
        name: map['name'],
        email: map['email'],
      );
      Task task = Task(
        id: map['task_id'],
        title: map['title'],
        description: map['description'],
        assignedUser: user,
      );
      tasks.add(task);
    }

    return tasks;
  }
}
