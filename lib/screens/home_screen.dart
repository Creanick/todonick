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

  void popMenuHandler(String menuName, int listIndex, String selectedListId) {
    switch (menuName) {
      case ListPopMenuNames.deleteList:
        deleteSelectedList(listIndex, selectedListId);
        break;
      default:
    }
  }

  void deleteSelectedList(int listIndex, String listId) {
    print("list index id: $listIndex deleting, listId: $listId");
  }

  @override
  Widget build(BuildContext context) {
    final TodoListProvider todoListProvider =
        Provider.of<TodoListProvider>(context);
    final List<TodoList> todoLists = todoListProvider.todoLists;
    final TodoList selectedTodoList =
        todoLists.isEmpty ? null : todoLists[todoListProvider.selectedIndex];
    return Scaffold(
        appBar: AppBar(
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
                onSelected: (String menuName) => popMenuHandler(menuName,
                    todoListProvider.selectedIndex, selectedTodoList.id),
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
        body: todoListProvider.state == ViewState.loading
            ? Center(child: CircularProgressIndicator())
            : Center(
                child: Text("No Todos available"),
              ));
  }
}
