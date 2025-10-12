import 'package:flutter/material.dart';
import 'package:pos_app/core/helper/my_form_validators.dart';
import 'package:pos_app/core/utils/app_font_style.dart';
import 'package:pos_app/core/utils/app_padding.dart';
import 'package:pos_app/core/widget/custom_btn.dart';
import 'package:pos_app/core/widget/custom_drop_down.dart';
import 'package:pos_app/core/widget/custom_form_field.dart';
import 'package:pos_app/core/widget/custom_loading.dart';
import 'package:pos_app/features/discounts/data/model/discount_type.dart';
import 'package:pos_app/generated/l10n.dart';

class DiscountDataBuild extends StatelessWidget {
  const DiscountDataBuild(
      {super.key,
      required this.formKey,
      required this.autovalidateMode,
      required this.isLoading,
      required this.onPressed,
      required this.isEdit,
      required this.titleController,
      // required this.descriptionController,
      required this.value,
      this.discountType,
      required this.onChanged});

  final GlobalKey<FormState> formKey;
  final TextEditingController titleController;
  // final TextEditingController descriptionController;
  final TextEditingController value;
  final bool isLoading;
  final void Function() onPressed;
  final bool isEdit;
  final AutovalidateMode? autovalidateMode;
  final DiscountType? discountType;
  final void Function(DiscountType? value) onChanged;
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
                  controller: titleController,
                  labelText: S.of(context).title,
                  validator: (value) => MyFormValidators.validateRequired(
                    value,
                    context: context,
                  ),
                  keyboardType: TextInputType.name,
                ),
                SizedBox(
                  height: 20,
                ),
                CustomDropdown<DiscountType>(
                  hint: S.of(context).discountType,
                  compareFn: (discountType1, discountType2) {
                    return discountType1.name == discountType2.name;
                  },
                  validator: (DiscountType? value) =>
                      MyFormValidators.validateRequired(
                    value?.name,
                    context: context,
                  ),
                  value: discountType,
                  items: DiscountType.values,
                  onChanged: onChanged,
                  builder: (DiscountType? item) => Text(
                    item?.name ?? '',
                    style: AppFontStyle.formText(context: context),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                CustomFormField(
                  controller: value,
                  labelText: S.of(context).valueAsPercentage,
                  validator: (value) => MyFormValidators.validatePercentage(
                    value,
                    context: context,
                  ),
                  keyboardType: TextInputType.text,
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
