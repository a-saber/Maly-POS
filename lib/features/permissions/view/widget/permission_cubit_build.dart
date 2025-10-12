import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/core/widget/custom_empty_view.dart';
import 'package:pos_app/core/widget/custom_error_view.dart';
import 'package:pos_app/core/widget/custom_pop_up.dart';
import 'package:pos_app/features/auth/login/data/model/role_model.dart';
import 'package:pos_app/features/permissions/manager/get_permission/get_permissions_cubit.dart';

class PermssionCubitBuild extends StatelessWidget {
  const PermssionCubitBuild({
    super.key,
    required this.permissionsBuilder,
    required this.permissionsLoading,
    this.permissionsSearchBuilder,
  });
  final Widget Function(BuildContext context, List<RoleModel> permissions)
      permissionsBuilder;
  final Widget Function({
    required BuildContext context,
    required List<RoleModel> permissions,
    required bool isLoading,
    required bool canGetMore,
  })? permissionsSearchBuilder;
  final Widget Function(BuildContext context) permissionsLoading;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GetPermissionsCubit, GetPermissionsState>(
      listener: (context, state) {
        if (state is GetPermissionsPaginationFailing) {
          if (context.mounted) {
            CustomPopUp.callMyToast(
                context: context,
                massage: mapStatusCodeToMessage(context, state.errMessage),
                state: PopUpState.ERROR);
          }
        }
      },
      builder: (context, state) {
        return BlocBuilder<GetPermissionsCubit, GetPermissionsState>(
          builder: (context, state) {
            if (state is GetPermissionsFailing) {
              return CustomError(
                  error: context.mounted
                      ? mapStatusCodeToMessage(context, state.errMessage)
                      : "error",
                  onPressed: () =>
                      GetPermissionsCubit.get(context).getPermissions());
            } else if (state is GetPermissionsLoading) {
              return permissionsLoading(context);
            }

            if (GetPermissionsCubit.get(context).roles.isEmpty) {
              return CustomEmptyView(
                onPressed: () =>
                    GetPermissionsCubit.get(context).getPermissions(),
              );
            } else {
              return permissionsBuilder(
                  context, GetPermissionsCubit.get(context).roles);
            }
          },
        );
      },
    );
  }
}
