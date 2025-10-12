import 'package:flutter/material.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:pos_app/core/utils/app_colors.dart';
import 'package:pos_app/core/utils/app_font_style.dart';

// ignore: constant_identifier_names
enum PopUpState { SUCCESS, ERROR, WARNING }

class CustomPopUp {
  static callMyPopUp(
      {required context, required String massage, required PopUpState state}) {
    callMyToast(context: context, massage: massage, state: state);
  }

  static Color choosePopUpColor(PopUpState state) {
    Color color;
    switch (state) {
      case PopUpState.SUCCESS:
        color = AppColors.success;
        break;
      case PopUpState.ERROR:
        color = AppColors.error;
        break;
      case PopUpState.WARNING:
        color = AppColors.warning;
        break;
    }
    return color;
  }

  static void callMyToast({
    required context,
    required String massage,
    required PopUpState state,
  }) =>
      FlutterToastr.show(
        massage,
        context,
        duration: 3,
        textStyle: TextStyle(
          color: Colors.white,
          fontSize: 16.0,
        ),
        // gravity: ToastGravity.BOTTOM,
        // timeInSecForIosWeb: 3,
        backgroundColor: choosePopUpColor(state),
      );

  static void callMySnackBar(
      {required context,
      required String text,
      PopUpState? state,
      Color? backgroundColor = AppColors.grey,
      Color textColor = AppColors.white}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor:
            state != null ? choosePopUpColor(state) : backgroundColor,
        content: Text(
          text,
          style: AppFontStyle.btnText(color: textColor, context: context)
              .copyWith(fontSize: 16),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
