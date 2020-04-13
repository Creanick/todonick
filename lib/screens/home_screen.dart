import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:todonick/models/todo_list.dart';
import 'package:todonick/providers/todo_list_provider.dart';
import 'package:todonick/providers/view_state_provider.dart';
import 'package:todonick/widgets/user_list_modal.dart';
import "../helpers/string-extensions.dart";

class ListPopMenuNames {
  static const String deleteList = "Delete List";
  static const String renameList = "Rename List";
  static const String signOut = "Sign Out";
  static const List<String> nameLists = <String>[
    deleteList,
    renameList,
    signOut
  ];
}

class HomeScreen extends StatelessWidget {
  static const String routeName = "/home-screen";

  void showListBottomSheet(BuildContext ctx) {
    showModalBottomSheet(context: ctx, builder: (_) => UserListModal());
  }

  void popMenuHandler(BuildContext context, String menuName) {
    switch (menuName) {
      case ListPopMenuNames.deleteList:
        deleteSelectedList(context);
        break;
      default:
    }
  }

  void deleteSelectedList(BuildContext context) {
    final TodoListProvider todoListProvider =
        Provider.of<TodoListProvider>(context, listen: false);
    final List<TodoList> todoLists = todoListProvider.todoLists;
    final TodoList selectedTodoList =
        todoLists.isEmpty ? null : todoLists[todoListProvider.selectedIndex];
    if (selectedTodoList == null) return;
    final listIndex = todoListProvider.selectedIndex;
    final listId = selectedTodoList.id;
    todoListProvider.deleteTodoList(index: listIndex, listId: listId);
  }

  @override
  Widget build(BuildContext context) {
    final TodoListProvider todoListProvider =
        Provider.of<TodoListProvider>(context);
    final List<TodoList> todoLists = todoListProvider.todoLists;
    final TodoList selectedTodoList = todoLists.isEmpty
        ? null
        : todoLists[todoListProvider.selectedIndex < todoLists.length
            ? todoListProvider.selectedIndex
            : 0];
    return Scaffold(
        appBar: todoLists.isEmpty
            ? null
            : AppBar(
                centerTitle: true,
                title: Text(selectedTodoList?.name?.capitalize() ?? ""),
                elevation: 0,
                // backgroundColor: Colors.white,
                // textTheme: Theme.of(context)
                //     .textTheme
                //     .copyWith(title: TextStyle(color: Colors.black, fontSize: 20)),
              ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.menu),
                onPressed: () => showListBottomSheet(context),
              ),
              PopupMenuButton<String>(
                enabled: todoLists.isNotEmpty,
                onSelected: (String menuName) =>
                    popMenuHandler(context, menuName),
                itemBuilder: (ctx) {
                  return ListPopMenuNames.nameLists.map((name) {
                    return PopupMenuItem<String>(
                        child: Text(name, style: TextStyle(fontSize: 14)),
                        value: name);
                  }).toList();
                },
              )
            ],
          ),
        ),
        body: todoLists.isEmpty
            ? Center(
                child: Text("No List available"),
              )
            : todoListProvider.state == ViewState.loading
                ? Center(child: CircularProgressIndicator())
                : Center(
                    child: Text("No Todos available"),
                  ));
  }
}
