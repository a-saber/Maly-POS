import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/selling_point/manager/selling_point_product_cubit/selling_point_product_cubit.dart';

class CustomDialog {


  static showDialogHelper(BuildContext context,
      {required Widget contentWidget,
        Color? backgroundColor,
        Function()? onDismiss,
        bool isFullScreen = true}) {
    showDialog(
        context: context,
        builder: (ctx) =>
            MultiBlocProvider(
              providers: [
                BlocProvider.value(value: SellingPointProductCubit.get(context)),
              ],
              child: AlertDialog(

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),

                contentPadding:
                EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                content: contentWidget,

              ),
            )).then((value) {
      if (onDismiss != null) {
        onDismiss();
      }
    });
  }
}