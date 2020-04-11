import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:todonick/models/user.dart';
import 'package:todonick/providers/todo_user_provider.dart';
import 'package:todonick/providers/view_state_provider.dart';
import "../helpers/string-extensions.dart";

class UserListModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TodoUserProvider todoUserProvider =
        Provider.of<TodoUserProvider>(context);
    final User user = todoUserProvider.user;
    return Container(
        height: 200,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: todoUserProvider.state == ViewState.loading
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: <Widget>[
                  Container(
                    width: 50,
                    height: 6,
                    decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  ListTile(
                    leading: CircleAvatar(
                        child: Text(user.name.substring(0, 1).toUpperCase())),
                    title: Text(user.name.capitalize()),
                    subtitle: Text(user.email),
                    trailing: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {},
                    ),
                  ),
                  Divider(),
                  ListTile(
                      leading: Icon(Icons.add), title: Text("Create New List"))
                ],
              ));
  }
}
