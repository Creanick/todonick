import 'package:flutter/foundation.dart';

class TodoList {
  final String id;
  String _name;
  String get name => _name;
  TodoList({@required this.id, @required String name}) : _name = name;

  TodoList.fromMap(this.id, Map<String, dynamic> todoListMap)
      : _name = todoListMap['name'];

  void rename(String name) {
    _name = name ?? _name;
  }

  Map<String, dynamic> toMap() {
    return {"name": _name};
  }
}
