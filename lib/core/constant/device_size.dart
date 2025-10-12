import 'package:flutter/material.dart';

class DeviceSize {
  static const double desktop = 1200;
  static const double tablet = 800;

  static double getHeight({required BuildContext context}) {
    Orientation orientation = MediaQuery.of(context).orientation;
    if (orientation == Orientation.portrait) {
      return MediaQuery.of(context).size.height;
    } else {
      return MediaQuery.of(context).size.width;
    }
  }

  static double getWidth({required BuildContext context}) {
    Orientation orientation = MediaQuery.of(context).orientation;
    if (orientation == Orientation.portrait) {
      return MediaQuery.of(context).size.width;
    } else {
      return MediaQuery.of(context).size.height;
    }
  }
}
