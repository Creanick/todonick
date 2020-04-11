import "package:flutter/material.dart";
import 'package:todonick/widgets/user_list_modal.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = "/home-screen";

  void showListBottomSheet(BuildContext ctx) {
    showModalBottomSheet(context: ctx, builder: (_) => UserListModal());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.menu),
              onPressed: () => showListBottomSheet(context),
            ),
            IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
