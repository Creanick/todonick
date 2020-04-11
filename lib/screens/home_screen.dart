import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:todonick/providers/auth_user_provider.dart';
import 'package:todonick/providers/view_state_provider.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = "/home-screen";
  @override
  Widget build(BuildContext context) {
    final AuthUserProvider authUserProvider =
        Provider.of<AuthUserProvider>(context);
    return Scaffold(
        appBar: AppBar(title: Text("Home Screen")),
        body: Column(
          children: [
            if (authUserProvider.state == ViewState.loading)
              LinearProgressIndicator(),
            RaisedButton(
              child: Text("Sign out"),
              onPressed: authUserProvider.signOutUser,
            )
          ],
        ));
  }
}
