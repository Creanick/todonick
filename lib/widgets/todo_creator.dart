import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:todonick/providers/todo_providers.dart';

class TodoCreator extends StatefulWidget {
  @override
  _TodoCreatorState createState() => _TodoCreatorState();
}

class _TodoCreatorState extends State<TodoCreator> {
  TextEditingController _todoNameController;

  @override
  void initState() {
    _todoNameController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _todoNameController.dispose();
    super.dispose();
  }

  void saveTodo(TodoProvider todoProvider) {
    final String todoName = _todoNameController.text;
    if (todoName == null || todoName.length < 1) {
      Navigator.pop(context);
      return;
    }
    todoProvider.addTodo(name: todoName);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final TodoProvider todoProvider = Provider.of<TodoProvider>(context);
    return Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _todoNameController,
              decoration: InputDecoration(
                  hintText: "New Task",
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent))),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(Icons.event_available),
                    Icon(Icons.directions_subway),
                  ],
                ),
                FlatButton(
                  child:
                      Text("Save", style: TextStyle(color: Colors.blueAccent)),
                  onPressed: () => saveTodo(todoProvider),
                )
              ],
            )
          ],
        ));
  }
}