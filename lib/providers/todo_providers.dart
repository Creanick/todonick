import 'package:flutter/foundation.dart';
import 'package:todonick/models/todo.dart';
import 'package:uuid/uuid.dart';

class TodoProvider with ChangeNotifier {
  List<Todo> _todos;
  List<Todo> _completedTodos;
  //create
  TodoProvider()
      : _todos = [],
        _completedTodos = [] {
    this.addTodo(name: "Buy pc");
    this.addTodo(name: "Play football");
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
    notifyListeners();
  }

  void completeTodo(int index) {
    if (!isIndexExist(index)) return;
    final Todo completedTodo = deleteTodo(index);
    completedTodo.complete();
    _completedTodos.add(completedTodo);
    notifyListeners();
  }

  void deCompleteTodo(int index) {
    if (!isIndexExist(index, isCompletedList: true)) return;
    final Todo nonCompletedTodo = deleteTodo(index, isCompletedList: true);
    nonCompletedTodo.deComplete();
    _todos.insert(0, nonCompletedTodo);
    notifyListeners();
  }

  //delete
  Todo deleteTodo(int index, {bool isCompletedList = false}) {
    if (!isIndexExist(index, isCompletedList: isCompletedList)) return null;
    final Todo removedTodo = isCompletedList
        ? _completedTodos.removeAt(index)
        : _todos.removeAt(index);
    notifyListeners();
    return removedTodo;
  }
}
