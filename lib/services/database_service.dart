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

  Future<User> createUser(
      {@required String id, @required String email, String name}) async {
    try {
      if (name == null) {
        name = email.split("@").first;
      }
      final user = User(id: id, name: name, email: email);
      await _userCollection.document(id).setData(user.toMap());
      return user;
    } catch (error) {
      throw Failure("creating user failed");
    }
  }

  Future<User> getUser(String id) async {
    if (id == null) return null;
    try {
      final DocumentSnapshot snapshot =
          await _userCollection.document(id).get();
      if (snapshot == null) return null;
      return User.fromMap(snapshot.documentID, snapshot.data);
    } catch (error) {
      throw Failure("fetching user failed");
    }
  }

  Future<void> updateUser(
    String id, {
    String name,
  }) async {
    if (id == null) return;
    final Map<String, dynamic> updatedMap = {};
    if (name != null) {
      updatedMap['name'] = name;
    }
    if (updatedMap.isEmpty) return;
    try {
      await _userCollection.document(id).updateData(updatedMap);
    } catch (error) {
      print(error);
      throw Failure("updating user failed");
    }
  }
}
