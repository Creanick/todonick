import 'package:flutter/foundation.dart';

class User {
  final String id;
  String _name;
  final String email;
  String _profileUrl;
  String get name => _name;
  String get profileUrl => _profileUrl;
  User(
      {@required this.id,
      @required name,
      @required this.email,
      String profileUrl})
      : _name = name,
        _profileUrl = profileUrl;

  User.fromMap(this.id, Map<String, dynamic> userMap)
      : _name = userMap['name'],
        email = userMap['email'],
        _profileUrl = userMap['profileUrl'];
  Map<String, dynamic> toMap() {
    return {"name": _name, "email": email, "profileUrl": _profileUrl};
  }

  void udpate({String name, String profileUrl}) {
    _name = name ?? _name;
    _profileUrl = profileUrl ?? _profileUrl;
  }
}
