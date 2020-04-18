import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:todonick/helpers/view_response.dart';
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
  TextEditingController _nameController;
  TextEditingController _emailController;
  TextEditingController _passwordController;
  TextEditingController _confirmPasswordController;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoginView = false;
  bool isFormValid = false;

  @override
  void initState() {
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  void validate() {
    setState(() {
      isFormValid = _formKey.currentState.validate();
    });
  }

  @override
  Widget build(BuildContext context) {
    // final email = "manickwar@gmail.com";
    // final password = "mancik343";
    // final name = "manicklal";
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
                        ],
                      ),
                    Form(
                      onChanged: validate,
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          if (!isLoginView)
                            TextFormField(
                                validator: (name) => name.isEmpty
                                    ? "Name should not be empty"
                                    : null,
                                controller: _nameController,
                                decoration: inputStyle.copyWith(
                                    hintText: "Enter Your Name")),
                          if (!isLoginView)
                            SizedBox(
                              height: 20,
                            ),
                          TextFormField(
                              validator: (email) {
                                var emailRegxp = RegExp(
                                    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
                                bool isEmailValid = emailRegxp.hasMatch(email);
                                return isEmailValid ? null : "Email is invalid";
                              },
                              controller: _emailController,
                              decoration: inputStyle.copyWith(
                                  hintText: "Enter Your Email")),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                              obscureText: true,
                              validator: (password) => password.length < 6
                                  ? "Password atleast 6 char long"
                                  : null,
                              controller: _passwordController,
                              decoration: inputStyle.copyWith(
                                  hintText: "Enter Your Password")),
                          SizedBox(
                            height: 20,
                          ),
                          if (!isLoginView)
                            TextFormField(
                                obscureText: true,
                                validator: (againPassword) =>
                                    againPassword == _passwordController.text
                                        ? null
                                        : "Password not matched",
                                controller: _confirmPasswordController,
                                decoration: inputStyle.copyWith(
                                    hintText: "Confirm Your Password")),
                          if (!isLoginView)
                            SizedBox(
                              height: 20,
                            ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Builder(builder: (ctx) {
                        return CupertinoButton(
                          child: authUserProvider.state == ViewState.loading
                              ? Text("Loading")
                              : Text(
                                  isLoginView ? "Log In " : "Create Account"),
                          color: Colors.green,
                          disabledColor: Colors.grey,
                          onPressed: isFormValid &&
                                  authUserProvider.state == ViewState.idle
                              ? () async {
                                  if (!isFormValid) return;
                                  final email = _emailController.text;
                                  final name = _nameController.text;
                                  final password = _passwordController.text;
                                  ViewResponse response;
                                  if (isLoginView) {
                                    response =
                                        await authUserProvider.signInUser(
                                            email: email, password: password);
                                  } else {
                                    response =
                                        await authUserProvider.signUpUser(
                                            email: email,
                                            password: password,
                                            name: name);
                                  }
                                  if (response.error) {
                                    Scaffold.of(ctx).showSnackBar(SnackBar(
                                        content: Text(response.message)));
                                  }
                                }
                              : null,
                        );
                      }),
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
