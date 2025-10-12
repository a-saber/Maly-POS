import 'package:flutter/material.dart';
import 'package:pos_app/core/utils/app_colors.dart';
import 'package:pos_app/core/utils/app_font_style.dart';

class CustomInfoRowDetailsView extends StatelessWidget {
  const CustomInfoRowDetailsView({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppFontStyle.itemsSubTitle(
              context: context,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: AppFontStyle.itemsSubTitle(
                context: context,
                fontWeight: FontWeight.w400,
                color: AppColors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomBuildSectionDeatilsView extends StatelessWidget {
  const CustomBuildSectionDeatilsView({
    super.key,
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppFontStyle.itemsTitle(
                  context: context, color: Colors.black),
            ),
            const Divider(),
            ...children,
          ],
        ),
      ),
    );
  }
}
