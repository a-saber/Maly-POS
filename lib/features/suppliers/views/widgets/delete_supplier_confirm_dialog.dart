import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/core/helper/my_service_locator.dart';
import 'package:pos_app/core/widget/show_delete_confirm_dialog.dart';
import 'package:pos_app/features/suppliers/data/repo/suppliers_repo.dart';
import 'package:pos_app/generated/l10n.dart';

import '../../manager/get_suppliers/get_suppliers_cubit.dart';
import '../../manager/delete_supplier/delete_supplier_cubit.dart';
import '../../manager/delete_supplier/delete_supplier_state.dart';
import '../../data/models/supplier_model.dart';

Future<bool?> showDeleteSupplierConfirmDialog(
    {required BuildContext context,
    required SupplierModel supplier,
    bool goBack = false}) async {
  return await showDeleteConfirmationDialog(
      context: context,
      title: S.of(context).deleteSupplier,
      content: supplier.name ?? '',
      deleteButtonBuilder: (ctx, button, loading) => BlocProvider(
            create: (context) => DeleteSupplierCubit(
                MyServiceLocator.getSingleton<SuppliersRepo>()),
            child: BlocConsumer<DeleteSupplierCubit, DeleteSupplierState>(
              listener: (context, state) {
                if (state is DeleteSupplierSuccess) {
                  deleteConfirmationDialogSuccess(ctx);
                  MyServiceLocator.getSingleton<GetSuppliersCubit>()
                      .deleteSupplier(state.id);
                  if (goBack) {
                    Navigator.pop(context);
                  }
                } else if (state is DeleteSupplierError) {
                  if (context.mounted) {
                    deleteConfirmationDialogError(
                        ctx, mapStatusCodeToMessage(context, state.error));
                  }
                }
              },
              builder: (context, state) {
                if (state is DeleteSupplierLoading) {
                  return loading;
                }
                return button(
                    context: context,
                    onPressed: () =>
                        DeleteSupplierCubit.get(context).deleteSupplier(
                          supplier: supplier,
                        ));
              },
            ),
          ));
}
