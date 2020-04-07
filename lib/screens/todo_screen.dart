import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:todonick/models/todo.dart';
import 'package:todonick/providers/todo_providers.dart';

class TodoScreen extends StatelessWidget {
  final int index;
  final Todo todo;
  const TodoScreen(this.index, this.todo);
  @override
  Widget build(BuildContext context) {
    final TodoProvider todoProvider =
        Provider.of<TodoProvider>(context, listen: true);
    return Scaffold(
        floatingActionButton: todo.completed
            ? FloatingActionButton(
                child: Icon(Icons.replay),
                onPressed: () {
                  todoProvider.deCompleteTodo(index);
                },
              )
            : Container(
                height: 50,
                child: RaisedButton.icon(
                  color: Colors.white,
                  elevation: 8,
                  textColor: Colors.blueAccent,
                  shape: StadiumBorder(),
                  icon: Icon(Icons.check),
                  label: Text("Mark as completed"),
                  onPressed: () {
                    todoProvider.completeTodo(index);
                    Navigator.pop(context);
                  },
                ),
              ),
        appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.black),
            backgroundColor: Colors.white,
            elevation: 0,
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                onPressed: () {
                  todoProvider.deleteTodo(index,
                      isCompletedList: todo.completed);
                  Navigator.pop(context);
                },
              ),
            ]),
        backgroundColor: Colors.white,
        body: Opacity(
          opacity: todo.completed ? 0.5 : 1,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(todo.name,
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        decoration: todo.completed
                            ? TextDecoration.lineThrough
                            : TextDecoration.none)),
                SizedBox(
                  height: 20,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Icon(Icons.clear_all),
                    SizedBox(
                      width: 20,
                    ),
                    Flexible(child: Text("Add Details"))
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
                    Text("Add subtasks")
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ));
  }
}
