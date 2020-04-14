import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:todonick/providers/todo_provider.dart';
import 'package:todonick/providers/view_state_provider.dart';

class TodoCreateModal extends StatefulWidget {
  @override
  _TodoCreateModalState createState() => _TodoCreateModalState();
}

class _TodoCreateModalState extends State<TodoCreateModal> {
  TextEditingController _nameController;
  @override
  void initState() {
    _nameController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final TodoProvider todoProvider = Provider.of<TodoProvider>(context);
    print(todoProvider.state);
    return Container(
        height: 140 + keyboardHeight,
        padding:
            const EdgeInsets.only(top: 10, left: 20, bottom: 20, right: 20),
        child: Column(
          children: <Widget>[
            TextField(
              autofocus: true,
              controller: _nameController,
              decoration: InputDecoration(
                  hintText: "New Todo", border: InputBorder.none),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Icon(Icons.event_available),
                FlatButton(
                  child: Text("Save", style: TextStyle(color: Colors.blue)),
                  onPressed: todoProvider.state == ViewState.loading
                      ? null
                      : () async {
                          final name = _nameController.text;
                          if (name == null || name.isEmpty) return;
                          final response =
                              await todoProvider.createTodo(name: name);
                          Navigator.pop(context, !response.error);
                        },
                )
              ],
            ),
            if (todoProvider.state == ViewState.loading)
              SizedBox(height: 4, child: LinearProgressIndicator())
          ],
        ));
  }
}
