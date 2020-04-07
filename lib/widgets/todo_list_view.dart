import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:todonick/models/todo.dart';
import 'package:todonick/providers/todo_providers.dart';
import 'package:todonick/screens/todo_screen.dart';

class TodoItem extends StatelessWidget {
  final int index;
  final Todo todo;
  const TodoItem(this.index, this.todo);
  @override
  Widget build(BuildContext context) {
    final TodoProvider todoProvider =
        Provider.of<TodoProvider>(context, listen: true);
    return ListTile(
        key: ValueKey(todo.id),
        onTap: () {
          Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (_) {
                    return TodoScreen(index, todo);
                  },
                  fullscreenDialog: true));
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
              print("todo index $index");
              todoProvider.deCompleteTodo(index);
            } else {
              todoProvider.completeTodo(index);
            }
          },
        ));
  }
}

class TodoListView extends StatefulWidget {
  @override
  _TodoListViewState createState() => _TodoListViewState();
}

class _TodoListViewState extends State<TodoListView> {
  bool showCompletedList = false;
  @override
  Widget build(BuildContext context) {
    final TodoProvider todoProvider = Provider.of<TodoProvider>(context);
    final List<Todo> completedTodoList = todoProvider.completedTodoList;
    final List<Todo> nonCompletedTodoList = todoProvider.nonCompletedTodoList;
    return todoProvider.isTodoListEmpty
        ? Center(child: Text("Empty Todo"))
        : ListView.builder(
            itemBuilder: (ctx, index) {
              final int nonLength = nonCompletedTodoList.length;
              if (index < nonLength) {
                return TodoItem(index, nonCompletedTodoList[index]);
              }
              if (index == nonLength) {
                return ListTile(
                  onTap: () {
                    setState(() {
                      showCompletedList = !showCompletedList;
                    });
                  },
                  title: Text("Completed (${completedTodoList.length})"),
                  trailing: Icon(showCompletedList
                      ? Icons.expand_less
                      : Icons.expand_more),
                );
              }
              final completedIndex = index - nonLength - 1;
              return TodoItem(
                  completedIndex, completedTodoList[completedIndex]);
            },
            itemCount: nonCompletedTodoList.length +
                (completedTodoList.isEmpty
                    ? 0
                    : showCompletedList ? completedTodoList.length + 1 : 1));
  }
}
