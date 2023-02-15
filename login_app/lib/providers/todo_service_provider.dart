import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:login_app/models/todo.model.dart';
import 'package:login_app/providers/db_provider.dart';

class TodoServicePorvider extends ChangeNotifier {
  List<TodoModel> todos = [];

  TodoServicePorvider() {
    getTodos();
  }

  Future<List<TodoModel>> getTodos() async {
    todos = await DBProvider.db.getTodos();
    notifyListeners();
    return todos;
  }

  addNewTodo() async {
    await DBProvider.db
        .addNewTodoRaw(TodoModel(title: 'test', task: 'new task', done: 1));
  }
}
