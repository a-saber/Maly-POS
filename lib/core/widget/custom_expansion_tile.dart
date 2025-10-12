import 'package:flutter/material.dart';

class CustomExpansionTile extends StatelessWidget {
  const CustomExpansionTile({
    super.key,
    required this.title,
    this.children = const <Widget>[],
    this.subTitle,
    this.initiallyExpanded = false,
  });
  final Widget title;
  final Widget? subTitle;
  final List<Widget> children;
  final bool initiallyExpanded;
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Colors.transparent,
        ),
      ),
      initiallyExpanded: initiallyExpanded,
      title: title,
      subtitle: subTitle,
      children: children,
    );
  }
}
