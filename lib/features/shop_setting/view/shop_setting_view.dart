import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/core/helper/my_form_validators.dart';
import 'package:pos_app/core/utils/app_padding.dart';
import 'package:pos_app/core/widget/custom_app_bar.dart';
import 'package:pos_app/core/widget/custom_btn.dart';
import 'package:pos_app/core/widget/custom_form_field.dart';
import 'package:pos_app/core/widget/custom_loading.dart';
import 'package:pos_app/core/widget/custom_pop_up.dart';
import 'package:pos_app/core/widget/cutsom_layout_builder.dart';
import 'package:pos_app/core/widget/image_manager_view.dart';
import 'package:pos_app/core/widget/my_custom_scroll_view.dart';
import 'package:pos_app/features/shop_setting/manager/cubit/shop_setting_cubit.dart';
import 'package:pos_app/generated/l10n.dart';

class ShopSettingView extends StatelessWidget {
  const ShopSettingView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopSettingCubit, ShopSettingState>(
      listener: (context, state) {
        if (state is ShopSettingUpdateFailing) {
          if (context.mounted) {
            CustomPopUp.callMyToast(
              context: context,
              massage: mapStatusCodeToMessage(context, state.errMessage),
              state: PopUpState.ERROR,
            );
          }
        }
        if (state is ShopSettingUpdateSuccess) {
          CustomPopUp.callMyToast(
            context: context,
            massage: S.of(context).updatedSuccess,
            state: PopUpState.SUCCESS,
          );
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: CustomAppBar(
            title: S.of(context).shopSetting,
          ),
          body: SafeArea(
            child: CustomLayoutBuilder(
              mobile: Padding(
                padding: AppPaddings.defaultView,
                child: MyCustomScrollView(
                  child: CustomShopSettingBodyMobile(
                    state: state,
                  ),
                ),
              ),
              tablet: MyCustomScrollView(
                child: CustomShopSettingBodyTabletAndDesktop(
                  state: state,
                ),
              ),
              desktop: MyCustomScrollView(
                child: CustomShopSettingBodyTabletAndDesktop(
                  state: state,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class CustomShopSettingBodyMobile extends StatelessWidget {
  const CustomShopSettingBodyMobile({
    super.key,
    required this.state,
  });
  final ShopSettingState state;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: ShopSettingCubit.get(context).formKey,
      autovalidateMode: ShopSettingCubit.get(context).autovalidateMode,
      child: Column(
        spacing: 20,
        children: [
          ImageManagerView(
            onSelected: ShopSettingCubit.get(context).onChangeImage,
            imageUrl: ShopSettingCubit.get(context).imageUrl,
          ),
          CustomFormField(
            controller: ShopSettingCubit.get(context).shopNameController,
            validator: (value) => MyFormValidators.validateRequired(
              value,
              context: context,
              fieldName: S.of(context).shopName,
            ),
            hintText: S.of(context).shopName,
            labelText: S.of(context).shopName,
            keyboardType: TextInputType.name,
          ),
          CustomFormField(
            controller: ShopSettingCubit.get(context).addressController,
            hintText: S.of(context).address,
            labelText: S.of(context).address,
            keyboardType: TextInputType.streetAddress,
          ),
          CustomFormField(
            controller: ShopSettingCubit.get(context).postalCodeController,
            hintText: S.of(context).postalCode,
            labelText: S.of(context).postalCode,
            validator: (value) => MyFormValidators.validateInteger(value,
                context: context, validate: false),
            keyboardType: TextInputType.number,
          ),
          CustomFormField(
            controller: ShopSettingCubit.get(context).taxNoController,
            hintText: S.of(context).taxNo,
            labelText: S.of(context).taxNo,
            validator: (value) => MyFormValidators.validateInteger(value,
                context: context, validate: false),
            keyboardType: TextInputType.number,
          ),
          CustomFormField(
            controller: ShopSettingCubit.get(context).commercialNoController,
            hintText: S.of(context).commercialNo,
            labelText: S.of(context).commercialNo,
            validator: (value) => MyFormValidators.validateInteger(value,
                context: context, validate: false),
            keyboardType: TextInputType.number,
          ),
          CustomFormField(
            controller: ShopSettingCubit.get(context).phoneController,
            hintText: S.of(context).phone,
            labelText: S.of(context).phone,
            validator: (value) => MyFormValidators.validateInteger(
              value,
              context: context,
              validate: false,
            ),
            keyboardType: TextInputType.number,
          ),
          CustomFormField(
            controller: ShopSettingCubit.get(context).emailController,
            hintText: S.of(context).email,
            labelText: S.of(context).email,
            validator: (value) => MyFormValidators.validateEmail(
              value,
              context: context,
              validateEmpty: false,
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          state is ShopSettingUpdateLoading
              ? const CustomLoading()
              : CustomFilledBtn(
                  text: S.of(context).update,
                  onPressed: () =>
                      ShopSettingCubit.get(context).updateShopSetting(),
                ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}

class CustomShopSettingBodyTabletAndDesktop extends StatelessWidget {
  const CustomShopSettingBodyTabletAndDesktop({super.key, required this.state});
  final ShopSettingState state;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(),
        ),
        Expanded(
          flex: 3,
          child: CustomShopSettingBodyMobile(
            state: state,
          ),
        ),
        Expanded(
          child: SizedBox(),
        ),
      ],
    );
  }
}
