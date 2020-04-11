import "package:flutter/material.dart";

class SplashScreen extends StatelessWidget {
  static const String routeName = "/splash_screen";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Splash Screen"),
          elevation: 0,
        ),
        backgroundColor: Colors.blue,
        body: Center(
          child: Text("Splash Screen",
              style: TextStyle(fontSize: 30, color: Colors.white)),
        ));
  }
}
