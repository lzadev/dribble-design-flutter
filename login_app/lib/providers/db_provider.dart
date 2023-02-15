import 'dart:io';

import 'package:login_app/models/todo.model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DBProvider {
  static Database? _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDB();
    return _database!;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    // documentsDirectory.delete();
    final path = join(documentsDirectory.path, 'TodosApp.db');

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE Todos ('
          ' id INTEGER PRIMARY KEY,'
          ' title TEXT,'
          ' task TEXT,'
          ' done INTEGER NOT NULL'
          ')');
    });
  }

  // CREAR Registros
  addNewTodoRaw(TodoModel newTodo) async {
    final db = await database;

    final res = await db.rawInsert("INSERT Into Todos ( title, task, done) "
        "VALUES ( '${newTodo.title}', '${newTodo.task}', ${newTodo.done} )");
    return res;
  }

  addNewTodo(TodoModel newTodo) async {
    final db = await database;
    final res = await db.insert('Todos', newTodo.toJson());
    return res;
  }

  Future<TodoModel?> getTodosId(int id) async {
    final db = await database;
    final res = await db.query('Todos', where: 'id = ?', whereArgs: [id]);
    return res.isNotEmpty ? TodoModel.fromJson(res.first) : null;
  }

  Future<List<TodoModel>> getTodos() async {
    final db = await database;
    final res = await db.query('Todos');

    List<TodoModel> list =
        res.isNotEmpty ? res.map((c) => TodoModel.fromJson(c)).toList() : [];
    return list;
  }

  // Actualizar Registros
  Future<int> updateTodo(TodoModel newTodo) async {
    final db = await database;
    final res = await db.update('todos', newTodo.toJson(),
        where: 'id = ?', whereArgs: [newTodo.id]);
    return res;
  }

  // Eliminar registros
  Future<int> deleteTodo(int id) async {
    final db = await database;
    final res = await db.delete('Todos', where: 'id = ?', whereArgs: [id]);
    return res;
  }

  Future<int> deleteAll() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM Todos');
    return res;
  }
}
