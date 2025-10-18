import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pos_app/core/cache/cache_helper.dart';
import 'package:pos_app/core/cache/custom_secure_storage.dart';
import 'package:pos_app/core/cache/custom_user_hive_box.dart';
import 'package:pos_app/core/helper/hive_register_adapter.dart';
import 'package:pos_app/core/helper/my_service_locator.dart';
import 'package:pos_app/core/invoice/pdf_font_loader.dart';
import 'package:pos_app/core/manager/language_control/language_control_cubit.dart';
import 'package:pos_app/core/router/app_route.dart';
import 'package:pos_app/core/utils/app_colors.dart';
import 'package:pos_app/core/utils/app_font.dart';
import 'package:pos_app/core/utils/app_font_style.dart';
import 'package:pos_app/generated/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PdfFontLoader.init();
  await Future.wait<void>([
    CacheHelper.init(),
    Hive.initFlutter(),
  ]);

  hiveRegisterAdapter();
  await CustomUserHiveBox.init();
  MyServiceLocator.init();
  CustomSecureStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LanguageControlCubit()..init(),
        ),
        // Bloc
      ],
      child: BlocBuilder<LanguageControlCubit, LanguageControlState>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Maly',
            theme: ThemeData(
                useMaterial3: true,
                colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
                scaffoldBackgroundColor: AppColors.scaffoldBackground,
                appBarTheme: AppBarTheme(
                  titleSpacing: 20,
                  titleTextStyle: AppFontStyle.appBarTitle(context: context),
                  backgroundColor: AppColors.scaffoldBackground,
                  elevation: 0,
                  scrolledUnderElevation: 0,
                ),
                textSelectionTheme: const TextSelectionThemeData(
                    cursorColor: AppColors.primary,
                    selectionHandleColor: AppColors.primary),
                canvasColor: AppColors.primary,
                fontFamily: AppFont.cairo,
                iconTheme: IconThemeData(
                  size: min(
                    MediaQuery.of(context).size.width * 0.021,
                    MediaQuery.of(context).size.height * 0.021,
                  ).clamp(
                    25,
                    50,
                  ),
                ),
                iconButtonTheme: IconButtonThemeData(
                  style: IconButton.styleFrom(
                    iconSize: min(
                      MediaQuery.of(context).size.width * 0.028,
                      MediaQuery.of(context).size.height * 0.028,
                    ).clamp(
                      25,
                      50,
                    ),
                  ),
                )),
            localizationsDelegates: [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            locale: LanguageControlCubit.get(context).local,
            initialRoute: AppRoutes.splash,
            onGenerateRoute: AppRoutes.generateRoute,
          );
        },
      ),
    );
  }
}
