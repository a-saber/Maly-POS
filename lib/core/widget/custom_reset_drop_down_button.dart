import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pos_app/core/utils/app_colors.dart';

class CustomResetDropDownButton extends StatelessWidget {
  const CustomResetDropDownButton({
    super.key,
    this.onPressed,
  });
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        Icons.clear,
        color: AppColors.error,
        size: min(
          MediaQuery.of(context).size.width * 0.03,
          MediaQuery.of(context).size.height * 0.03,
        ).clamp(
          20,
          50,
        ),
      ),
    );
  }
}
