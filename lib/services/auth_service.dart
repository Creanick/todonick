import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todonick/helpers/failure.dart';

class AuthService {
  GoogleSignIn _googleSignIn = GoogleSignIn();
  FirebaseAuth _auth = FirebaseAuth.instance;

  //signup
  Future<FirebaseUser> signUp(
      {@required String email, @required String password}) async {
    try {
      return (await _auth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user;
    } on PlatformException catch (p) {
      throw Failure(p.message);
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
    } on PlatformException catch (p) {
      throw Failure(p.message);
    } catch (error) {
      throw Failure("sign in faiiled");
    }
  }

  //sign out
  Future<void> signOut() async {
    try {
      final bool isGoogleSignedIn = await _googleSignIn.isSignedIn();
      if (isGoogleSignedIn) {
        await _googleSignIn.signOut();
      }
      await _auth.signOut();
    } on PlatformException catch (p) {
      throw Failure(p.message);
    } catch (error) {
      throw Failure("sign out failed");
    }
  }

  Future<FirebaseUser> signInWithGoogle() async {
    try {
      GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      AuthCredential authCredential = GoogleAuthProvider.getCredential(
          idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
      final AuthResult authResult =
          await _auth.signInWithCredential(authCredential);
      return authResult.user;
    } catch (error) {
      print(error);
      throw Failure("Google sigin failed");
    }
  }

  //auth user stream
  Stream<FirebaseUser> get authUserStream => _auth.onAuthStateChanged;
  Future<FirebaseUser> get currentUser => _auth.currentUser();
}
