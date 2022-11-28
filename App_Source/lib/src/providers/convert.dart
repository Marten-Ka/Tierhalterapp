import 'dart:math';
import 'package:intl/intl.dart';

String bytestoFormatedString(int bytes) {
  if (bytes <= 0) return "0 B";
  const suffixes = ["B", "KB", "MB", "GB"];
  var i = (log(bytes) / log(1024)).floor();
  return ((bytes / pow(1024, i)).toStringAsFixed(2)) + ' ' + suffixes[i];
}

String timeStampToDateString(int timeStamp) {
  DateTime date = DateTime.fromMillisecondsSinceEpoch(timeStamp*1000);
  return DateFormat('dd.MM.yy – kk:mm').format(date);
}