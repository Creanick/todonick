import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:todonick/providers/auth_user_provider.dart';
import 'package:todonick/providers/view_state_provider.dart';

class AuthScreen extends StatelessWidget {
  static const String routeName = "/auth-screen";
  @override
  Widget build(BuildContext context) {
    final email = "manickwar@gmail.com";
    final password = "mancik343";
    final name = "manick";
    final AuthUserProvider authUserProvider =
        Provider.of<AuthUserProvider>(context);
    return Scaffold(
        appBar: AppBar(title: Text("Auth Screen")),
        body: Column(
          children: <Widget>[
            if (authUserProvider.state == ViewState.loading)
              LinearProgressIndicator(),
            RaisedButton(
                child: Text("register manick"),
                onPressed: () async {
                  await authUserProvider.signUpUser(
                      email: email, password: password, name: name);
                }),
            RaisedButton(
                child: Text("login manick"),
                onPressed: () => authUserProvider.signInUser(
                    email: email, password: password)),
          ],
        ));
  }
}
