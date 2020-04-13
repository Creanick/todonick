import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:todonick/auth_router.dart';
import 'package:todonick/providers/auth_user_provider.dart';
import 'package:todonick/providers/todo_list_provider.dart';
import 'package:todonick/providers/todo_user_provider.dart';
import 'package:todonick/screens/todo_list_edit_screen.dart';
import 'package:todonick/screens/user_edit_screen.dart';
import 'package:todonick/service_locator.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthUserProvider>(
            create: (_) => AuthUserProvider(),
          ),
          ChangeNotifierProxyProvider<AuthUserProvider, TodoUserProvider>(
            lazy: false,
            create: (_) => TodoUserProvider(),
            update: (_, authUserProvider, todoUserProvider) =>
                todoUserProvider..fetchUser(authUserProvider?.authUser?.uid),
          ),
          ChangeNotifierProxyProvider<AuthUserProvider, TodoListProvider>(
              lazy: false,
              create: (_) => TodoListProvider(),
              update: (_, authUserProvider, todoListProvider) =>
                  todoListProvider
                    ..fetchTodoLists(authUserProvider?.authUser?.uid)),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: AuthRouter(),
          routes: {
            UserEditScreen.routeName: (_) => UserEditScreen(),
            TodoListEditScreen.routeName: (_) => TodoListEditScreen(),
          },
        ));
  }
}
