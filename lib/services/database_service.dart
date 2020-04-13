import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:todonick/helpers/failure.dart';
import 'package:todonick/helpers/view_response.dart';
import 'package:todonick/models/todo_list.dart';
import 'package:todonick/models/user.dart';

class DatabaseService {
  Firestore _store = Firestore.instance;
  CollectionReference _userCollection;
  final String todoListCollectionName = "todoLists";
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

  Future<void> updateUser(String id, {String name, String profileUrl}) async {
    if (id == null) return;
    final Map<String, dynamic> updatedMap = {};
    if (name != null) {
      updatedMap['name'] = name;
    }
    if (profileUrl != null) {
      updatedMap['profileUrl'] = profileUrl;
    }
    if (updatedMap.isEmpty) return;
    try {
      await _userCollection.document(id).updateData(updatedMap);
    } catch (error) {
      print(error);
      throw Failure("updating user failed");
    }
  }

  Future<List<TodoList>> getTodoLists(String userId) async {
    if (userId == null) throw Failure("user id is not available");
    try {
      final QuerySnapshot querySnapshot = await _userCollection
          .document(userId)
          .collection(todoListCollectionName)
          .getDocuments();
      if (querySnapshot == null) return [];
      final lists = querySnapshot.documents.map((docSnapshot) {
        return TodoList.fromMap(docSnapshot.documentID, docSnapshot.data);
      }).toList();
      return lists;
    } catch (error) {
      throw Failure("getting todo lists failed");
    }
  }

  Future<TodoList> createTodoList(String userId, String todoListName) async {
    if (userId == null) throw Failure("user id is not available");
    try {
      DocumentReference docRef = await _userCollection
          .document(userId)
          .collection(todoListCollectionName)
          .add({"name": todoListName});
      return TodoList(id: docRef.documentID, name: todoListName);
    } catch (error) {
      throw Failure("todo list creation failed");
    }
  }
}
