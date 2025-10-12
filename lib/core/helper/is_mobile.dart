import 'package:flutter/material.dart';
import 'package:pos_app/core/constant/device_size.dart';

bool isMobile({required BuildContext context}) {
  return MediaQuery.of(context).size.width < DeviceSize.tablet;
}
