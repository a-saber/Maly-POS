import 'package:flutter/widgets.dart';
import 'package:pos_app/core/constant/device_size.dart';
import 'package:pos_app/core/helper/is_mobile.dart';

class CustomLayoutBuilder extends StatelessWidget {
  const CustomLayoutBuilder({
    super.key,
    required this.mobile,
    required this.tablet,
    required this.desktop,
  });

  final Widget mobile, tablet, desktop;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth;

        if (isMobile(context: context)) {
          return mobile;
        } else if (width < DeviceSize.desktop) {
          return tablet;
        } else {
          return desktop;
        }
      },
    );
  }
}
