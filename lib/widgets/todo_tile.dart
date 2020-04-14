import "package:flutter/material.dart";
import 'package:todonick/models/todo.dart';

class TodoTile extends StatelessWidget {
  final Todo todo;
  TodoTile(this.todo);
  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Icon(
          todo.completed ? Icons.check : Icons.radio_button_unchecked,
          color: todo.completed ? Colors.blue : Colors.grey,
        ),
        title: Text(todo.name));
  }
}
