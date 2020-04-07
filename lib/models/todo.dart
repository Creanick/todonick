import 'package:flutter/foundation.dart';
import 'package:todonick/helpers/timestamp_convert.dart';

class Todo {
  final String id;
  bool _completed;
  String _details;
  DateTime _reminder;
  String _name;
  final DateTime createdDate;
  DateTime _updatedDate;

  // create
  Todo(
      {@required this.id,
      @required String name,
      bool completed = false,
      String details = "",
      DateTime reminder})
      : _name = name,
        _completed = completed,
        _details = details,
        _reminder = reminder,
        createdDate = DateTime.now(),
        _updatedDate = DateTime.now();
  Todo.fromMap(this.id, Map<String, dynamic> todoMap)
      : _name = todoMap['name'],
        _completed = todoMap["completed"] ?? false,
        _details = todoMap["details"] ?? "",
        _reminder = fromTimeStamp(todoMap["reminder"]),
        createdDate = fromTimeStamp(todoMap["createdDate"]) ?? DateTime.now(),
        _updatedDate = fromTimeStamp(todoMap["updatedDate"]) ?? DateTime.now();

  // read
  Map<String, dynamic> toMap() => ({
        "id": id,
        "name": _name,
        "completed": _completed,
        "details": _details,
        "reminder": toTimeStamp(_reminder),
        "createdDate": toTimeStamp(createdDate),
        "updatedDate": toTimeStamp(_updatedDate)
      });
  String get details => _details;
  DateTime get reminder => _reminder;
  String get name => _name;
  bool get completed => _completed;
  DateTime get updatedDate => _updatedDate;

  // update
  void update(
      {String name, String details, DateTime reminder, bool completed}) {
    _name = name ?? _name;
    _details = details ?? _details;
    _reminder = reminder ?? _reminder;
    _completed = completed ?? _completed;
    _updatedDate = DateTime.now();
  }

  void rename(String name) {
    this.update(name: name);
  }

  void toggleCompletion() {
    this.update(completed: !_completed);
  }

  void complete() {
    this.update(completed: true);
  }

  void deComplete() {
    this.update(completed: false);
  }
}
