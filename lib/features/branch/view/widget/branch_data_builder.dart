import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pos_app/core/helper/my_form_validators.dart';
import 'package:pos_app/core/utils/app_padding.dart';
import 'package:pos_app/core/widget/custom_btn.dart';
import 'package:pos_app/core/widget/custom_form_field.dart';
import 'package:pos_app/core/widget/custom_loading.dart';
import 'package:pos_app/generated/l10n.dart';

class BranchDataBuilder extends StatelessWidget {
  const BranchDataBuilder(
      {super.key,
      required this.formKey,
      required this.nameController,
      required this.addressController,
      required this.isLoading,
      required this.onPressed,
      this.imageUrl,
      required this.isEdit,
      required this.onSelectedImage,
      required this.autovalidateMode,
      required this.phoneController,
      required this.emailController});

  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController addressController;
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final bool isLoading;
  final void Function() onPressed;
  final void Function(XFile) onSelectedImage;
  final bool isEdit;
  final String? imageUrl;
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
            // ImageManagerView(
            //   onSelected: onSelectedImage,
            //   imageUrl: imageUrl,
            // ),
            SizedBox(
              height: 10,
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
              controller: phoneController,
              labelText: S.of(context).phone,
              validator: (value) => MyFormValidators.validatePhone(value,
                  context: context, validateEmpty: false),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(
              height: 20,
            ),
            CustomFormField(
              controller: addressController,
              labelText: S.of(context).address,
              keyboardType: TextInputType.streetAddress,
            ),
            SizedBox(
              height: 20,
            ),
            CustomFormField(
              controller: emailController,
              labelText: S.of(context).email,
              validator: (value) => MyFormValidators.validateEmail(value,
                  context: context, validateEmpty: false),
              keyboardType: TextInputType.emailAddress,
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
                onPressed: onPressed,
              );
            }),
          ],
        ),
      ),
    );
  }
}
