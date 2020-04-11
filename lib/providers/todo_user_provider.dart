import 'package:flutter/foundation.dart';
import 'package:todonick/helpers/failure.dart';
import 'package:todonick/models/user.dart';
import 'package:todonick/providers/view_state_provider.dart';
import 'package:todonick/service_locator.dart';
import 'package:todonick/services/database_service.dart';

class TodoUserProvider extends ViewStateProvider {
  DatabaseService _databaseService = locator<DatabaseService>();
  User _user;
  User get user => _user;

  TodoUserProvider([String id]) {
    fetchUser(id);
  }
  _setUser(User user) {
    _user = user;
    stopLoader();
  }

  Future<void> createUser(
      {@required String id, @required String email, String name}) async {
    try {
      startLoader();
      final User user =
          await _databaseService.createUser(id: id, email: email, name: name);
      _setUser(user);
    } on Failure catch (failure) {
      stopLoader();
      print(failure);
    }
  }

  Future<void> fetchUser(String id) async {
    if (id == null) return;
    startLoader();
    try {
      final User user = await _databaseService.getUser(id);
      _setUser(user);
    } on Failure catch (failure) {
      stopLoader();
      print(failure);
    }
  }
}
