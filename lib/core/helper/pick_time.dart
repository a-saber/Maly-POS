import 'package:flutter/material.dart';

Future<DateTime?> pickDate(
    {required BuildContext context,
    DateTime? initalTime,
    DateTime? startDate,
    DateTime? endDate}) async {
  return showDatePicker(
    context: context,
    initialDate: initalTime,
    firstDate: startDate ?? DateTime(2000),
    lastDate: endDate ?? DateTime(2100),
  );
}
