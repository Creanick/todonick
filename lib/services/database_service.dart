import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:todonick/helpers/failure.dart';
import 'package:todonick/models/todo.dart';
import 'package:todonick/models/todo_list.dart';
import 'package:todonick/models/user.dart';

class DatabaseService {
  Firestore _store = Firestore.instance;
  CollectionReference _userCollection;
  final String todoListCollectionName = "todoLists";
  final String todoCollectionName = "todos";
  DatabaseService([String userCollectionPath = "users"]) {
    _userCollection = _store.collection(userCollectionPath);
  }

  DocumentReference getUserDocument(String userId) {
    return _userCollection.document(userId);
  }

  CollectionReference getListCollection(String userId) {
    return getUserDocument(userId).collection(todoListCollectionName);
  }

  DocumentReference getListDocument(String userId, String listId) {
    return getListCollection(userId).document(listId);
  }

  CollectionReference getTodoCollection(String userId, String listId) {
    return getListDocument(userId, listId).collection(todoCollectionName);
  }

  DocumentReference getTodoDocument(
      String userId, String listId, String todoId) {
    return getTodoCollection(userId, listId).document(todoId);
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

  Future<void> deleteTodoList({String userId, String listId}) async {
    if (userId == null || listId == null)
      throw Failure("Todo list deletion failed");
    try {
      await _userCollection
          .document(userId)
          .collection(todoListCollectionName)
          .document(listId)
          .delete();
    } catch (error) {
      throw Failure("Todo list deletion failed");
    }
  }

  //todo database service
  Future<Todo> createTodo(
      {@required String userId,
      @required String listId,
      String name,
      String details = ""}) async {
    if (userId == null || listId == null || name == null)
      throw Failure("Todo creation not possible due to insufficient data");
    try {
      final DocumentReference docRef =
          getTodoCollection(userId, listId).document();
      final Todo todo = Todo(
          id: docRef.documentID,
          name: name,
          details: details,
          documentReference: docRef);
      await docRef.setData(todo.toMap());
      return todo;
    } catch (error) {
      throw Failure("Todo creation failed");
    }
  }

  Future<List<Todo>> getTodos(
      {@required String userId, @required String listId}) async {
    if (userId == null || listId == null) {
      throw Failure("Fetching todos not possible due to shortage of data");
    }
    try {
      final QuerySnapshot querySnapshot =
          await getTodoCollection(userId, listId).getDocuments();
      if (querySnapshot == null) return [];
      return querySnapshot.documents.map((docSnap) {
        return Todo.fromMap(
            docSnap.documentID, docSnap.data, docSnap.reference);
      }).toList();
    } catch (error) {
      throw Failure("Fetching todos failed");
    }
  }

  Future<void> updateTodo(
      {@required userId,
      @required String listId,
      @required String todoId,
      String name,
      String details,
      bool completed}) async {
    if (userId == null || listId == null || todoId == null)
      throw Failure("userid or list id is not provided");
    try {
      final Map<String, dynamic> updatedMap = {};
      if (name != null) {
        updatedMap['name'] = name;
      }
      if (details != null) {
        updatedMap['details'] = details;
      }
      if (completed != null) {
        updatedMap['completed'] = completed;
      }
      if (updatedMap.isNotEmpty) {
        await getTodoDocument(userId, listId, todoId).updateData(updatedMap);
      }
    } catch (error) {
      throw Failure("compeleting todo failed");
    }
  }
}
