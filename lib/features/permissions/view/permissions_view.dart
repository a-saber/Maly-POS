import 'package:flutter/material.dart';
import 'package:pos_app/core/constant/constant.dart';
import 'package:pos_app/core/router/app_route.dart';
import 'package:pos_app/core/utils/app_padding.dart';
import 'package:pos_app/core/widget/custom_app_bar.dart';
import 'package:pos_app/core/widget/custom_floating_action_btn.dart';
import 'package:pos_app/core/widget/custom_grid_view_card.dart';
import 'package:pos_app/core/widget/custom_refresh_indicator.dart';
import 'package:pos_app/features/permissions/manager/get_permission/get_permissions_cubit.dart';
import 'package:pos_app/features/permissions/view/widget/permission_cubit_build.dart';
import 'package:pos_app/features/permissions/view/widget/permission_item_builder.dart';
import 'package:pos_app/generated/l10n.dart';

class PermissionsView extends StatelessWidget {
  const PermissionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: CustomFloatingActionBtn(onPressed: () {
        Navigator.pushNamed(context, AppRoutes.addPermission);
      }),
      appBar: CustomAppBar(title: S.of(context).permissions),
      body: CustomRefreshIndicator(
        onRefresh: () async {
          GetPermissionsCubit.get(context).getRefreshPermissions();
        },
        child: Padding(
          padding: AppPaddings.defaultView,
          child: PermssionCubitBuild(
              permissionsLoading: (context) => CustomGridViewCard(
                    itemBuilder: (context, index) {
                      return PermissionCardLoading();
                    },
                    itemCount: AppConstant.numberOfCardLoading,
                  ),
              permissionsBuilder: (context, permissions) {
                return CustomGridViewCard(
                  controller: GetPermissionsCubit.get(context).controller,
                  canLaoding: GetPermissionsCubit.get(context).canLoading(),
                  itemBuilder: (BuildContext context, index) {
                    return PermissionItemBuilder(
                      permission: permissions[index],
                    );
                  },
                  itemCount: permissions.length,
                );
              }),
        ),
      ),
    );
  }
}
