import 'package:flutter/material.dart';
import 'package:pos_app/core/utils/app_decoration.dart';
import 'package:pos_app/core/utils/app_font_style.dart';

class CustomFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final void Function(String)? onFieldSubmitted;
  final String? hintText;
  final void Function(String)? onChanged;
  final bool? enabled;
  final String? initialValue;

  const CustomFormField({
    super.key,
    this.controller,
    this.labelText,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.onFieldSubmitted,
    this.hintText,
    this.onChanged,
    this.enabled,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      enabled: enabled,
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      obscuringCharacter: '●',
      validator: validator,
      onFieldSubmitted: onFieldSubmitted,
      onChanged: onChanged,
      style: AppFontStyle.formText(
        context: context,
      ),
      decoration: AppDecoration.inputDecoration(
        context: context,
        labelText: labelText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        hintText: hintText,
      ),
    );
  }
}
