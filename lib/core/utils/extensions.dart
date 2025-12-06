
import 'package:flutter/material.dart';

extension WidgetsExtensions on Widget {
  Widget align(AlignmentDirectional position) => Align(
        alignment: position,
        child: this,
      );
  Widget get expand => Expanded(child: this);
  Widget expandFlex(int flex) => Expanded(flex: flex, child: this);
  Widget paddingSymmetric({double vertical = 0.0, double horizontal = 0.0}) =>
      Padding(
        padding: EdgeInsets.symmetric(
          vertical: vertical,
          horizontal: horizontal,
        ),
        child: this,
      );
  Widget paddingAll({double padding = 0.0}) => Padding(
        padding: EdgeInsets.all(padding),
        child: this,
      );
  Widget paddingOnly({
    double start = 0.0,
    double end = 0.0,
    double top = 0.0,
    double bottom = 0.0,
  }) =>
      Padding(
        padding: EdgeInsetsDirectional.only(
            start: start, end: end, top: top, bottom: bottom),
        child: this,
      );
}

extension MapExtensions on Map {
  Map<String, String> dynamicMapToString() {
    Map<String, String> body = {};
    forEach((key, value) {
      if (value is List) {
        body.addAll(_mapListValueHandler(key, value));
      } else if (value is Map) {
        body.addAll(value.dynamicMapToString());
      } else if (value is DateTime) {
        body[key] = value.toIso8601String();
      } else if (value != null) {
        body[key] = value.toString();
      }
    });
    return body;
  }

  Map<String, String> _mapListValueHandler(String key, List iterator) {
    Map<String, String> result = {};
    for (var item in iterator) {
      result["$key[${iterator.indexOf(item)}]"] = item.toString();
    }
    return result;
  }
}



extension DateTimeExtensions on DateTime {
  String get amOrPm {
    return hour >= 12 ? "pm" : "am";
  }
}

extension TimeOfDayConverter on String {
  TimeOfDay get toTimeOfDay {
    final cleaned = replaceAll("TimeOfDay(", "").replaceAll(")", "");
    final parts = cleaned.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }
}
extension StringNumberFormatting on String? {
  // اسم الدالة اللي هتستخدمها
  String  toAmount(){
    // 1. لو النص null، نرجع صفر
    if (this == null) return "0.00";

    // 2. بنحاول نحول النص لرقم (tryParse آمن من parse)
    // لو النص فيه حروف أو مسافات غلط، هيرجع null
    double? value = double.tryParse(this!);

    // 3. لو التحويل فشل، نرجع صفر (أو ممكن ترجع القيمة الأصلية حسب رغبتك)
    if (value == null) return "0.00";

    // 4. التحويل النهائي للشكل المطلوب
    return value.toStringAsFixed(2);
  }
}


