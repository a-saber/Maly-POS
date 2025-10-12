import 'package:flutter/material.dart';
import 'package:pos_app/core/router/app_route.dart';
import 'package:pos_app/core/utils/app_colors.dart';
import 'package:pos_app/core/utils/app_font_style.dart';
import 'package:pos_app/features/auth/login/data/model/role_model.dart';
import 'package:pos_app/features/permissions/view/widget/show_delete_permission_confirm_dialog.dart';
import 'package:redacted/redacted.dart';

class PermissionItemBuilder extends StatelessWidget {
  const PermissionItemBuilder({super.key, required this.permission});
  final RoleModel permission;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.editPermission,
          arguments: permission,
        );
      },
      child: Dismissible(
        onDismissed: (direction) {},
        confirmDismiss: (direction) async {
          return await showDeletePermissionConfirmDialog(
              context: context, permission: permission);
        },
        key: UniqueKey(),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withAlpha(25),
                  blurRadius: 7,
                  blurStyle: BlurStyle.outer,
                ),
              ]),
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              permission.name ?? '',
              style: AppFontStyle.itemsTitle(
                context: context,
                color: AppColors.black,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }
}

class PermissionCardLoading extends StatelessWidget {
  const PermissionCardLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withAlpha(25),
              blurRadius: 7,
              blurStyle: BlurStyle.outer,
            ),
          ]),
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Text(
          "permission",
          style: AppFontStyle.itemsTitle(
            context: context,
            color: AppColors.black,
          ),
        ).redacted(
          context: context,
          redact: true,
          configuration: RedactedConfiguration(
            animationDuration: const Duration(milliseconds: 800), //default
          ),
        ),
      ),
    );
  }
}
