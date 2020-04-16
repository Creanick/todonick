import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:todonick/models/todo.dart';
import 'package:todonick/providers/todo_provider.dart';
import 'package:todonick/screens/todo_preview_screen.dart';

class TodoTile extends StatelessWidget {
  final Todo todo;
  final int index;
  TodoTile(this.todo, this.index);
  @override
  Widget build(BuildContext context) {
    final TodoProvider todoProvider = Provider.of<TodoProvider>(context);
    return ListTile(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (ctx) => ChangeNotifierProvider.value(
                      value: todoProvider, child: TodoPreviewScreen(index))));
        },
        leading: IconButton(
          icon: Icon(
            todo.completed ? Icons.check : Icons.radio_button_unchecked,
            color: todo.completed ? Colors.blue : Colors.grey,
          ),
          onPressed: () async {
            final response = await todoProvider.toggleComplete(index);
            if (response.error) {
              print(response.message);
            }
          },
        ),
        title: Text(todo.name,
            style: TextStyle(
                decoration: todo.completed
                    ? TextDecoration.lineThrough
                    : TextDecoration.none)));
  }
}
