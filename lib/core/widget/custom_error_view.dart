import 'package:flutter/material.dart';
import 'package:pos_app/core/utils/app_font_style.dart';
import 'package:pos_app/core/widget/custom_btn.dart';
import 'package:pos_app/generated/l10n.dart';

class CustomError extends StatelessWidget {
  const CustomError(
      {super.key,
      required this.error,
      required this.onPressed,
      this.row = false});

  final void Function() onPressed;
  final String error;
  final bool row;
  @override
  Widget build(BuildContext context) {
    return Center(
        child: row
            ? Row(
                textDirection: TextDirection.rtl,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    error,
                    textAlign: TextAlign.center,
                    style: AppFontStyle.errorText(context),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  CustomFilledBtn(
                    expandWidth: false,
                    text: S.of(context).refresh,
                    onPressed: onPressed,
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    error,
                    textAlign: TextAlign.center,
                    style: AppFontStyle.errorText(context),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomFilledBtn(
                    expandWidth: false,
                    text: S.of(context).refresh,
                    onPressed: onPressed,
                  )
                ],
              ));
  }
}
