import 'package:flutter/foundation.dart';
import 'package:todonick/helpers/failure.dart';
import 'package:todonick/helpers/view_response.dart';
import 'package:todonick/models/todo.dart';
import 'package:todonick/providers/view_state_provider.dart';
import 'package:todonick/service_locator.dart';
import 'package:todonick/services/database_service.dart';

class TodoProvider extends ViewStateProvider {
  DatabaseService _databaseService = locator<DatabaseService>();
  String _userId;
  String _listId;
  List<Todo> _todos = [];
  List<Todo> get todos => _todos;
  bool isFetchedAlready = false;

  bool get isUserIdAvailable => _userId != null;

  void addTodo(Todo todo) {
    _todos.insert(0, todo);
    stopLoader();
  }

  TodoProvider({@required String userId, @required String listId})
      : _userId = userId,
        _listId = listId;

  Future<ViewResponse<void>> createTodo(
      {@required String name, String details}) async {
    if (_userId == null || _listId == null)
      return ViewResponse(error: true, message: "nothing worry about");
    try {
      startLoader();
      final Todo todo = await _databaseService.createTodo(
          userId: _userId, listId: _listId, name: name, details: details);
      addTodo(todo);
      return ViewResponse(message: "Todo creation succesfful");
    } on Failure catch (failure) {
      stopLoader();
      return ViewResponse.fromFailure(failure);
    }
  }

  Future<ViewResponse<void>> fetchTodos() async {
    if (isFetchedAlready) return null;
    if (_userId == null || _listId == null)
      return ViewResponse(
          error: true, message: "User or user list is no available");
    try {
      print("fetching");
      startLoader();
      final List<Todo> todosList =
          await _databaseService.getTodos(userId: _userId, listId: _listId);
      if (todos != null || todos.isNotEmpty) {
        _todos = todosList;
      }
      isFetchedAlready = true;
      stopLoader();
      return ViewResponse(message: "All todos fetched successfully");
    } on Failure catch (failure) {
      stopLoader();
      return ViewResponse.fromFailure(failure);
    }
  }

  Future<void> deleteAllTodos() async {
    try {
      _todos.forEach((todo) async {
        await todo.documentReference.delete();
      });
    } catch (error) {
      throw Failure("Deleting all todos failed");
    }
  }

  Future<ViewResponse<void>> toggleComplete(int index) async {
    if (index >= todos.length)
      return ViewResponse(error: true, message: "Something went wrong");
    final Todo updatableTodo = _todos[index];
    updatableTodo.toggleComplete();
    try {
      startLoader();
      await _databaseService.updateTodo(
          userId: _userId,
          listId: _listId,
          todoId: updatableTodo.id,
          completed: !updatableTodo.completed);
      stopLoader();
      return ViewResponse(message: "Todo completed successfully");
    } on Failure catch (failure) {
      updatableTodo.toggleComplete();
      return ViewResponse.fromFailure(failure);
    }
  }

  @override
  void dispose() {
    _todos.clear();
    super.dispose();
  }
}
