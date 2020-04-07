import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:todonick/models/todo.dart';
import 'package:todonick/providers/todo_providers.dart';
import 'package:todonick/widgets/todo_list_view.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool showNonCompleted = false;
  @override
  Widget build(BuildContext context) {
    final TodoProvider todoProvider = Provider.of<TodoProvider>(context);
    final List<Todo> completedTodoList = todoProvider.completedTodoList;
    final List<Todo> nonCompletedTodoList = todoProvider.nonCompletedTodoList;
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
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
      body: todoProvider.isTodoListEmpty
          ? Center(child: Text("No Todo"))
          : SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Text("My List",
                          style: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold)),
                    ),
                    TodoListView(nonCompletedTodoList),
                    ListTile(
                      onTap: completedTodoList.length < 1
                          ? null
                          : () {
                              setState(() {
                                showNonCompleted = !showNonCompleted;
                              });
                            },
                      title: Text("Completed (${completedTodoList.length})"),
                      trailing: Icon(
                          showNonCompleted && completedTodoList.length > 0
                              ? Icons.expand_less
                              : Icons.expand_more),
                    ),
                    if (showNonCompleted) TodoListView(completedTodoList)
                  ],
                ),
              ),
            ),
    );
  }
}
