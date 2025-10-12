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
import 'package:pos_app/features/auth/login/manager/cubit/login_cubit.dart';
import 'package:pos_app/generated/l10n.dart';

class LoginMobileBody extends StatelessWidget {
  const LoginMobileBody({super.key});

  @override
  Widget build(BuildContext context) {
    return MyCustomScrollView(
      child: Padding(
        padding: AppPaddings.defaultView,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: DeviceSize.getHeight(context: context) * 0.05,
            ),
            Text(
              S.of(context).login,
              style: AppFontStyle.authTitle(context: context),
            ),
            SizedBox(
              height: DeviceSize.getHeight(context: context) * 0.03,
            ),
            BlocBuilder<LoginCubit, LoginState>(
              buildWhen: (previous, current) {
                return current is LoginUnvalidTextField ||
                    current is ChangeObscureTextState;
              },
              builder: (context, state) {
                return Form(
                  key: LoginCubit.get(context).formKey,
                  autovalidateMode: LoginCubit.get(context).autovalidateMode,
                  child: Column(
                    spacing: 20,
                    children: [
                      CustomFormField(
                        controller: LoginCubit.get(context).emailController,
                        validator: (value) => MyFormValidators.validateEmail(
                            value,
                            context: context),
                        labelText: S.of(context).email,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      CustomFormField(
                        controller: LoginCubit.get(context).passwordController,
                        validator: (value) => MyFormValidators.validatePassword(
                            value,
                            context: context),
                        labelText: S.of(context).password,
                        suffixIcon: CustomObscureSuffixIcon(
                          onPressed: LoginCubit.get(context).changeObscureText,
                          isObscure: LoginCubit.get(context).obscureText,
                        ),
                        obscureText: LoginCubit.get(context).obscureText,
                      ),
                    ],
                  ),
                );
              },
            ),
            SizedBox(
              height: 40,
            ),
            BlocConsumer<LoginCubit, LoginState>(
              listener: (context, state) {
                if (state is LoginSuccess) {
                  if (context.mounted) {
                    CustomPopUp.callMyToast(
                      context: context,
                      massage:
                          state.message.message ?? S.of(context).loginSuccess,
                      state: PopUpState.SUCCESS,
                    );
                  }

                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.home,
                    (route) => false,
                  );
                } else if (state is LoginError) {
                  if (context.mounted) {
                    CustomPopUp.callMyToast(
                        context: context,
                        massage:
                            mapStatusCodeToMessage(context, state.errorMessage),
                        state: PopUpState.ERROR);
                  }
                }
              },
              listenWhen: (previous, current) {
                return current is LoginError || current is LoginSuccess;
              },
              buildWhen: (previous, current) {
                return current is LoginLoading ||
                    current is LoginError ||
                    current is LoginSuccess ||
                    current is LoginUnvalidTextField;
              },
              builder: (context, state) {
                if (state is LoginLoading) {
                  return CustomLoading();
                }
                return SizedBox(
                  width: double.infinity,
                  child: CustomFilledBtn(
                    text: S.of(context).login,
                    onPressed: () => LoginCubit.get(context).onTap(),
                  ),
                );
              },
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(S.of(context).donTHaveAccount),
                SizedBox(
                  width: 5,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.register);
                    },
                    child: Text(S.of(context).register.toUpperCase()))
              ],
            )
          ],
        ),
      ),
    );
  }
}
