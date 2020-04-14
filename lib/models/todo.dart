import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Todo {
  final String id;
  String _name;
  bool _completed;
  String _details;
  final DocumentReference documentReference;

  String get name => _name;
  bool get completed => _completed;
  String get details => _details;

  Todo(
      {@required this.id,
      @required String name,
      String details = "",
      @required this.documentReference})
      : _name = name,
        _completed = false,
        _details = details;

  Todo.fromMap(this.id, Map<String, dynamic> todoMap, this.documentReference)
      : _name = todoMap['name'],
        _completed = todoMap['completed'] ?? false,
        _details = todoMap['details'] ?? "";
  Map<String, dynamic> toMap() {
    return {"name": _name, "completed": _completed, "details": _details};
  }

  void update({String name, String details, bool completed}) {
    _name = name ?? _name;
    _details = details ?? _details;
    _completed = completed ?? _completed;
  }

  void toggleComplete() {
    this.update(completed: !_completed);
  }

  void complete() {
    this.update(completed: true);
  }

  void rename(String name) {
    this.update(name: name);
  }

  void deComplete() {
    this.update(completed: false);
  }
}
