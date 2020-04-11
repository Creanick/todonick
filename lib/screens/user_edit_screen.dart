import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:todonick/models/user.dart';
import 'package:todonick/providers/todo_user_provider.dart';
import 'package:todonick/providers/view_state_provider.dart';

class UserEditScreen extends StatefulWidget {
  static const String routeName = "/user-edit-screen";

  @override
  _UserEditScreenState createState() => _UserEditScreenState();
}

class _UserEditScreenState extends State<UserEditScreen> {
  TextEditingController _nameController;

  @override
  void initState() {
    _nameController = TextEditingController();
    _nameController.text =
        Provider.of<TodoUserProvider>(context, listen: false).user?.name ?? "";
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TodoUserProvider todoUserProvider =
        Provider.of<TodoUserProvider>(context, listen: true);
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
          Builder(builder: (ctx) {
            return IconButton(
              icon: Icon(Icons.check),
              onPressed: () async {
                final newName = _nameController.text;
                if (newName.isEmpty) return;
                final response =
                    await todoUserProvider.updateUser(name: newName);
                if (response.error) {
                  Scaffold.of(ctx).showSnackBar(SnackBar(
                    content: Text(response.message),
                  ));
                } else {
                  Navigator.pop(context);
                }
              },
            );
          })
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
                    controller: _nameController,
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
