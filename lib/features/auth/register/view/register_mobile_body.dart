import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/core/constant/device_size.dart';
import 'package:pos_app/core/helper/my_form_validators.dart';
import 'package:pos_app/core/router/app_route.dart';
import 'package:pos_app/core/utils/app_font_style.dart';
import 'package:pos_app/core/utils/app_padding.dart';
import 'package:pos_app/core/widget/custom_btn.dart';
import 'package:pos_app/core/widget/custom_form_field.dart';
import 'package:pos_app/core/widget/custom_loading.dart';
import 'package:pos_app/core/widget/custom_obscure_suffix_icon.dart';
import 'package:pos_app/core/widget/custom_pop_up.dart';
import 'package:pos_app/core/widget/my_custom_scroll_view.dart';
import 'package:pos_app/features/auth/register/manager/cubit/register_cubit.dart';
import 'package:pos_app/generated/l10n.dart';

class RegisterMobileBody extends StatelessWidget {
  const RegisterMobileBody({super.key});

  @override
  Widget build(BuildContext context) {
    return MyCustomScrollView(
      // keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Padding(
        padding: AppPaddings.defaultView,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: DeviceSize.getHeight(context: context) * 0.05,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              spacing: 20,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 50,
                      minWidth: 20,
                      maxHeight: 50,
                      minHeight: 20,
                    ),
                    child: Icon(
                      Icons.arrow_back,
                      size: DeviceSize.getHeight(context: context) * 0.03,
                    ),
                  ),
                ),
                Text(
                  S.of(context).register,
                  style: AppFontStyle.authTitle(
                    context: context,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: DeviceSize.getHeight(context: context) * 0.03,
            ),
            BlocBuilder<RegisterCubit, RegisterState>(
              buildWhen: (previous, current) {
                return current is RegisterUnvalidTextField ||
                    current is ChangeOnbscurePassword;
              },
              builder: (context, state) {
                return Form(
                  key: RegisterCubit.get(context).formKey,
                  autovalidateMode: RegisterCubit.get(context).autovalidateMode,
                  child: Column(
                    spacing: 20,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CustomFormField(
                        controller: RegisterCubit.get(context).namecontroller,
                        validator: (value) => MyFormValidators.validateRequired(
                            value,
                            context: context),
                        labelText: S.of(context).name,
                        keyboardType: TextInputType.name,
                      ),
                      CustomFormField(
                        controller: RegisterCubit.get(context).phonecontroller,
                        validator: (value) => MyFormValidators.validatePhone(
                            value,
                            context: context),
                        labelText: S.of(context).phone,
                        keyboardType: TextInputType.phone,
                      ),
                      CustomFormField(
                        controller: RegisterCubit.get(context).emailController,
                        validator: (value) => MyFormValidators.validateEmail(
                            value,
                            context: context),
                        labelText: S.of(context).email,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      CustomFormField(
                        controller:
                            RegisterCubit.get(context).addresscontroller,
                        validator: (value) => MyFormValidators.validateRequired(
                            value,
                            context: context),
                        labelText: S.of(context).address,
                        keyboardType: TextInputType.streetAddress,
                      ),
                      CustomFormField(
                        controller:
                            RegisterCubit.get(context).shopnamecontroller,
                        validator: (value) => MyFormValidators.validateRequired(
                            value,
                            context: context),
                        labelText: S.of(context).shopName,
                        keyboardType: TextInputType.name,
                      ),
                      CustomFormField(
                        controller:
                            RegisterCubit.get(context).passwordController,
                        validator: (value) => MyFormValidators.validatePassword(
                            value,
                            context: context),
                        labelText: S.of(context).password,
                        suffixIcon: CustomObscureSuffixIcon(
                          onPressed:
                              RegisterCubit.get(context).changePasswordObscure,
                          isObscure: RegisterCubit.get(context).passwordObscure,
                        ),
                        obscureText: RegisterCubit.get(context).passwordObscure,
                      ),
                      CustomFormField(
                        controller: RegisterCubit.get(context)
                            .confirmPasswordController,
                        validator: (value) =>
                            MyFormValidators.confirmvalidatePassword(
                          value,
                          context: context,
                          match: RegisterCubit.get(context)
                              .passwordController
                              .text,
                        ),
                        labelText: S.of(context).confirmPassword,
                        suffixIcon: CustomObscureSuffixIcon(
                          onPressed: RegisterCubit.get(context)
                              .changeConfirmPasswordObscure,
                          isObscure:
                              RegisterCubit.get(context).confirmPasswordObscure,
                        ),
                        obscureText:
                            RegisterCubit.get(context).confirmPasswordObscure,
                      ),
                    ],
                  ),
                );
              },
            ),
            SizedBox(
              height: 20,
            ),
            BlocConsumer<RegisterCubit, RegisterState>(
              listener: (context, state) {
                if (state is RegisterSuccess) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.login,
                    (route) => false,
                  );
                  if (context.mounted) {
                    CustomPopUp.callMyToast(
                        context: context,
                        massage: state.message.message ??
                            S.of(context).registerSuccess,
                        state: PopUpState.SUCCESS);
                  }
                } else if (state is RegisterError) {
                  if (context.mounted) {
                    CustomPopUp.callMyToast(
                        context: context,
                        massage: mapStatusCodeToMessage(
                          context,
                          state.errMessage,
                        ),
                        state: PopUpState.ERROR);
                  }
                }
              },
              buildWhen: (previous, current) {
                return current is RegisterLoading ||
                    current is RegisterSuccess ||
                    current is RegisterError ||
                    current is RegisterUnvalidTextField;
              },
              builder: (context, state) {
                if (state is RegisterLoading) {
                  return CustomLoading();
                }
                return SizedBox(
                  width: double.infinity,
                  child: CustomFilledBtn(
                    text: S.of(context).register,
                    onPressed: () => RegisterCubit.get(context).onTap(),
                  ),
                );
              },
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(S.of(context).alreadyHaveAccount),
                SizedBox(
                  width: 5,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    S.of(context).login.toUpperCase(),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
