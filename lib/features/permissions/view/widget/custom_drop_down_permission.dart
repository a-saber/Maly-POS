import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/helper/my_form_validators.dart';
import 'package:pos_app/core/helper/my_service_locator.dart';
import 'package:pos_app/core/utils/app_font_style.dart';
import 'package:pos_app/core/widget/custom_drop_down.dart';
import 'package:pos_app/core/widget/custom_form_field.dart';
import 'package:pos_app/features/auth/login/data/model/role_model.dart';
import 'package:pos_app/features/permissions/manager/search_permission/search_permission_cubit.dart';
import 'package:pos_app/features/permissions/view/widget/search_permission_build.dart';
import 'package:pos_app/generated/l10n.dart';

class CustomDropDownPermission extends StatelessWidget {
  const CustomDropDownPermission({
    super.key,
    this.permission,
    required this.onChangedPermission,
  });
  final RoleModel? permission;
  final void Function(RoleModel permission) onChangedPermission;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: MyServiceLocator.getSingleton<SearchPermissionCubit>(),
      child: Builder(builder: (context) {
        return CustomDropdown<RoleModel>(
          // search: tr,
          hint: S.of(context).selectRole,
          compareFn: (item1, item2) {
            if (item1.name == null || item2.name == null) {
              return false;
            } else {
              return (item1.name!
                      .toLowerCase()
                      .contains(item2.name!.toLowerCase()) ||
                  item2.name!
                      .toLowerCase()
                      .contains(item1.name!.toLowerCase()));
            }
          },
          validator: (value) =>
              MyFormValidators.validateTypeRequired<RoleModel>(value,
                  context: context),
          items: SearchPermissionCubit.get(context).roleSearch,
          value: permission,

          filterFn: (item, filter) {
            return item.name!.toLowerCase().contains(filter.toLowerCase());
          },
          onChanged: (RoleModel? permission) {
            // if (permission != null) {
            //   widget.onChangedPermission(permission);
            // }
          },
          containerBuilder: (p0, p1) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomFormField(
                    hintText: S.of(context).searchRole,
                    controller: TextEditingController(
                        text: SearchPermissionCubit.get(context).query),
                    onChanged: (value) => SearchPermissionCubit.get(context)
                        .onSearchChange(value, isNewSearch: true),
                  ),
                ),
                Expanded(
                  child: SearchPermissionBuild(
                    name: permission?.name ?? '',
                    child: p1,
                    onTap: (p0) {
                      onChangedPermission(p0);
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            );
          },
          builder: (RoleModel? permission) {
            if (permission != null) {
              return Text(
                permission.name ?? '-',
                style: AppFontStyle.formText(
                  context: context,
                ),
              );
            } else {
              return SizedBox();
            }
          },
        );
      }),
    );
  }
}
