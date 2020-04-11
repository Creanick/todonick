import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:todonick/models/user.dart';
import 'package:todonick/providers/todo_user_provider.dart';
import 'package:todonick/providers/view_state_provider.dart';

class UserEditScreen extends StatelessWidget {
  static const String routeName = "/user-edit-screen";
  @override
  Widget build(BuildContext context) {
    final TodoUserProvider todoUserProvider =
        Provider.of<TodoUserProvider>(context, listen: true);
    final User user = todoUserProvider.user;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        textTheme: Theme.of(context)
            .textTheme
            .copyWith(title: TextStyle(color: Colors.black, fontSize: 16)),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text("Edit Profile"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {},
          )
        ],
      ),
      body: todoUserProvider.state == ViewState.loading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: <Widget>[
                Divider(
                  height: 1,
                ),
                Container(
                  color: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: TextFormField(
                    initialValue: user.name,
                    autofocus: true,
                    decoration: InputDecoration(
                        hintText: "Your Name", border: InputBorder.none),
                  ),
                )
              ],
            ),
    );
  }
}
