import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:todonick/models/todo.dart';
import 'package:todonick/providers/todo_provider.dart';
import 'package:todonick/providers/view_state_provider.dart';
import 'package:todonick/widgets/todo_tile.dart';

class TodoListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TodoProvider todoProvider = Provider.of<TodoProvider>(context);
    final List<Todo> todos = todoProvider.todos;
    return todoProvider.state == ViewState.loading
        ? Center(
            child: Text("Todos loading..."),
          )
        : todos.isEmpty
            ? Center(child: Text("No Todos"))
            : ListView.builder(
                itemBuilder: (ctx, index) => TodoTile(todos[index], index),
                itemCount: todos.length);
  }
}
