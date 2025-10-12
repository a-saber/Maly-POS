import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:pos_app/core/cache/cache_keys.dart';
import 'package:pos_app/core/utils/app_asset.dart';
import 'package:pos_app/features/auth/login/view/login_view.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pos_app/features/home/view/home_view.dart';

import '../../core/cache/cache_helper.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: ImagesAsset.logo,
      nextScreen: nextScreen(),
      splashIconSize: MediaQuery.sizeOf(context).height * 0.25,
      splashTransition: SplashTransition.rotationTransition,
      backgroundColor: Colors.white,
      duration: 3000,
      animationDuration: const Duration(milliseconds: 500),
      pageTransitionType: PageTransitionType.fade,
    );
  }
}

Widget nextScreen() {
  return CacheHelper.getData(key: CacheKeys.isLogin) ?? false == true
      ? HomeView()
      : const LoginView();
}
