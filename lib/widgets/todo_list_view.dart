import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:todonick/models/todo.dart';
import 'package:todonick/providers/todo_provider.dart';
import 'package:todonick/providers/view_state_provider.dart';
import 'package:todonick/widgets/todo_tile.dart';

class TodoListView extends StatefulWidget {
  @override
  _TodoListViewState createState() => _TodoListViewState();
}

class _TodoListViewState extends State<TodoListView> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    final TodoProvider todoProvider = Provider.of<TodoProvider>(context);
    final List<Todo> todos = todoProvider?.todos;
    final List<TodoTile> nonCompletedTodoTile = [];
    final List<TodoTile> completedTodoTile = [];
    if (todoProvider != null) {
      for (int i = 0; i < todos.length; i++) {
        final todo = todos[i];
        if (todo.completed) {
          completedTodoTile.add(TodoTile(todo, i));
        } else {
          nonCompletedTodoTile.add(TodoTile(todo, i));
        }
      }
    }
    return todoProvider == null ||
            todoProvider.state == ViewState.initialLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : todos == null || todos.isEmpty
            ? Center(child: Text("No Todos"))
            : ListView.builder(
                itemBuilder: (ctx, index) {
                  final int nonLength = nonCompletedTodoTile.length;
                  if (index < nonLength) {
                    return nonCompletedTodoTile[index];
                  }
                  if (index == nonLength) {
                    return ListTile(
                        onTap: () {
                          setState(() {
                            isExpanded = !isExpanded;
                          });
                        },
                        trailing: Icon(
                            isExpanded ? Icons.expand_less : Icons.expand_more),
                        title: Text("Completed (${completedTodoTile.length})"));
                  }
                  final completedIndex = index - nonLength - 1;
                  return completedTodoTile[completedIndex];
                },
                itemCount: nonCompletedTodoTile.length +
                    (completedTodoTile.isEmpty
                        ? 0
                        : ((isExpanded ? completedTodoTile.length : 0) + 1)));
  }
}
