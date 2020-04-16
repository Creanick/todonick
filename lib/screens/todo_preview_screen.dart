import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:todonick/models/todo.dart';
import 'package:todonick/providers/todo_provider.dart';
import "../helpers/string-extensions.dart";

class TodoPreviewScreen extends StatelessWidget {
  final int todoIndex;
  TodoPreviewScreen(this.todoIndex);
  static const String routeName = "/todo-preview-screen";
  @override
  Widget build(BuildContext context) {
    final TodoProvider todoProvider = Provider.of<TodoProvider>(context);
    final Todo todo = todoProvider.getTodo(todoIndex);
    return Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: todo.completed
            ? FloatingActionButton(
                onPressed: () {
                  todoProvider.toggleComplete(todoIndex);
                },
                child: Icon(Icons.refresh),
              )
            : FloatingActionButton.extended(
                backgroundColor: Colors.white,
                foregroundColor: Colors.blue,
                icon: Icon(Icons.check),
                onPressed: () {
                  todoProvider.toggleComplete(todoIndex);
                  Navigator.pop(context);
                },
                label: Text("Mark as complete")),
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text(""),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {},
            )
          ],
        ),
        body: SingleChildScrollView(
            child: Opacity(
          opacity: todo.completed ? 0.5 : 1,
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(todo.name.capitalize(),
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        decoration: todo.completed
                            ? TextDecoration.lineThrough
                            : TextDecoration.none)),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: <Widget>[
                    Icon(Icons.subject),
                    SizedBox(
                      width: 20,
                    ),
                    Text("Add details")
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: <Widget>[
                    Icon(Icons.event_available),
                    SizedBox(
                      width: 20,
                    ),
                    Text("Add date/time")
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: <Widget>[
                    Icon(Icons.subdirectory_arrow_right),
                    SizedBox(
                      width: 20,
                    ),
                    Text("Add Subtasks")
                  ],
                ),
              ],
            ),
          ),
        )));
  }
}
