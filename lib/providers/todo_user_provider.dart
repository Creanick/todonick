import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:todonick/helpers/failure.dart';
import 'package:todonick/helpers/fetchable.dart';
import 'package:todonick/helpers/view_response.dart';
import 'package:todonick/models/user.dart';
import 'package:todonick/providers/view_state_provider.dart';
import 'package:todonick/service_locator.dart';
import 'package:todonick/services/database_service.dart';
import 'package:todonick/services/storage_service.dart';

class TodoUserProvider extends ViewStateProvider with Fetchable {
  DatabaseService _databaseService = locator<DatabaseService>();
  User _user;
  User get user => _user;

  void clearUser() {
    _user = null;
  }

  void reset({bool notify = false}) {
    clearUser();
    if (notify) {
      notifyListeners();
    }
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
    if (isAlreadyFetched) return null;
    if (id == null) return ViewResponse();
    startLoader();
    try {
      final User user = await _databaseService.getUser(id);
      _setUser(user);
      isAlreadyFetched = true;
      return ViewResponse();
    } on Failure catch (failure) {
      stopLoader();
      print(failure);
      return ViewResponse.fromFailure(failure);
    }
  }

  Future<ViewResponse<String>> updateUser(
      {String name, File profileImageFile, String profileImageName}) async {
    if (user == null || name == null || name.isEmpty)
      return ViewResponse(error: true, message: "User is not available");
    try {
      startLoader();
      String profileUrl;
      if (profileImageFile != null && profileImageName.isNotEmpty) {
        profileUrl = await StorageService.uploadFileAndGetUrl(
            profileImageFile, profileImageName);
      }
      await _databaseService.updateUser(user.id,
          name: name, profileUrl: profileUrl);
      _setUser(_user..udpate(name: name, profileUrl: profileUrl));
      return ViewResponse(data: "Updating User Successful");
    } on Failure catch (failure) {
      stopLoader();
      return ViewResponse.fromFailure(failure);
    }
  }
}
