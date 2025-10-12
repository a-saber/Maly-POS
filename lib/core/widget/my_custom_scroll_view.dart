import 'package:flutter/material.dart';

class MyCustomScrollView extends StatelessWidget {
  const MyCustomScrollView({
    super.key,
    required this.child,
    this.physics,
    this.scrollDirection = Axis.vertical,
    this.controller,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
  });

  final Widget child;
  final ScrollPhysics? physics;
  final Axis scrollDirection;
  final ScrollController? controller;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      keyboardDismissBehavior: keyboardDismissBehavior,
      physics: physics,
      scrollDirection: scrollDirection,
      controller: controller,
      child: child,
    );
  }
}
