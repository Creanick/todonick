import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:todonick/db_paths.dart';
import 'package:todonick/models/todo.dart';
import 'package:uuid/uuid.dart';

class TodoProvider with ChangeNotifier {
  CollectionReference _storeCollection =
      Firestore.instance.collection(todoCollectionName);
  List<Todo> _todos;
  List<Todo> _completedTodos;
  //create
  TodoProvider()
      : _todos = [],
        _completedTodos = [] {
    _storeCollection.getDocuments().then((querySnapshot) {
      final List<DocumentSnapshot> documents = querySnapshot.documents;
      documents.forEach((document) {
        _todos.add(Todo.fromMap(document.documentID, document.data));
      });
      notifyListeners();
    });
  }
  void addTodo(
      {@required String name,
      String details,
      DateTime reminder,
      bool completed = false,
      bool insertAtFirst = false}) {
    final id = Uuid().v4();
    final Todo todo = Todo(
        id: id,
        name: name,
        completed: completed,
        details: details,
        reminder: reminder);
    _todos.insert(insertAtFirst ? 0 : _todos.length, todo);
    _storeCollection.document(id).setData(todo.toMap());
    notifyListeners();
  }

  //private
  bool isIndexExist(int index, {bool isCompletedList = false}) {
    final List<Todo> todoList = isCompletedList ? _completedTodos : _todos;
    return index < todoList.length && index >= 0;
  }

  //read
  List<Todo> get todoList => [..._todos, ..._completedTodos];
  List<Todo> get nonCompletedTodoList => [..._todos];
  List<Todo> get completedTodoList => [..._completedTodos];
  bool get isTodoListEmpty => _todos.isEmpty && _completedTodos.isEmpty;

  //update
  void moveTodo(int oldIndex, int newIndex) {
    if (!isIndexExist(oldIndex) || !isIndexExist(newIndex)) return;
    final Todo replacableTodo = _todos[oldIndex];
    final Todo replacingTodo = _todos[newIndex];
    _todos[newIndex] = replacableTodo;
    _todos[oldIndex] = replacingTodo;
    notifyListeners();
  }

  void updateTodo(int index, {String name, String details, DateTime reminder}) {
    if (!isIndexExist(index)) return;
    _todos[index].update(name: name, details: details, reminder: reminder);
    notifyListeners();
  }

  void renameTodo(int index, String name) {
    if (!isIndexExist(index)) return;
    _todos[index].rename(name);
    _storeCollection.document(_todos[index].id).updateData({"name": name});
    notifyListeners();
  }

  void completeTodo(int index) {
    if (!isIndexExist(index)) return;
    final Todo completedTodo = _todos.removeAt(index);
    completedTodo.complete();
    _completedTodos.add(completedTodo);
    _storeCollection.document(completedTodo.id).updateData({"completed": true});
    notifyListeners();
  }

  void deCompleteTodo(int index) {
    if (!isIndexExist(index, isCompletedList: true)) return;
    final Todo nonCompletedTodo = _completedTodos.removeAt(index);
    nonCompletedTodo.deComplete();
    _todos.insert(0, nonCompletedTodo);
    _storeCollection
        .document(nonCompletedTodo.id)
        .updateData({"completed": false});
    notifyListeners();
  }

  //delete
  Todo deleteTodo(int index, {bool isCompletedList = false}) {
    if (!isIndexExist(index, isCompletedList: isCompletedList)) return null;
    final Todo removedTodo = isCompletedList
        ? _completedTodos.removeAt(index)
        : _todos.removeAt(index);
    _storeCollection.document(removedTodo.id).delete();
    notifyListeners();
    return removedTodo;
  }
}
