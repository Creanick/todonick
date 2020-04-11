import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:todonick/helpers/failure.dart';
import 'package:todonick/models/user.dart';

class DatabaseService {
  Firestore _store = Firestore.instance;
  CollectionReference _userCollection;
  DatabaseService([String userCollectionPath = "users"]) {
    _userCollection = _store.collection(userCollectionPath);
  }

  Future<void> createUser(
      {@required String id, @required String email, String name}) async {
    try {
      if (name == null) {
        name = email.split("@").first;
      }
      await _userCollection
          .document(id)
          .setData(User(id: id, name: name, email: email).toMap());
    } catch (error) {
      throw Failure("creating user failed");
    }
  }

  Future<User> getUser(String id) async {
    try {
      final DocumentSnapshot snapshot =
          await _userCollection.document(id).get();
      if (snapshot == null) return null;
      return User.fromMap(snapshot.documentID, snapshot.data);
    } catch (error) {
      throw Failure("fetching user failed");
    }
  }
}
