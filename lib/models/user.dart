import 'package:flutter/foundation.dart';

class User {
  final String id;
  final String name;
  final String email;
  User({@required this.id, @required this.name, @required this.email});

  User.fromMap(this.id, Map<String, dynamic> userMap)
      : name = userMap['name'],
        email = userMap['email'];
  Map<String, dynamic> toMap() {
    return {"name": name, "email": email};
  }
}
