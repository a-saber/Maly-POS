import 'package:flutter/material.dart';
import 'package:pos_app/core/utils/app_colors.dart';
import 'package:pos_app/core/widget/custom_loading.dart';
import 'package:pos_app/generated/l10n.dart';

import 'custom_pop_up.dart';

Future<bool?> showDeleteConfirmationDialog({
  required BuildContext context,
  required String title,
  required String content,
  required Widget Function(
          BuildContext context,
          Widget Function({
            required void Function() onPressed,
            required BuildContext context,
            String? title,
          }) deleteButton,
          Widget loading)
      deleteButtonBuilder,
}) async {
  return await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: Text('${S.of(context).areYouSureWantToDelete} "$content"'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: Text(S.of(context).cancel),
        ),
        deleteButtonBuilder(
            ctx, confirmButtonBuilder, deleteConfirmationDialogLoading()),
      ],
    ),
  );
}

Widget confirmButtonBuilder(
    {required void Function() onPressed,
    required BuildContext context,
    String? title}) {
  return TextButton(
    onPressed: onPressed,
    child: Text(title ?? S.of(context).delete,
        style: TextStyle(color: AppColors.error)),
  );
}

void deleteConfirmationDialogSuccess(
  BuildContext ctx,
) {
  Navigator.of(ctx).pop(true);
  CustomPopUp.callMyToast(
      context: ctx,
      massage: S.of(ctx).deletedSuccess,
      state: PopUpState.SUCCESS);
}

void deleteConfirmationDialogError(BuildContext ctx, String error) {
  CustomPopUp.callMyToast(
      context: ctx, massage: error, state: PopUpState.ERROR);
}

Widget deleteConfirmationDialogLoading() => CustomLoading();
