import 'package:todonick/helpers/failure.dart';
import 'package:todonick/helpers/view_response.dart';
import 'package:todonick/models/todo_list.dart';
import 'package:todonick/providers/todo_provider.dart';
import 'package:todonick/providers/view_state_provider.dart';
import 'package:todonick/service_locator.dart';
import 'package:todonick/services/database_service.dart';

class TodoListProvider extends ViewStateProvider {
  DatabaseService _databaseService = locator<DatabaseService>();
  List<TodoList> _listOfTodoList = [];
  List<TodoList> get todoLists => _listOfTodoList;
  int _selectedIndex = -1;
  String _todoUserId;
  List<TodoProvider> _todoProviderList = [];
  String get todoUserId => _todoUserId;
  int get selectedIndex => _selectedIndex;
  TodoProvider getTodoProvider([int index]) =>
      _selectedIndex > -1 && _selectedIndex < _todoProviderList.length
          ? _todoProviderList[selectedIndex]
          : null;
  void changeSelectedIndex(int index) async {
    if (index >= _listOfTodoList.length) return;
    _selectedIndex = index;
    if (_todoProviderList == null) _todoProviderList = [];
    if (index < _todoProviderList.length) {
      await _todoProviderList[index].fetchTodos();
    }
    notifyListeners();
  }

  TodoListProvider([String userId])
      : _todoUserId = userId,
        _listOfTodoList = [],
        _todoProviderList = [] {
    if (userId == null) return;
    fetchTodoLists(userId);
  }

  Future<ViewResponse<String>> fetchTodoLists(String id) async {
    if (id == null)
      return ViewResponse(error: true, message: "User is not avalaible");
    try {
      startLoader();
      final list = await _databaseService.getTodoLists(id);
      if (list != null || list.isNotEmpty) {
        _listOfTodoList = list;
        list.forEach((todoList) {
          _todoProviderList.add(TodoProvider(userId: id, listId: todoList.id));
        });
        _todoUserId = id;
        changeSelectedIndex(0);
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
        _listOfTodoList.insert(0, todoList);
        _todoProviderList.insert(
            0, TodoProvider(listId: todoList.id, userId: userId));
        changeSelectedIndex(0);
      }
      stopLoader();
      return ViewResponse(message: "Creating todo list successful");
    } on Failure catch (failure) {
      stopLoader();
      print(failure);
      return ViewResponse.fromFailure(failure);
    }
  }

  Future<ViewResponse<void>> deleteTodoList({int index, String listId}) async {
    if (_todoUserId == null)
      return ViewResponse(error: true, message: "User is not available");
    final TodoList removedList = _listOfTodoList.removeAt(index);
    final TodoProvider removeTodoProvider = _todoProviderList.removeAt(index);
    try {
      startLoader();
      await _databaseService.deleteTodoList(
          userId: _todoUserId, listId: listId);
      if (selectedIndex >= todoLists.length) {
        changeSelectedIndex(0);
      }
      stopLoader();
      return ViewResponse(message: "Todo List deleted successfully");
    } on Failure catch (failure) {
      stopLoader();
      _listOfTodoList.insert(index, removedList);
      _todoProviderList.insert(index, removeTodoProvider);
      changeSelectedIndex(index);
      return ViewResponse.fromFailure(failure);
    }
  }
}
