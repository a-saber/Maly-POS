import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/core/helper/my_service_locator.dart';
import 'package:pos_app/core/widget/show_delete_confirm_dialog.dart';
import 'package:pos_app/features/units/data/model/unit_model.dart';
import 'package:pos_app/features/units/data/repo/units_repo.dart';
import 'package:pos_app/features/units/manager/delete_unit_cubit/delete_unit_cubit.dart';
import 'package:pos_app/features/units/manager/get_all_units_cubit/get_all_units_cubit.dart';
import 'package:pos_app/generated/l10n.dart';

Future<bool?> showDeleteUnitConfirmDialog(
    {required BuildContext context,
    required UnitModel unit,
    bool goBack = false}) async {
  return await showDeleteConfirmationDialog(
      context: context,
      title: S.of(context).deleteUnit,
      content: unit.name ?? S.of(context).noName,
      deleteButtonBuilder: (ctx, button, loading) => BlocProvider(
            create: (context) =>
                DeleteUnitCubit(MyServiceLocator.getSingleton<UnitsRepo>()),
            child: BlocConsumer<DeleteUnitCubit, DeleteUnitState>(
              listener: (context, state) {
                if (state is DeleteUnitSuccess) {
                  deleteConfirmationDialogSuccess(ctx);
                  MyServiceLocator.getSingleton<GetAllUnitsCubit>()
                      .deleteUnits(state.id);
                  if (goBack) {
                    Navigator.of(context).pop();
                  }
                } else if (state is DeleteUnitFailing) {
                  if (context.mounted) {
                    deleteConfirmationDialogError(
                        ctx, mapStatusCodeToMessage(context, state.errMessage));
                  }
                }
              },
              builder: (context, state) {
                if (state is DeleteUnitLoading) {
                  return loading;
                }
                return button(
                    context: context,
                    onPressed: () => DeleteUnitCubit.get(context).deleteUnit(
                          unit: unit,
                        ));
              },
            ),
          ));
}
