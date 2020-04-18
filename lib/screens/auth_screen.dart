import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:todonick/providers/auth_user_provider.dart';
import 'package:todonick/providers/view_state_provider.dart';
import 'package:todonick/screens/splash_screen.dart';

const inputStyle = InputDecoration(
  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
  border: OutlineInputBorder(
    borderSide: BorderSide(width: 0, style: BorderStyle.none),
    borderRadius: const BorderRadius.all(
      const Radius.circular(10.0),
    ),
  ),
  filled: true,
);

class AuthScreen extends StatefulWidget {
  static const String routeName = "/auth-screen";

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLoginView = false;
  @override
  Widget build(BuildContext context) {
    final email = "manickwar@gmail.com";
    final password = "mancik343";
    final name = "manicklal";
    final AuthUserProvider authUserProvider =
        Provider.of<AuthUserProvider>(context);
    return authUserProvider.state == ViewState.initialLoading
        ? SplashScreen()
        : Scaffold(
            appBar: AppBar(
              title: Text(isLoginView ? "Login" : "Sign Up"),
              centerTitle: true,
            ),
            body: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    if (!isLoginView)
                      Column(
                        children: <Widget>[
                          SizedBox(
                            width: double.infinity,
                            child: CupertinoButton(
                              child: Text("Sign In with google"),
                              color: Colors.redAccent,
                              onPressed: () {},
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text("Or create account with"),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                              decoration: inputStyle.copyWith(
                                  hintText: "Enter Your Name")),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    TextFormField(
                        decoration:
                            inputStyle.copyWith(hintText: "Enter Your Email")),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                        decoration: inputStyle.copyWith(
                            hintText: "Enter Your Password")),
                    SizedBox(
                      height: 20,
                    ),
                    if (!isLoginView)
                      TextFormField(
                          decoration: inputStyle.copyWith(
                              hintText: "Confirm Your Password")),
                    if (!isLoginView)
                      SizedBox(
                        height: 20,
                      ),
                    SizedBox(
                      width: double.infinity,
                      child: CupertinoButton(
                        child: Text(isLoginView ? "Log In " : "Create Account"),
                        color: Colors.green,
                        onPressed: () {},
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    FlatButton(
                      child: Text(isLoginView
                          ? "Don't have any account? Register"
                          : "Have an account already? Log In"),
                      onPressed: () {
                        setState(() {
                          isLoginView = !isLoginView;
                        });
                      },
                      textColor: Colors.blue,
                    )
                  ],
                ),
              ),
            ));
  }
}
