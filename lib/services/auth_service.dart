import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:todonick/helpers/failure.dart';

class AuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;

  //signup
  Future<FirebaseUser> signUp(
      {@required String email, @required String password}) async {
    try {
      return (await _auth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user;
    } catch (error) {
      throw Failure("sign up failed");
    }
  }

  //sign in
  Future<FirebaseUser> signIn(
      {@required String email, @required String password}) async {
    try {
      return (await _auth.signInWithEmailAndPassword(
              email: email, password: password))
          .user;
    } catch (error) {
      throw Failure("sign in faiiled");
    }
  }

  //sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (error) {
      throw Failure("sign out failed");
    }
  }

  //auth user stream
  Stream<FirebaseUser> get authUserStream => _auth.onAuthStateChanged;
  Future<FirebaseUser> get currentUser => _auth.currentUser();
}
