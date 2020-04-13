import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:todonick/providers/todo_list_provider.dart';
import 'package:todonick/providers/todo_user_provider.dart';
import 'package:todonick/providers/view_state_provider.dart';

class TodoListEditScreen extends StatefulWidget {
  static const String routeName = "/todo-list-edit-screen";

  @override
  _TodoListEditScreenState createState() => _TodoListEditScreenState();
}

class _TodoListEditScreenState extends State<TodoListEditScreen> {
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
    final TodoListProvider todoListProvider =
        Provider.of<TodoListProvider>(context);
    final TodoUserProvider todoUserProvider =
        Provider.of<TodoUserProvider>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          title: Text("List Edit"),
          centerTitle: true,
          elevation: 0,
          actions: <Widget>[
            Builder(builder: (ctx) {
              return IconButton(
                icon: Icon(Icons.check),
                onPressed: todoListProvider.state == ViewState.loading
                    ? null
                    : () async {
                        final name = _nameController.text;
                        if (name == null || name.isEmpty) return;
                        final response = await todoListProvider.createTodoList(
                            todoUserProvider.user.id, name);
                        Navigator.pop(context);
                        Scaffold.of(ctx).showSnackBar(SnackBar(
                          content: Text(response.message),
                        ));
                      },
              );
            })
          ],
          backgroundColor: Colors.white,
          textTheme: Theme.of(context)
              .textTheme
              .copyWith(title: TextStyle(color: Colors.black, fontSize: 20)),
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: Column(
          children: <Widget>[
            if (todoListProvider.state == ViewState.loading)
              SizedBox(
                height: 3,
                child: LinearProgressIndicator(),
              ),
            Container(
                color: Colors.white,
                padding: const EdgeInsets.only(left: 20),
                child: TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                      hintText: "New List Name", border: InputBorder.none),
                ))
          ],
        ));
  }
}
