import 'package:flutter/foundation.dart';

class User {
  final String id;
  String _name;
  final String email;
  String get name => _name;
  User({@required this.id, @required name, @required this.email})
      : _name = name;

  User.fromMap(this.id, Map<String, dynamic> userMap)
      : _name = userMap['name'],
        email = userMap['email'];
  Map<String, dynamic> toMap() {
    return {"name": _name, "email": email};
  }

  void udpate({String name}) {
    _name = name ?? _name;
  }
}
