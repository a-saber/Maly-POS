import 'package:flutter/material.dart';

class HomeViewItemModel {
  final Color color;
  final String pageRoute;
  final IconData icon;
  final String title;
  final bool canAccess;

  HomeViewItemModel(
      {required this.color,
      required this.pageRoute,
      required this.icon,
      required this.title,
      this.canAccess = false});
}
