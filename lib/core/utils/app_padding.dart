import 'package:flutter/material.dart';

class AppPaddingSizes {
  static const double defaultViewH = 20.0;
  static const double defaultViewV = 20.0;
}

class AppPaddings {
  static const EdgeInsetsDirectional defaultView =
      EdgeInsetsDirectional.symmetric(
    horizontal: AppPaddingSizes.defaultViewH,
    vertical: AppPaddingSizes.defaultViewV,
  );
}
