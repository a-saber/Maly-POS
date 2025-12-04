import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/auth/login/manager/cubit/login_cubit.dart';
import '../../features/selling_point/manager/selling_point_product_cubit/selling_point_product_cubit.dart';
import '../helper/my_service_locator.dart';

class CustomDialog {


  static showDialogHelper(BuildContext context,
      {required Widget contentWidget,
       Widget? builder,
        Color? backgroundColor,
        Function()? onDismiss,
        bool isFullScreen = true}) {
    showDialog(
        context: context,
        builder: (ctx) =>
        builder??  MultiBlocProvider(
              providers: [
                BlocProvider.value(value: MyServiceLocator.getSingleton<SellingPointProductCubit>()),

              ],
              child: AlertDialog(

                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8),),

                contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                content: contentWidget,

              ),
            )
    ).then((value) {
      if (onDismiss != null) {
        onDismiss();
      }
    });
  }
}