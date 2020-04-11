import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:todonick/auth_router.dart';
import 'package:todonick/providers/auth_user_provider.dart';
import 'package:todonick/service_locator.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => AuthUserProvider(),
        child: MaterialApp(
          home: AuthRouter(),
        ));
  }
}
