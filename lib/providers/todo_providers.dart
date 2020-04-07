import 'package:flutter/foundation.dart';
import 'package:todonick/models/todo.dart';
import 'package:uuid/uuid.dart';

class TodoProvider with ChangeNotifier {
  List<Todo> _todos;
  //create
  TodoProvider() : _todos = [];
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
  }

  //private
  bool isIndexExist(int index) {
    return _todos.length < index && index >= 0;
  }

  //read
  List<Todo> get todoList => [..._todos];

  //update
  void moveTodo(int oldIndex, int newIndex) {
    if (!isIndexExist(oldIndex) || !isIndexExist(newIndex)) return;
    final Todo replacableTodo = _todos[oldIndex];
    final Todo replacingTodo = _todos[newIndex];
    _todos[newIndex] = replacableTodo;
    _todos[oldIndex] = replacingTodo;
    notifyListeners();
  }

  void updateTodo(int index,
      {String name, String details, DateTime reminder, bool completed}) {
    if (!isIndexExist(index)) return;
    _todos[index].update(
        name: name, details: details, reminder: reminder, completed: completed);
    notifyListeners();
  }

  void renameTodo(int index, String name) {
    if (!isIndexExist(index)) return;
    _todos[index].rename(name);
    notifyListeners();
  }

  void toggleCompletionTodo(int index) {
    if (!isIndexExist(index)) return;
    _todos[index].toggleCompletion();
    notifyListeners();
  }

  void completeTodo(int index) {
    if (!isIndexExist(index)) return;
    _todos[index].complete();
    notifyListeners();
  }

  void deCompleteTodo(int index) {
    if (!isIndexExist(index)) return;
    _todos[index].deComplete();
    notifyListeners();
  }

  //delete
  Todo deleteTodo(int index) {
    if (!isIndexExist(index)) return null;
    final Todo removedTodo = _todos.removeAt(index);
    notifyListeners();
    return removedTodo;
  }
}
