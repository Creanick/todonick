import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:todonick/helpers/failure.dart';
import 'package:todonick/helpers/view_response.dart';
import 'package:todonick/providers/view_state_provider.dart';
import 'package:todonick/service_locator.dart';
import 'package:todonick/services/auth_service.dart';
import 'package:todonick/services/database_service.dart';

class AuthUserProvider extends ViewStateProvider {
  AuthService _authService = locator<AuthService>();
  DatabaseService _databaseService = locator<DatabaseService>();
  FirebaseUser _authUser;
  FirebaseUser get authUser => _authUser;
  bool get isAuthenticated => _authUser != null;

  //create methods
  AuthUserProvider() {
    _tryAutoLogin();
  }

  //private methods
  void _tryAutoLogin() {
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

  void _resetUser() {
    _authUser = null;
    stopLoader();
  }

  void _addUser(FirebaseUser user) {
    _authUser = user;
    stopLoader();
  }

  // public methods
  Future<ViewResponse<String>> signUpUser(
      {@required String email, @required String password, String name}) async {
    try {
      startLoader();
      final FirebaseUser user =
          await _authService.signUp(email: email, password: password);
      await _databaseService.createUser(id: user.uid, email: email, name: name);
      _addUser(user);
      return ViewResponse(data: user.uid);
    } on Failure catch (failure) {
      stopLoader();
      print(failure);
      return ViewResponse.fromFailure(failure);
    }
  }

  Future<ViewResponse<String>> signInWithGoogle() async {
    try {
      startLoader();
      final FirebaseUser user = await _authService.signInWithGoogle();
      await _databaseService.updateUser(user.uid,
          name: user.displayName, email: user.email, profileUrl: user.photoUrl);
      _addUser(user);
      stopLoader();
      return ViewResponse(message: "Google Sign in successful");
    } on Failure catch (failure) {
      stopLoader();
      return ViewResponse.fromFailure(failure);
    }
  }

  Future<ViewResponse<String>> signInUser(
      {@required String email, @required String password}) async {
    try {
      startLoader();
      final FirebaseUser user =
          await _authService.signIn(email: email, password: password);
      _addUser(user);
      return ViewResponse(data: user.uid);
    } on Failure catch (failure) {
      stopLoader();
      print(failure);
      return ViewResponse.fromFailure(failure);
    }
  }

  Future<ViewResponse<void>> signOutUser() async {
    try {
      startLoader();
      await _authService.signOut();
      _resetUser();
      return ViewResponse();
    } on Failure catch (failure) {
      stopLoader();
      print(failure);
      return ViewResponse.fromFailure(failure);
    }
  }
}
