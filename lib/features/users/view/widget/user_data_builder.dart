import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pos_app/core/constant/device_size.dart';
import 'package:pos_app/core/helper/my_form_validators.dart';
import 'package:pos_app/core/utils/app_colors.dart';
import 'package:pos_app/core/utils/app_font_style.dart';
import 'package:pos_app/core/utils/app_padding.dart';
import 'package:pos_app/core/widget/custom_btn.dart';
import 'package:pos_app/core/widget/custom_form_field.dart';
import 'package:pos_app/core/widget/custom_loading.dart';
import 'package:pos_app/core/widget/image_manager_view.dart';
import 'package:pos_app/features/auth/login/data/model/branche_model.dart';
import 'package:pos_app/features/auth/login/data/model/role_model.dart';
import 'package:pos_app/features/branch/view/widget/custom_drop_down_branch.dart';
import 'package:pos_app/features/permissions/view/widget/custom_drop_down_permission.dart';
import 'package:pos_app/generated/l10n.dart';

class UserDataBuilder extends StatelessWidget {
  const UserDataBuilder(
      {super.key,
      required this.formKey,
      required this.nameController,
      required this.emailController,
      required this.phoneController,
      required this.addressController,
      required this.passwordController,
      required this.isLoading,
      required this.onPressed,
      this.imageUrl,
      required this.onChangedPermission,
      required this.permission,
      required this.isEdit,
      required this.onSelectedImage,
      required this.autovalidateMode,
      required this.branche,
      required this.onChangedBranch,
      required this.onDeleteBranch});

  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  final TextEditingController passwordController;
  final bool isLoading;
  final void Function() onPressed;
  final void Function(RoleModel) onChangedPermission;
  final void Function(XFile) onSelectedImage;
  final bool isEdit;
  final String? imageUrl;
  final RoleModel? permission;
  final AutovalidateMode? autovalidateMode;
  final List<BrancheModel> branche;
  final void Function(BrancheModel?) onChangedBranch;
  final void Function(BrancheModel?) onDeleteBranch;

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
            ImageManagerView(
              onSelected: onSelectedImage,
              imageUrl: imageUrl,
            ),
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
              controller: emailController,
              labelText: S.of(context).email,
              keyboardType: TextInputType.emailAddress,
              validator: (value) =>
                  MyFormValidators.validateEmail(value, context: context),
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
              controller: addressController,
              labelText: S.of(context).address,
              keyboardType: TextInputType.streetAddress,
            ),
            SizedBox(
              height: 20,
            ),
            CustomFormField(
              controller: passwordController,
              labelText: S.of(context).password,
              validator: (value) => MyFormValidators.validatePassword(value,
                  validateEmpty: !isEdit, context: context),
              keyboardType: TextInputType.visiblePassword,
            ),
            SizedBox(
              height: 20,
            ),
            CustomDropDownPermission(
              permission: permission,
              onChangedPermission: onChangedPermission,
            ),
            SizedBox(
              height: 20,
            ),
            // CustomDropdown<BrancheModel>(
            //   hint: S.of(context).selectBranch,
            //   search: true,
            //   compareFn: (item1, item2) {
            //     if (item1.name == null ||
            //         item2.name == null ||
            //         item1.name!.isEmpty ||
            //         item2.name!.isEmpty) {
            //       return false;
            //     } else {
            //       return (item1.name!
            //               .toLowerCase()
            //               .contains(item2.name!.toLowerCase()) ||
            //           item2.name!
            //               .toLowerCase()
            //               .contains(item1.name!.toLowerCase()));
            //     }
            //   },
            //   value: null,
            //   items: CustomUserHiveBox.getUser().branches ?? [],
            //   filterFn: (item, filter) {
            //     return item.name!
            //         .toLowerCase()
            //         .contains(filter.toLowerCase());
            //   },
            //   onChanged: (BrancheModel? branch) {
            //     if (branch != null) {
            //       widget.onChangedBranch(branch);
            //     }
            //   },
            //   builder: (BrancheModel? branch) {
            //     if (branch != null) {
            //       return Text(
            //         branch.name ?? S.of(context).noName,
            //         style: AppFontStyle.formText(
            //           context: context,
            //         ),
            //       );
            //     } else {
            //       return SizedBox();
            //     }
            //   },
            // ),
            CustomDropDownBranch(value: null, onChanged: onChangedBranch),
            SizedBox(
              height: 20,
            ),
            branche.isEmpty
                ? const SizedBox()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Text(
                          S.of(context).branches,
                          style: AppFontStyle.formText(
                            context: context,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        GridView.builder(
                          shrinkWrap: true,
                          itemCount: branche.length,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:
                                (DeviceSize.getWidth(context: context) / 500)
                                    .floor()
                                    .clamp(1, 5),
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 5,
                            mainAxisExtent:
                                (DeviceSize.getHeight(context: context) * 0.05)
                                    .clamp(50, 200),
                          ),
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(
                                branche[index].name ?? '',
                                style: AppFontStyle.formText(
                                  context: context,
                                ),
                              ),
                              trailing: IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: AppColors.error,
                                  size: min(
                                    MediaQuery.sizeOf(context).height * 0.025,
                                    MediaQuery.sizeOf(context).width * 0.025,
                                  ).clamp(25, 40),
                                ),
                                onPressed: () {
                                  onDeleteBranch(branche[index]);
                                },
                              ),
                            );
                          },
                        )
                      ]),
            SizedBox(
              height: 20,
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
