import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pos_app/core/helper/my_form_validators.dart';
import 'package:pos_app/core/utils/app_padding.dart';
import 'package:pos_app/core/widget/custom_btn.dart';
import 'package:pos_app/core/widget/custom_form_field.dart';
import 'package:pos_app/core/widget/custom_loading.dart';
import 'package:pos_app/core/widget/image_manager_view.dart';
import 'package:pos_app/generated/l10n.dart';

class CategoryDataBuilder extends StatelessWidget {
  const CategoryDataBuilder(
      {super.key,
      required this.formKey,
      required this.nameController,
      required this.descriptionController,
      this.imageUrl,
      required this.onTap,
      required this.onSelected,
      required this.isLoading,
      required this.isEdit,
      this.autovalidateMode});

  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final String? imageUrl;
  final void Function() onTap;
  final void Function(XFile) onSelected;
  final bool isLoading;
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ImageManagerView(onSelected: onSelected, imageUrl: imageUrl),
            SizedBox(
              height: 20,
            ),
            CustomFormField(
              controller: nameController,
              labelText: S.of(context).name,
              validator: (value) =>
                  MyFormValidators.validateRequired(value, context: context),
              keyboardType: TextInputType.name,
            ),
            SizedBox(
              height: 20,
            ),
            CustomFormField(
              controller: descriptionController,
              labelText: S.of(context).description,
            ),
            SizedBox(
              height: 20,
            ),
            Builder(builder: (context) {
              if (isLoading) {
                return const CustomLoading();
              }
              return CustomFilledBtn(
                  text: isEdit ? S.of(context).edit : S.of(context).add,
                  onPressed: onTap);
            })
          ],
        ),
      ),
    );
  }
}
