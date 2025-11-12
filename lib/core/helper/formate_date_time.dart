// import 'package:geolocator/geolocator.dart';
// import 'package:timezone/browser.dart';
// import 'package:timezone/timezone.dart' as tz;
// import 'package:timezone/data/latest.dart' as tz;
import 'package:intl/intl.dart';

// abstract class GetLocation {
//   static Location? location;
//   static Future<void> getParameterOfLocation() async {
//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) return;
//     }

//     // 2️⃣ جلب الإحداثيات
//     // ignore: unused_local_variable
//     Position position = await Geolocator.getCurrentPosition();

//     // 3️⃣ تهيئة مناطق الوقت
//     tz.initializeTimeZones();

//     // 4️⃣ تحويل الإحداثيات إلى منطقة زمنية تلقائيًا
//     location = tz.getLocation(
//       tz.timeZoneDatabase.locations.keys.firstWhere(
//         (k) => k.contains('Asia/Riyadh'),
//         orElse: () => 'Asia/Riyadh',
//       ),
//     );
//   }
// }

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

// String getLocalTimeFormate(String utcString) {
//   if (utcString.isEmpty || utcString == '-') {
//     return utcString;
//   }
//   // final riyadh = tz.getLocation('Asia/Riyadh');
//   final utcTime = DateTime.parse(utcString);
//   final localTime = tz.TZDateTime.from(utcTime, riyadh);

//   return DateFormat('h:mm a d MMM yyyy').format(localTime);
// }

String getLocalTimeFormate(String utcString) {
  if (utcString.isEmpty || utcString == '-') {
    return utcString;
  }
  DateTime utcTime = DateTime.parse(utcString);
  DateTime localTime = utcTime.toLocal();
  return DateFormat('h:mm a d MMM yyyy').format(localTime.toLocal());
}
