import 'package:flutter/material.dart';
import 'package:pos_app/core/utils/app_colors.dart';

class CustomRefreshIndicator extends StatelessWidget {
  const CustomRefreshIndicator(
      {super.key,
      required this.child,
      required this.onRefresh,
      this.notificationPredicate = defaultScrollNotificationPredicate});

  final Widget child;
  final Future<void> Function() onRefresh;
  final bool Function(ScrollNotification) notificationPredicate;
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      notificationPredicate: notificationPredicate,
      backgroundColor: AppColors.white,
      color: AppColors.primary,
      onRefresh: onRefresh,
      child: child,
    );
  }
}
