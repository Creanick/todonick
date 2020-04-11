import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:todonick/providers/auth_user_provider.dart';
import 'package:todonick/providers/view_state_provider.dart';
import 'package:todonick/screens/auth_screen.dart';
import 'package:todonick/screens/home_screen.dart';
import 'package:todonick/screens/splash_screen.dart';

class AuthRouter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthUserProvider authUserProvider =
        Provider.of<AuthUserProvider>(context);
    return authUserProvider.state == ViewState.initial
        ? SplashScreen()
        : (authUserProvider.isAuthenticated ? HomeScreen() : AuthScreen());
  }
}
