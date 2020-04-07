import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:todonick/models/todo.dart';
import 'package:todonick/providers/todo_providers.dart';
import 'package:todonick/widgets/todo_creator.dart';
import 'package:todonick/widgets/todo_list_view.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool showNonCompleted = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  void showTodoCreatorSheet(BuildContext c) {
    showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        context: c,
        builder: (ctx) {
          return TodoCreator();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Container(
            margin: EdgeInsets.only(left: 14),
            child: Text("My Todo List Name",
                style: TextStyle(fontSize: 26, color: Colors.blueAccent))),
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => showTodoCreatorSheet(context),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () {},
            ),
          ],
        ),
      ),
      body: SafeArea(child: TodoListView()),
    );
  }
}
