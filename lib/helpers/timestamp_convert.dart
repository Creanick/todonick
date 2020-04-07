String toTimeStamp(DateTime dateTime) {
  return dateTime.toIso8601String();
}

DateTime fromTimeStamp(String dateString) {
  return DateTime.parse(dateString);
}
