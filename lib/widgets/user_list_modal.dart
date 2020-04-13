import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:todonick/helpers/list_map.dart';
import 'package:todonick/models/todo_list.dart';
import 'package:todonick/models/user.dart';
import 'package:todonick/providers/todo_list_provider.dart';
import 'package:todonick/providers/todo_user_provider.dart';
import 'package:todonick/providers/view_state_provider.dart';
import 'package:todonick/screens/todo_list_edit_screen.dart';
import 'package:todonick/screens/user_edit_screen.dart';
import "../helpers/string-extensions.dart";

class UserListModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TodoUserProvider todoUserProvider =
        Provider.of<TodoUserProvider>(context);
    final TodoListProvider todoListProvider =
        Provider.of<TodoListProvider>(context);
    final User user = todoUserProvider.user;
    final List<TodoList> todoLists = todoListProvider.todoLists;
    final double listTileSize = 58;
    return SingleChildScrollView(
      child: Container(
          height: 180 + (todoLists.length * listTileSize),
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
                      leading: user.profileUrl == null ||
                              user.profileUrl.isEmpty
                          ? CircleAvatar(
                              child:
                                  Text(user.name.substring(0, 1).toUpperCase()))
                          : CircleAvatar(
                              backgroundImage: NetworkImage(user.profileUrl),
                            ),
                      title: Text(user.name.capitalize()),
                      subtitle: Text(user.email),
                      trailing: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  fullscreenDialog: true,
                                  builder: (_) => UserEditScreen()));
                        },
                      ),
                    ),
                    Divider(),
                    ...listMap<TodoList, Widget>(todoLists,
                        (int index, TodoList todoList) {
                      return SizedBox(
                        height: listTileSize,
                        child: ListTile(
                          selected: todoListProvider.selectedIndex == index,
                          onTap: () {
                            todoListProvider.changeSelectedIndex(index);
                            Navigator.pop(context);
                          },
                          title: Text(todoList.name.capitalize()),
                        ),
                      );
                    }),
                    ListTile(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.of(context).push(MaterialPageRoute(
                              fullscreenDialog: true,
                              builder: (ctx) => TodoListEditScreen()));
                        },
                        leading: Icon(Icons.add),
                        title: Text("Create New List"))
                  ],
                )),
    );
  }
}
