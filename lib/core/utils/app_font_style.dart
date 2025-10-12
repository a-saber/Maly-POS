import 'package:flutter/widgets.dart';
import 'package:pos_app/core/constant/device_size.dart';
import 'package:pos_app/core/constant/font_weights.dart';
import 'package:pos_app/core/utils/app_colors.dart';
import 'package:pos_app/core/utils/app_font.dart';

class AppFontStyle {
  static TextStyle appBarTitle({required BuildContext context}) => TextStyle(
        fontWeight: FontWeights.semiBold,
        fontSize: getResponsiveSize(context, size: 25),
        color: AppColors.black,
        fontFamily: AppFont.cairo,
      );
  static TextStyle appBarTitleSmall({required BuildContext context}) =>
      TextStyle(
        fontWeight: FontWeights.semiBold,
        fontSize: getResponsiveSize(context, size: 20),
        color: AppColors.black,
        fontFamily: AppFont.cairo,
      );
  static TextStyle authTitle({required BuildContext context, double? height}) =>
      TextStyle(
        fontWeight: FontWeights.bold,
        fontSize: getResponsiveSize(context, size: 30),
        color: AppColors.black,
        height: height,
      );
  static TextStyle formText(
          {Color color = AppColors.black, required BuildContext context}) =>
      TextStyle(
        fontWeight: FontWeights.medium,
        fontSize: getResponsiveSize(context, size: 18),
        color: color,
      );
  static TextStyle dropDown(
          {Color color = AppColors.black, required BuildContext context}) =>
      TextStyle(
        fontWeight: FontWeights.medium,
        fontSize: getResponsiveSize(context, size: 12),
        color: color,
      );
  static TextStyle s12(
          {Color color = AppColors.black,
          required BuildContext context,
          FontWeight? fontWeight}) =>
      TextStyle(
        fontWeight: FontWeights.medium,
        fontSize: getResponsiveSize(context, size: 12),
        color: color,
      );
  static TextStyle s8(
          {Color color = AppColors.black,
          required BuildContext context,
          FontWeight? fontWeight}) =>
      TextStyle(
        fontWeight: FontWeights.medium,
        fontSize: getResponsiveSize(context, size: 8),
        color: color,
      );
  static TextStyle s10(
          {Color color = AppColors.black,
          required BuildContext context,
          FontWeight? fontWeight}) =>
      TextStyle(
        fontWeight: FontWeights.medium,
        fontSize: getResponsiveSize(context, size: 10),
        color: color,
      );

  static TextStyle btnText(
          {Color color = AppColors.white, required BuildContext context}) =>
      TextStyle(
        fontWeight: FontWeights.medium,
        fontSize: getResponsiveSize(context, size: 20),
        color: color,
      );

  static TextStyle deleteBtnText(
          {Color color = AppColors.error, required BuildContext context}) =>
      TextStyle(
        fontWeight: FontWeights.medium,
        fontSize: getResponsiveSize(context, size: 15),
        color: color,
      );

  static TextStyle itemsTitle(
          {Color color = AppColors.white, required BuildContext context}) =>
      TextStyle(
        fontWeight: FontWeights.medium,
        fontSize: getResponsiveSize(context, size: 18),
        color: color,
      );
  static TextStyle itemssmallTitle(
          {Color color = AppColors.white,
          required BuildContext context,
          FontWeight? fontWeight}) =>
      TextStyle(
        fontWeight: fontWeight ?? FontWeights.regular,
        fontSize: getResponsiveSize(context, size: 14),
        color: color,
      );

  static TextStyle itemsSubTitle(
          {Color color = AppColors.white,
          required BuildContext context,
          FontWeight? fontWeight}) =>
      TextStyle(
        fontSize: getResponsiveSize(context, size: 16),
        color: color,
        fontWeight: fontWeight ?? FontWeights.medium,
      );

  static TextStyle errorText(BuildContext context) => TextStyle(
        fontWeight: FontWeights.medium,
        fontSize: getResponsiveSize(context, size: 16),
        color: AppColors.error,
      );

  static TextStyle hintText(BuildContext context) => TextStyle(
        fontWeight: FontWeights.medium,
        fontSize: getResponsiveSize(context, size: 17),
        color: AppColors.grey,
      );
}

double getResponsiveSize(context, {required double size}) {
  double scaleFactor = getScaleFactor(context);
  double responsiveSize = size * scaleFactor;

  double lowerLimit = size * .8;
  double upperLimit = size * 1.2;

  return MediaQuery.of(context)
      .textScaler
      .scale(responsiveSize.clamp(lowerLimit, upperLimit));
}

double getScaleFactor(context) {
  // var dispatcher = PlatformDispatcher.instance;
  // var physicalWidth = dispatcher.views.first.physicalSize.width;
  // var devicePixelRatio = dispatcher.views.first.devicePixelRatio;
  // double width = physicalWidth / devicePixelRatio;

  double width = MediaQuery.sizeOf(context).width;
  if (width < DeviceSize.tablet) {
    return width / 600;
  } else if (width < DeviceSize.desktop) {
    return width / 1200;
  } else {
    return width / 1920;
  }
}

class FontSize {
  static double fs18(context) => getResponsiveSize(context, size: 18);
}
