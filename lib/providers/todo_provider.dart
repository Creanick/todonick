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
  List<Todo> _nonCompletedTodos;
  List<Todo> _completedTodos;

  bool get isUserIdAvailable => _userId != null;

  List<Todo> get nonCompletedTodos => _nonCompletedTodos;
  List<Todo> get completedTodos => _completedTodos;

  bool get isEmpty => _nonCompletedTodos.isEmpty && _completedTodos.isEmpty;

  void addTodo(Todo todo) {
    _nonCompletedTodos.insert(0, todo);
    stopLoader();
  }

  TodoProvider({@required String userId, @required String listId})
      : _userId = userId,
        _listId = listId,
        _nonCompletedTodos = [],
        _completedTodos = [];

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
    if (_userId == null || _listId == null)
      return ViewResponse(
          error: true, message: "User or user list is no available");
    try {
      print("fetching");
      startLoader();
      final List<Todo> todos =
          await _databaseService.getTodos(userId: _userId, listId: _listId);
      if (todos != null || todos.isNotEmpty) {
        todos.forEach((todo) {
          if (todo.completed) {
            _completedTodos.add(todo);
          } else {
            _nonCompletedTodos.add(todo);
          }
        });
      }
      stopLoader();
      return ViewResponse(message: "All todos fetched successfully");
    } on Failure catch (failure) {
      stopLoader();
      return ViewResponse.fromFailure(failure);
    }
  }

  Future<void> deleteAllTodos() async {
    try {
      _nonCompletedTodos.forEach((todo) async {
        await todo.documentReference.delete();
      });
      _completedTodos.forEach((todo) async {
        await todo.documentReference.delete();
      });
    } catch (error) {
      throw Failure("Deleting all todos failed");
    }
  }
}
