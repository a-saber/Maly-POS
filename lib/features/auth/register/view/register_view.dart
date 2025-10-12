import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/helper/my_service_locator.dart';
import 'package:pos_app/core/widget/cutsom_layout_builder.dart';
import 'package:pos_app/features/auth/register/data/repo/register_repo.dart';
import 'package:pos_app/features/auth/register/manager/cubit/register_cubit.dart';
import 'package:pos_app/features/auth/register/view/register_desktop_body.dart';
import 'package:pos_app/features/auth/register/view/register_mobile_body.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(
        MyServiceLocator.getSingleton<RegisterRepo>(),
      )..init(),
      child: const SafeArea(
        child: Scaffold(
          body: CustomLayoutBuilder(
            mobile: RegisterMobileBody(),
            tablet: RegisterDesktopBody(),
            desktop: RegisterDesktopBody(),
          ),
        ),
      ),
    );
  }
}
