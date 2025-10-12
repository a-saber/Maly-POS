import 'package:flutter/material.dart';
import 'package:pos_app/core/utils/app_colors.dart';
import 'package:pos_app/core/utils/app_font_style.dart';

class CustomCheckbox extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool?> onChanged;

  const CustomCheckbox({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      checkColor: AppColors.black,
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: AppFontStyle.formText(color: AppColors.black, context: context),
      ),
      value: value,
      onChanged: onChanged,
      activeColor: AppColors.yellow,
    );
  }
}
