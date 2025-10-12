import 'package:flutter/material.dart';
import 'package:pos_app/generated/l10n.dart';

class MyFormValidators {
  static String? validateEmail(String? value,
      {bool validateEmpty = true, required BuildContext context}) {
    if (validateEmpty) {
      if (value == null || value.trim().isEmpty) {
        return S.of(context).emailisrequired;
      }
      final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(value.trim())) {
        return S.of(context).enteravalidemail;
      }
    } else {
      if (value != null && value.trim().isNotEmpty) {
        final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
        if (!emailRegex.hasMatch(value.trim())) {
          return S.of(context).enteravalidemail;
        }
      }
    }
    return null;
  }

  static String? validatePhone(String? value,
      {required BuildContext context, bool validateEmpty = true}) {
    if (validateEmpty) {
      if (value == null || value.trim().isEmpty) {
        return S.of(context).phonenumberisrequired;
      }
      final phoneRegex = RegExp(r'^\+?\d{9,15}$');
      if (!phoneRegex.hasMatch(value.trim())) {
        return S.of(context).enteravalidphonenumber;
      }
    } else {
      if (value != null && value.trim().isNotEmpty) {
        final phoneRegex = RegExp(r'^\+?\d{9,15}$');
        if (!phoneRegex.hasMatch(value.trim())) {
          return S.of(context).enteravalidphonenumber;
        }
      }
    }

    return null;
  }

  static String? validatePassword(String? value,
      {int minLength = 6,
      required BuildContext context,
      bool validateEmpty = true}) {
    if (validateEmpty) {
      if (value == null || value.isEmpty) {
        return S.of(context).passwordisrequired;
      }
      if (value.length < minLength) {
        return '${S.of(context).passwordmustbeatleast} $minLength ${S.of(context).characters}';
      }
    } else {
      if (value != null && value.isNotEmpty) {
        if (value.length < minLength) {
          return '${S.of(context).passwordmustbeatleast} $minLength ${S.of(context).characters}';
        }
      }
    }
    return null;
  }

  static String? confirmvalidatePassword(String? value,
      {int minLength = 6,
      required BuildContext context,
      required String match}) {
    if (value == null || value.isEmpty) {
      return S.of(context).passwordisrequired;
    }
    if (value.length < minLength) {
      return '${S.of(context).passwordmustbeatleast} $minLength ${S.of(context).characters}';
    }
    if (value != match) {
      return S.of(context).passowrdnotmatch;
    }
    return null;
  }

  static String? validateRequired(String? value,
      {required BuildContext context, String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? S.of(context).field} ${S.of(context).isrequired}';
    }
    return null;
  }

  static String? validateTypeRequired<T>(T? value,
      {required BuildContext context,
      String? fieldName,
      bool isRequired = true}) {
    if (value == null && isRequired) {
      return '${fieldName ?? S.of(context).field} ${S.of(context).isrequired}';
    }
    return null;
  }

  static String? validateMinLength(String? value, int minLength,
      {String? fieldName, required BuildContext context}) {
    if (value == null || value.length < minLength) {
      return '${fieldName ?? S.of(context).field} ${S.of(context).mustbeatleast} $minLength ${S.of(context).characters}';
    }
    return null;
  }

  static String? validateMatch(String? value1, String? value2,
      {String? fieldName, required BuildContext context}) {
    if (value1 != value2) {
      return '${fieldName ?? S.of(context).field} ${S.of(context).donotmatch}';
    }
    return null;
  }

  static String? validateInteger(String? value,
      {bool validate = true,
      required BuildContext context,
      String? fieldName}) {
    if (validate) {
      if (value == null || value.trim().isEmpty) {
        return fieldName ?? S.of(context).fieldisrequired;
      }
      final integerRegex = RegExp(r'^\d+$');
      if (!integerRegex.hasMatch(value.trim())) {
        return S.of(context).enteravalidinteger;
      }
    } else {
      if (value != null && value.trim().isNotEmpty) {
        final integerRegex = RegExp(r'^\d+$');
        if (!integerRegex.hasMatch(value.trim())) {
          return S.of(context).enteravalidinteger;
        }
      }
    }

    return null;
  }

  static String? validateDouble(String? value,
      {bool validateEmpty = true, required BuildContext context}) {
    if (validateEmpty) {
      if (value == null || value.trim().isEmpty) {
        return S.of(context).fieldisrequired;
      }
    }

    if (value != null && value.trim().isNotEmpty) {
      final trimmedValue = value.trim();
      final doubleRegex = RegExp(
          r'^(\d+)?\.?\d+$'); // Matches integers and decimals like 12, 12.5, .5
      if (!doubleRegex.hasMatch(trimmedValue)) {
        return S
            .of(context)
            .enteravalidnumber; // or enteravaliddouble if you define it
      }

      final parsed = double.tryParse(trimmedValue);
      if (parsed == null) {
        return S.of(context).enteravalidnumber;
      }
    }

    return null;
  }

  static String? validateDoublePrice(String? value,
      {bool validateEmpty = true, required BuildContext context}) {
    if (validateEmpty) {
      if (value == null || value.trim().isEmpty) {
        return S.of(context).fieldisrequired; // "Field is required"
      }
      final doubleRegex =
          RegExp(r'^\d+(\.\d{1,2})?$'); // Allows up to 2 decimal places
      if (!doubleRegex.hasMatch(value.trim())) {
        return S.of(context).enteravalidprice; // "Enter a valid price"
      }
    } else {
      if (value != null && value.trim().isNotEmpty) {
        final doubleRegex = RegExp(r'^\d+(\.\d{1,2})?$');
        if (!doubleRegex.hasMatch(value.trim())) {
          return S.of(context).enteravalidprice;
        }
      }
    }

    return null;
  }

  static String? validatePercentage(String? value,
      {bool validateEmpty = true, required BuildContext context}) {
    if (validateEmpty) {
      if (value == null || value.trim().isEmpty) {
        return S.of(context).fieldisrequired;
      }
    }

    if (value != null && value.trim().isNotEmpty) {
      final trimmedValue = value.trim();
      final percentageRegex = RegExp(r'^\d+(\.\d+)?$');
      if (!percentageRegex.hasMatch(trimmedValue)) {
        return S.of(context).enteravalidpercentage;
      }

      final parsedValue = double.tryParse(trimmedValue);
      if (parsedValue == null || parsedValue < 0 || parsedValue > 100) {
        return "${S.of(context).enteravalidpercentage} ${S.of(context).between} 0 ${S.of(context).and} 100"; // Should say "Enter a value between 0 and 100"
      }
    }

    return null;
  }

  static String? validatePriceRange(String? value,
      {required BuildContext context}) {
    if (value == null || value.trim().isEmpty) {
      return null; // Allow empty input
    }

    final trimmed = value.trim();

    // Match format like: "123 - 45678.90" (with optional spaces)
    final rangeRegex =
        RegExp(r'^\s*([\d]+(?:\.\d+)?)\s*-\s*([\d]+(?:\.\d+)?)\s*$');
    final match = rangeRegex.firstMatch(trimmed);

    if (match == null) {
      return S.of(context).enteravalidnumber; // e.g. "Enter a valid number"
    }

    final start = double.tryParse(match.group(1)!);
    final end = double.tryParse(match.group(2)!);

    if (start == null || end == null) {
      return S.of(context).enteravalidnumber;
    }

    if (start > end) {
      return '${S.of(context).mustbeatleast} ${start.toStringAsFixed(2)} ${S.of(context).and} ${end.toStringAsFixed(2)}';
    }

    return null; // Valid input
  }

  static String? validateIntegerRange(String? value,
      {required BuildContext context}) {
    if (value == null || value.trim().isEmpty) {
      return null; // Accept empty input
    }

    final trimmed = value.trim();
    final rangeRegex = RegExp(r'^\s*(\d+)\s*-\s*(\d+)\s*$'); // e.g. "10 - 50"

    final match = rangeRegex.firstMatch(trimmed);

    if (match == null) {
      return S.of(context).enteravalidinteger; // Use: "Enter a valid integer"
    }

    final start = int.tryParse(match.group(1)!);
    final end = int.tryParse(match.group(2)!);

    if (start == null || end == null) {
      return S.of(context).enteravalidinteger;
    }

    if (start > end) {
      return '${S.of(context).mustbeatleast} $start ${S.of(context).and} $end';
    }

    return null; // Valid
  }

  String? validateDates(
      {bool notNeedValidate = true,
      required DateTime? startDate,
      required DateTime? endDate}) {
    if (notNeedValidate) {
      return null;
    }
    if (startDate == null || endDate == null) {
      return "Both start date and end date are required.";
    }

    if (startDate.isAfter(endDate)) {
      return "Start date cannot be after end date.";
    }

    return null; // null means valid (common in Flutter validators)
  }
}
