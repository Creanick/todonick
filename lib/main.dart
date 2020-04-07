import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:todonick/providers/todo_providers.dart';
import 'package:todonick/screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TodoProvider>(
        create: (_) => TodoProvider(),
        child: MaterialApp(
          theme: ThemeData.light().copyWith(primaryColor: Colors.blueAccent),
          home: HomeScreen(),
          debugShowCheckedModeBanner: false,
        ));
  }
}
