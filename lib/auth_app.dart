import "package:flutter/material.dart";
import 'package:todonick/screens/auth_screen.dart';

class AuthApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: AuthScreen());
  }
}
