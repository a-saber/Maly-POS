import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/helper/my_service_locator.dart';
import 'package:pos_app/core/widget/cutsom_layout_builder.dart';
import 'package:pos_app/features/auth/login/data/repo/login_repo.dart';
import 'package:pos_app/features/auth/login/manager/cubit/login_cubit.dart';
import 'package:pos_app/features/auth/login/view/widget/login_desktop_body.dart';
import 'package:pos_app/features/auth/login/view/widget/login_mobile_body.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(
        MyServiceLocator.getSingleton<LoginRepo>(),
      )..init(),
      child: const Scaffold(
        body: SafeArea(
          child: CustomLayoutBuilder(
            mobile: LoginMobileBody(),
            tablet: LoginDesktopBody(),
            desktop: LoginDesktopBody(),
          ),
        ),
      ),
    );
  }
}
