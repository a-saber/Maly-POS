import 'package:flutter/material.dart';
import 'package:pos_app/core/utils/app_colors.dart';

class CustomObscureSuffixIcon extends StatelessWidget {
  const CustomObscureSuffixIcon(
      {super.key, required this.isObscure, required this.onPressed});

  final bool isObscure;
  final void Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: onPressed,
        icon: Icon(
          isObscure ? Icons.lock_outline_rounded : Icons.lock_open_rounded,
          color: AppColors.primary,
        ));
  }
}
