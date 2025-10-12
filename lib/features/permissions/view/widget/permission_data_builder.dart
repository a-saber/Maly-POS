import 'package:flutter/material.dart';
import 'package:pos_app/core/helper/my_form_validators.dart';
import 'package:pos_app/core/utils/app_padding.dart';
import 'package:pos_app/core/widget/custom_btn.dart';
import 'package:pos_app/core/widget/custom_checkbox.dart';
import 'package:pos_app/core/widget/custom_form_field.dart';
import 'package:pos_app/core/widget/custom_loading.dart';
import 'package:pos_app/features/permissions/data/model/permission_model.dart';
import 'package:pos_app/generated/l10n.dart';

class PermissionDataBuilder extends StatelessWidget {
  const PermissionDataBuilder(
      {super.key,
      required this.formKey,
      required this.autovalidateMode,
      required this.nameController,
      required this.descriptionController,
      required this.isLoading,
      required this.onPressed,
      required this.onChanged,
      required this.isEdit,
      required this.permissionItems});

  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final bool isLoading;
  final void Function() onPressed;

  final List<PermissionItemModel> permissionItems;
  final void Function(bool, int) onChanged;
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
                CustomFormField(
                  controller: descriptionController,
                  labelText: S.of(context).description,
                  keyboardType: TextInputType.text,
                ),
                SizedBox(
                  height: 20,
                ),
                ListView.separated(
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 20,
                  ),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: permissionItems.length,
                  itemBuilder: (context, index) {
                    return CustomCheckbox(
                        title: permissionItems[index].name ?? '-',
                        value: permissionItems[index].isSelected,
                        onChanged: (bool? value) {
                          if (value != null) {
                            onChanged(value, index);
                          }
                        });
                  },
                ),
              ],
            ),
            Builder(builder: (context) {
              if (isLoading) {
                return const CustomLoading();
              }
              return CustomFilledBtn(
                  text: isEdit ? S.of(context).edit : S.of(context).add,
                  onPressed: onPressed);
            }),
          ],
        ),
      ),
    );
  }
}
