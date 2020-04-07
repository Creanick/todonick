import 'package:cloud_firestore/cloud_firestore.dart';

DateTime toTimeStamp(DateTime dateTime) {
  if (dateTime == null) return null;
  return dateTime;
}

DateTime fromTimeStamp(Timestamp timestamp) {
  if (timestamp == null) return null;
  return DateTime.fromMicrosecondsSinceEpoch(timestamp.microsecondsSinceEpoch);
}
