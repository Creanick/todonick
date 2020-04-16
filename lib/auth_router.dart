import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:todonick/auth_app.dart';
import 'package:todonick/home_app.dart';
import 'package:todonick/providers/auth_user_provider.dart';

class AuthRouter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthUserProvider _authUserProvider =
        Provider.of<AuthUserProvider>(context);
    return (_authUserProvider.isAuthenticated ? HomeApp() : AuthApp());
  }
}
