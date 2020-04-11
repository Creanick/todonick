import 'package:flutter/foundation.dart';
import 'package:todonick/helpers/failure.dart';
import 'package:todonick/helpers/view_response.dart';
import 'package:todonick/models/user.dart';
import 'package:todonick/providers/view_state_provider.dart';
import 'package:todonick/service_locator.dart';
import 'package:todonick/services/database_service.dart';

class TodoUserProvider extends ViewStateProvider {
  DatabaseService _databaseService = locator<DatabaseService>();
  User _user;
  User get user => _user;

  void clearUser() {
    _user = null;
  }

  TodoUserProvider([String id]) {
    fetchUser(id);
  }
  _setUser(User user) {
    _user = user;
    stopLoader();
  }

  Future<ViewResponse<void>> createUser(
      {@required String id, @required String email, String name}) async {
    try {
      startLoader();
      final User user =
          await _databaseService.createUser(id: id, email: email, name: name);
      _setUser(user);
      return ViewResponse();
    } on Failure catch (failure) {
      stopLoader();
      print(failure);
      return ViewResponse.fromFailure(failure);
    }
  }

  Future<ViewResponse<void>> fetchUser(String id) async {
    if (id == null) return ViewResponse();
    startLoader();
    try {
      final User user = await _databaseService.getUser(id);
      _setUser(user);
      return ViewResponse();
    } on Failure catch (failure) {
      stopLoader();
      print(failure);
      return ViewResponse.fromFailure(failure);
    }
  }
}
