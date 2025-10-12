import 'package:flutter/material.dart';
import 'package:pos_app/core/helper/my_form_validators.dart';
import 'package:pos_app/core/utils/app_padding.dart';
import 'package:pos_app/core/widget/custom_btn.dart';
import 'package:pos_app/core/widget/custom_form_field.dart';
import 'package:pos_app/core/widget/custom_loading.dart';
import 'package:pos_app/generated/l10n.dart';

class UnitDataBuild extends StatelessWidget {
  const UnitDataBuild(
      {super.key,
      required this.formKey,
      required this.autovalidateMode,
      required this.nameController,
      required this.isLoading,
      required this.onPressed,
      required this.isEdit});

  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;

  final bool isLoading;
  final void Function() onPressed;
  final bool isEdit;
  final AutovalidateMode? autovalidateMode;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode: autovalidateMode,
      child: Padding(
        padding: AppPaddings.defaultView,
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 10,
                ),
                CustomFormField(
                  controller: nameController,
                  labelText: S.of(context).name,
                  validator: (value) => MyFormValidators.validateRequired(
                    value,
                    context: context,
                  ),
                  keyboardType: TextInputType.name,
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
            Builder(
              builder: (context) {
                if (isLoading) {
                  return const CustomLoading();
                }
                return CustomFilledBtn(
                  text: isEdit ? S.of(context).edit : S.of(context).add,
                  onPressed: onPressed,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
