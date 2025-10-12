import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/core/helper/my_service_locator.dart';
import 'package:pos_app/core/widget/show_delete_confirm_dialog.dart';
import 'package:pos_app/features/taxes/data/model/taxes_model.dart';
import 'package:pos_app/features/taxes/data/repo/taxes_repo.dart';
import 'package:pos_app/features/taxes/manager/delete_taxes_cubit/delete_taxes_cubit.dart';
import 'package:pos_app/features/taxes/manager/get_all_taxes_cubit/get_all_taxes_cubit.dart';
import 'package:pos_app/generated/l10n.dart';

Future<bool?> showDeleteTaxesConfirmDialog(
    {required BuildContext context,
    required TaxesModel taxes,
    bool goBack = false}) async {
  return await showDeleteConfirmationDialog(
      context: context,
      title: S.of(context).deleteTax,
      content: taxes.title ?? S.of(context).noName,
      deleteButtonBuilder: (ctx, button, loading) => BlocProvider(
            create: (context) =>
                DeleteTaxesCubit(MyServiceLocator.getSingleton<TaxesRepo>()),
            child: BlocConsumer<DeleteTaxesCubit, DeleteTaxesState>(
              listener: (context, state) {
                if (state is DeleteTaxesSuccess) {
                  deleteConfirmationDialogSuccess(ctx);
                  MyServiceLocator.getSingleton<GetAllTaxesCubit>().deleteTaxes(
                    id: state.id,
                  );
                  if (goBack) {
                    Navigator.of(context).pop();
                  }
                } else if (state is DeleteTaxesFailing) {
                  if (context.mounted) {
                    deleteConfirmationDialogError(
                        ctx, mapStatusCodeToMessage(context, state.errMessage));
                  }
                }
              },
              builder: (context, state) {
                if (state is DeleteTaxesLoading) {
                  return loading;
                }
                return button(
                    context: context,
                    onPressed: () =>
                        DeleteTaxesCubit.get(context).deleteTax(tax: taxes));
              },
            ),
          ));
}
