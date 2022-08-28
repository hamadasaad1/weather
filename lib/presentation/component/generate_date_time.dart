import 'package:intl/intl.dart';

DateTime generateDateTime(int secTimestamp)
{
  return DateTime.fromMillisecondsSinceEpoch(secTimestamp*1000);
}
String changeDateFormat(String dateString){
  DateTime date = DateTime.parse(dateString);
  String formatDate = "${DateFormat.E().format(date)}, ${DateFormat.j().format(date)}";
  return formatDate;
}