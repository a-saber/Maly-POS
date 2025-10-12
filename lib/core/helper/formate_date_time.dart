import 'package:intl/intl.dart';

String formatDateString(String dateString) {
  DateTime date = DateTime.parse(dateString);
  return DateFormat('h:mm a d MMM yyyy').format(date.toLocal());
}

String formatDateyyyymmdd(DateTime date) {
  return DateFormat('yyyy-MM-dd').format(date);
}

String formatDateyyyymmddHHMMSS(DateTime date) {
  return DateFormat("yyyy-MM-dd HH:mm:ss").format(date);
}

String formatedmy(DateTime date) {
  return DateFormat('d MMM y').format(date);
}

DateTime getLocalTime(String utcString) {
  DateTime utcTime = DateTime.parse(utcString);
  DateTime localTime = utcTime.toLocal();

  return localTime;
}

String getLocalTimeFormate(String utcString) {
  DateTime utcTime = DateTime.parse(utcString);
  DateTime localTime = utcTime.toLocal();

  return DateFormat('h:mm a d MMM yyyy').format(localTime.toLocal());
}
