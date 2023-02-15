import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_app/providers/todo_service_provider.dart';
import 'package:login_app/screens/note_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final todoServiceProvider = Provider.of<TodoServicePorvider>(context);

    // final todos = todoServiceProvider.todos;
    // print(jsonEncode(todos));
    // todoServiceProvider.addNewTodo();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        backgroundColor: const Color.fromRGBO(110, 1, 239, 1),
        elevation: 0,
        toolbarHeight: 75.0,
        actions: [
          IconButton(
              onPressed: () => FirebaseAuth.instance.signOut(),
              icon: const Icon(Icons.exit_to_app_rounded))
        ],
      ),
      body: FutureBuilder(
        future: todoServiceProvider.getTodos(),
        builder: ((context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              widthFactor: 10,
              heightFactor: 5,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Color.fromRGBO(110, 1, 239, 1)),
              ),
            );
          } else {
            final todos = snapshot.data!.toList();
            return ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: todos.length,
              itemBuilder: ((_, index) {
                final done = todos[index].done;
                // return CheckboxListTile(
                //   value: done == 0 ? false : true,
                //   title: Text(todos[index].title),
                //   onChanged: ((value) {
                //     value = value;
                //   }),
                // );
                return ListTile(
                  title: Text(todos[index].title),
                  leading: Checkbox(
                    checkColor: Colors.white,
                    activeColor: const Color.fromRGBO(110, 1, 239, 1),
                    value: done == 0 ? false : true,
                    onChanged: ((value) {}),
                  ),
                );
              }),
            );
          }
        }),
      ),
      // body: Center(
      //   child: TextButton(
      //     onPressed: () => FirebaseAuth.instance.signOut(),
      //     child: const Text('SignOut'),
      //   ),
      // ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            PageTransition(
              duration: const Duration(milliseconds: 370),
              reverseDuration: const Duration(milliseconds: 370),
              type: PageTransitionType.bottomToTop,
              child: const NoteScreen(),
            ),
          );

          // Navigator.pushNamed(context, 'note');
        },
        backgroundColor: const Color.fromRGBO(110, 1, 239, 1),
        child: const Icon(Icons.add),
      ),
    );
  }
}
