import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/core/helper/my_service_locator.dart';
import 'package:pos_app/core/widget/show_delete_confirm_dialog.dart';
import 'package:pos_app/features/discounts/data/model/discount_model.dart';
import 'package:pos_app/features/discounts/data/repo/discounts_repo.dart';
import 'package:pos_app/features/discounts/manager/delete_discount_cubit/delete_discount_cubit.dart';
import 'package:pos_app/features/discounts/manager/get_all_discounts_cubit/get_all_discounts_cubit.dart';
import 'package:pos_app/generated/l10n.dart';

Future<bool?> showDeleteDiscountConfirmDialog(
    {required BuildContext context,
    required DiscountModel discount,
    bool goBack = false}) async {
  return await showDeleteConfirmationDialog(
      context: context,
      title: S.of(context).deleteDiscount,
      content: discount.title ?? S.of(context).noName,
      deleteButtonBuilder: (ctx, button, loading) => BlocProvider(
            create: (context) => DeleteDiscountCubit(
                MyServiceLocator.getSingleton<DiscountsRepo>()),
            child: BlocConsumer<DeleteDiscountCubit, DeleteDiscountState>(
              listener: (context, state) {
                if (state is DeleteDiscountSuccess) {
                  deleteConfirmationDialogSuccess(ctx);
                  MyServiceLocator.getSingleton<GetAllDiscountsCubit>()
                      .deleteDiscount(
                    state.id,
                  );
                  if (goBack) {
                    Navigator.of(context).pop();
                  }
                } else if (state is DeleteDiscountFailing) {
                  if (context.mounted) {
                    deleteConfirmationDialogError(
                      ctx,
                      mapStatusCodeToMessage(context, state.errMessage),
                    );
                  }
                }
              },
              builder: (context, state) {
                if (state is DeleteDiscountLoading) {
                  return loading;
                }
                return button(
                    context: context,
                    onPressed: () =>
                        DeleteDiscountCubit.get(context).deleteDiscount(
                          discount: discount,
                        ));
              },
            ),
          ));
}
