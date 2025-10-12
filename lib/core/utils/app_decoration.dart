import 'package:flutter/material.dart';
import 'package:pos_app/core/utils/app_boarder_raduis.dart';
import 'package:pos_app/core/utils/app_colors.dart';
import 'package:pos_app/core/utils/app_font_style.dart';

abstract class AppDecoration {
  static InputDecoration inputDecoration(
          {String? labelText,
          Widget? prefixIcon,
          Widget? suffixIcon,
          String? hintText,
          // Widget? prefix,
          required BuildContext context}) =>
      InputDecoration(
        // prefix: prefixIcon,
        hintText: hintText,
        hintStyle: AppFontStyle.hintText(context),
        labelText: labelText,
        labelStyle:
            AppFontStyle.formText(color: AppColors.grey, context: context),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        border: outlineinputborder(
          boarderSideColor: AppColors.grey,
        ),
        enabledBorder: outlineinputborder(boarderSideColor: AppColors.grey),
        focusedBorder: outlineinputborder(
          boarderSideColor: AppColors.primary,
        ),
        errorBorder: outlineinputborder(
          boarderSideColor: AppColors.error,
        ),
        focusedErrorBorder: outlineinputborder(
          boarderSideColor: AppColors.primary,
        ),
        contentPadding:
            const EdgeInsetsDirectional.only(start: 16, top: 10, bottom: 10),
      );

  static OutlineInputBorder outlineinputborder({
    required Color boarderSideColor,
  }) {
    return OutlineInputBorder(
      borderRadius: AppBordersRaduis.form,
      borderSide: BorderSide(color: boarderSideColor),
    );
  }
}
