import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:todonick/helpers/failure.dart';
import 'package:todonick/service_locator.dart';
import 'package:todonick/services/auth_service.dart';

enum AuthUserState { initial, loading, authenticated, unAuthenticated }

class AuthUserProvider with ChangeNotifier {
  AuthService _authService = locator<AuthService>();
  AuthUserState _state = AuthUserState.initial;
  FirebaseUser _authUser;
  AuthUserState get state => _state;
  FirebaseUser get authUser => _authUser;

  //create methods
  AuthUserProvider() {
    _setState(AuthUserState.loading);
    _authService.currentUser.then((fUser) {
      if (fUser == null) {
        return _resetUser();
      }
      _addUser(fUser);
    }).catchError((error) {
      _resetUser();
      print(error);
    });
  }

  //private methods
  void _setState(AuthUserState state) {
    _state = state;
    notifyListeners();
  }

  void _resetUser() {
    _authUser = null;
    _setState(AuthUserState.unAuthenticated);
  }

  void _addUser(FirebaseUser user) {
    _authUser = user;
    _setState(AuthUserState.authenticated);
  }

  void _setLoader() {
    _setState(AuthUserState.loading);
  }

  // public methods
  Future<void> signUpUser(
      {@required String email, @required String password}) async {
    try {
      _setLoader();
      final FirebaseUser user =
          await _authService.signUp(email: email, password: password);
      _addUser(user);
    } on Failure catch (failure) {
      print(failure);
    }
  }

  Future<void> signInUser(
      {@required String email, @required String password}) async {
    try {
      _setState(AuthUserState.loading);
      final FirebaseUser user =
          await _authService.signIn(email: email, password: password);
      _addUser(user);
    } on Failure catch (failure) {
      print(failure);
    }
  }

  Future<void> signOutUser() async {
    try {
      _setLoader();
      await _authService.signOut();
      _resetUser();
    } on Failure catch (failure) {
      print(failure);
    }
  }
}
