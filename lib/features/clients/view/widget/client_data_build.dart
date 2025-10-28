import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pos_app/core/helper/my_form_validators.dart';
import 'package:pos_app/core/utils/app_padding.dart';
import 'package:pos_app/core/widget/custom_btn.dart';
import 'package:pos_app/core/widget/custom_form_field.dart';
import 'package:pos_app/core/widget/custom_loading.dart';
import 'package:pos_app/generated/l10n.dart';

class ClientDataBuilder extends StatelessWidget {
  const ClientDataBuilder({
    super.key,
    required this.formKey,
    required this.autovalidateMode,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.addressController,
    required this.streetController,
    required this.buildingController,
    required this.cityController,
    required this.districtController,
    required this.countryController,
    required this.isLoading,
    required this.onPressed,
    required this.isEdit,
    this.imageUrl,
    required this.onSelectedImage,
    // required this.commercialRegisterController,
    // required this.taxIdentificationNumberController,
    // required this.noteController
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  final TextEditingController streetController;
  final TextEditingController buildingController; // building number
  final TextEditingController cityController;
  final TextEditingController districtController;
  final TextEditingController countryController;
  // final TextEditingController commercialRegisterController;
  // final TextEditingController taxIdentificationNumberController;
  // final TextEditingController noteController;

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
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ImageManagerView(
                //     onSelected: onSelectedImage, imageUrl: imageUrl),
                SizedBox(
                  height: 10,
                ),
                CustomFormField(
                  controller: nameController,
                  labelText: S.of(context).name,
                  validator: (value) => MyFormValidators.validateRequired(value,
                      context: context),
                  keyboardType: TextInputType.name,
                ),
                SizedBox(
                  height: 20,
                ),
                CustomFormField(
                  controller: phoneController,
                  labelText: S.of(context).phone,
                  keyboardType: TextInputType.phone,
                  validator: (value) =>
                      MyFormValidators.validatePhone(value, context: context),
                ),
                SizedBox(
                  height: 20,
                ),
                CustomFormField(
                  controller: emailController,
                  labelText: S.of(context).email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (String? value) => MyFormValidators.validateEmail(
                    value,
                    validateEmpty: false,
                    context: context,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                CustomFormField(
                  controller: addressController,
                  labelText: S.of(context).address,
                  keyboardType: TextInputType.streetAddress,
                  validator: (value) => MyFormValidators.validateRequired(value,
                      context: context),
                ),
                SizedBox(
                  height: 20,
                ),
                 CustomFormField(
                  controller: streetController,
                  labelText: S.of(context).street,
                  keyboardType: TextInputType.streetAddress,
                  validator: (value) => MyFormValidators.validateRequired(value,
                      context: context),
                ),
                SizedBox(
                  height: 20,
                ),
                CustomFormField(
                  controller: buildingController,
                  labelText: S.of(context).building,
                  keyboardType: TextInputType.streetAddress,
                  validator: (value) => MyFormValidators.validateRequired(value,
                      context: context),
                ),
                SizedBox(
                  height: 20,
                ),
                CustomFormField(
                  controller: cityController,
                  labelText: S.of(context).city,
                  keyboardType: TextInputType.streetAddress,
                  validator: (value) => MyFormValidators.validateRequired(value,
                      context: context),
                ),
                SizedBox(
                  height: 20,
                ),
                CustomFormField(
                  controller: districtController,
                  labelText: S.of(context).district,
                  keyboardType: TextInputType.streetAddress,
                  validator: (value) => MyFormValidators.validateRequired(value,
                      context: context),
                ),
                SizedBox(
                  height: 20,
                ),
                CustomFormField(
                  controller: countryController,
                  labelText: S.of(context).country,
                  keyboardType: TextInputType.streetAddress,
                  validator: (value) => MyFormValidators.validateRequired(value,
                      context: context),
                ),
                // SizedBox(
                //   height: 20,
                // ),
                // CustomFormField(
                //   controller: commercialRegisterController,
                //   labelText: S.of(context).commercialRegister,
                //   validator: (String? value) =>
                //       MyFormValidators.validateInteger(value,
                //           validateEmpty: false, context: context),
                //   keyboardType: TextInputType.number,
                // ),
                // SizedBox(
                //   height: 20,
                // ),
                // CustomFormField(
                //   controller: taxIdentificationNumberController,
                //   labelText: S.of(context).taxIdentificationNumber,
                //   keyboardType: TextInputType.number,
                //   validator: (String? value) =>
                //       MyFormValidators.validateInteger(value,
                //           validateEmpty: false, context: context),
                // ),
                // SizedBox(
                //   height: 20,
                // ),
                // CustomFormField(
                //   controller: noteController,
                //   labelText: S.of(context).note,
                //   keyboardType: TextInputType.text,
                // ),
                SizedBox(
                  height: 50,
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
