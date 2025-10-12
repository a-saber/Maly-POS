import 'package:flutter/material.dart';
import 'package:pos_app/core/utils/app_colors.dart';
import 'package:pos_app/core/utils/app_font_style.dart';
import 'package:pos_app/core/widget/custom_btn.dart';
import 'package:pos_app/generated/l10n.dart';

class CustomEmptyView extends StatelessWidget {
  const CustomEmptyView({super.key, required this.onPressed, this.row = false});
  final void Function() onPressed;
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
                    S.of(context).youHaveNoData,
                    style: AppFontStyle.errorText(context).copyWith(
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  CustomFilledBtn(
                      expandWidth: false,
                      text: S.of(context).refresh,
                      onPressed: onPressed)
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    S.of(context).youHaveNoData,
                    style: AppFontStyle.errorText(context).copyWith(
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  CustomFilledBtn(
                      expandWidth: false,
                      text: S.of(context).refresh,
                      onPressed: onPressed)
                ],
              ));
  }
}
