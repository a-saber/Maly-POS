import 'package:flutter/material.dart';
import 'package:pos_app/core/utils/app_colors.dart';

class CustomFloatingActionBtn extends StatelessWidget {
  const CustomFloatingActionBtn({super.key, required this.onPressed});

  final void Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      //shape: CircleBorder(),
      onPressed: onPressed,
      backgroundColor: AppColors.primary,
      child: const Icon(
        Icons.add,
        color: AppColors.white,
        size: 30,
      ),
    );
  }
}
