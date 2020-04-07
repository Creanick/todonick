import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:todonick/models/todo.dart';
import 'package:todonick/providers/todo_providers.dart';
import 'package:todonick/screens/todo_screen.dart';

class TodoListView extends StatelessWidget {
  final List<Todo> list;
  const TodoListView(this.list);

  @override
  Widget build(BuildContext context) {
    final TodoProvider todoProvider =
        Provider.of<TodoProvider>(context, listen: false);
    return ListView.builder(
        shrinkWrap: true,
        itemBuilder: (ctx, index) {
          final Todo todo = list[index];
          return ListTile(
              onTap: () {
                Navigator.push(context, CupertinoPageRoute(builder: (_) {
                  return TodoScreen(index, todo);
                }));
              },
              title: Text(todo.name,
                  style: TextStyle(
                      decorationColor: Colors.black,
                      decorationThickness: 2,
                      decoration: todo.completed
                          ? TextDecoration.lineThrough
                          : TextDecoration.none)),
              leading: Checkbox(
                value: todo.completed,
                onChanged: (bool isChecked) {
                  if (todo.completed) {
                    todoProvider.deCompleteTodo(index);
                  } else {
                    todoProvider.completeTodo(index);
                  }
                },
              ));
        },
        itemCount: list.length);
  }
}
