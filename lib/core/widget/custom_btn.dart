import 'package:flutter/material.dart';
import 'package:pos_app/core/utils/app_colors.dart';
import 'package:pos_app/core/utils/app_font_style.dart';

class CustomFilledBtn extends StatelessWidget {
  const CustomFilledBtn({
    super.key,
    required this.text,
    this.icon,
    required this.onPressed,
    this.expandWidth = true,
    this.backgroundColor = AppColors.primary,
  });

  final String text;
  final Widget? icon;
  final void Function() onPressed;
  final bool expandWidth;
  final Color backgroundColor;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: expandWidth ? double.infinity : null,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            backgroundColor: backgroundColor,
            padding:
                const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
          ),
          onPressed: onPressed,
          child: icon == null
              ? Text(
                  text,
                  style: AppFontStyle.btnText(context: context),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.only(end: 8.0),
                      child: icon,
                    ),
                    Text(
                      text,
                      style: AppFontStyle.btnText(
                        context: context,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                )),
    );
  }
}

class CustomTextBtn extends StatelessWidget {
  const CustomTextBtn({
    super.key,
    required this.text,
    this.icon,
    required this.onPressed,
    this.style,
  });

  final String text;
  final Widget? icon;
  final void Function() onPressed;
  final TextStyle? style;
  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onPressed,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (icon != null)
                Padding(
                  padding: const EdgeInsetsDirectional.only(end: 8.0),
                  child: icon,
                ),
              Text(
                text,
                style: style ??
                    AppFontStyle.deleteBtnText(
                      context: context,
                    ),
              ),
            ],
          ),
        ));
  }
}
