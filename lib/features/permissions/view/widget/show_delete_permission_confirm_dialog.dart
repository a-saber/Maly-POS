import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/core/helper/my_service_locator.dart';
import 'package:pos_app/core/widget/show_delete_confirm_dialog.dart';
import 'package:pos_app/features/auth/login/data/model/role_model.dart';
import 'package:pos_app/features/permissions/data/repo/permission_repo.dart';
import 'package:pos_app/features/permissions/manager/delete_permssion/delete_permission_cubit.dart';
import 'package:pos_app/features/permissions/manager/get_permission/get_permissions_cubit.dart';
import 'package:pos_app/generated/l10n.dart';

Future<bool?> showDeletePermissionConfirmDialog(
    {required BuildContext context,
    required RoleModel permission,
    bool goBack = false}) async {
  return await showDeleteConfirmationDialog(
      context: context,
      title: S.of(context).deletePermission,
      content: permission.name ?? '',
      deleteButtonBuilder: (ctx, button, loading) => BlocProvider(
            create: (context) => DeletePermissionCubit(
                MyServiceLocator.getSingleton<PermissionsRepo>()),
            child: BlocConsumer<DeletePermissionCubit, DeletePermissionState>(
              listener: (context, state) {
                if (state is DeletePermissionSuccess) {
                  deleteConfirmationDialogSuccess(ctx);
                  MyServiceLocator.getSingleton<GetPermissionsCubit>()
                      .deletePermission(state.role);
                  if (goBack) {
                    Navigator.of(context).pop();
                  }
                } else if (state is DeletePermissionFailing) {
                  if (context.mounted) {
                    deleteConfirmationDialogError(
                        ctx, mapStatusCodeToMessage(context, state.errMessage));
                  }
                }
              },
              builder: (context, state) {
                if (state is DeletePermissionLaoding) {
                  return loading;
                }
                return button(
                    context: context,
                    onPressed: () =>
                        DeletePermissionCubit.get(context).deletePermission(
                          permission: permission,
                        ));
              },
            ),
          ));
}
