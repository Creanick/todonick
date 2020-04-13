import 'package:todonick/helpers/failure.dart';
import 'package:todonick/helpers/view_response.dart';
import 'package:todonick/models/todo_list.dart';
import 'package:todonick/providers/view_state_provider.dart';
import 'package:todonick/service_locator.dart';
import 'package:todonick/services/database_service.dart';

class TodoListProvider extends ViewStateProvider {
  DatabaseService _databaseService = locator<DatabaseService>();
  List<TodoList> _listOfTodoList;
  List<TodoList> get todoLists => _listOfTodoList;
  TodoListProvider([String userId]) : _listOfTodoList = [] {
    if (userId == null) return;
    fetchTodoLists(userId);
  }

  Future<ViewResponse<String>> fetchTodoLists(String userId) async {
    if (userId == null)
      return ViewResponse(error: true, message: "User is not avalaible");
    try {
      startLoader();
      final list = await _databaseService.getTodoLists(userId);
      if (list != null || list.isNotEmpty) {
        _listOfTodoList = list;
      }
      stopLoader();
      return ViewResponse(data: "Fetching todo lists successful");
    } on Failure catch (failure) {
      stopLoader();
      return ViewResponse.fromFailure(failure);
    }
  }

  Future<ViewResponse<String>> createTodoList(
      String userId, String name) async {
    try {
      startLoader();
      final TodoList todoList =
          await _databaseService.createTodoList(userId, name);
      if (todoList != null) {
        _listOfTodoList.add(todoList);
      }
      stopLoader();
      return ViewResponse(message: "Creating todo list successful");
    } on Failure catch (failure) {
      stopLoader();
      print(failure);
      return ViewResponse.fromFailure(failure);
    }
  }
}
