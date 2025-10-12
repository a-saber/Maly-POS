import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/core/constant/constant.dart';
import 'package:pos_app/core/helper/my_service_locator.dart';
import 'package:pos_app/core/widget/custom_app_bar.dart';
import 'package:pos_app/core/widget/custom_btn.dart';
import 'package:pos_app/core/widget/custom_pop_up.dart';
import 'package:pos_app/core/widget/cutsom_layout_builder.dart';
import 'package:pos_app/core/widget/my_custom_scroll_view.dart';
import 'package:pos_app/features/auth/login/data/model/role_model.dart';
import 'package:pos_app/features/permissions/data/repo/permission_repo.dart';
import 'package:pos_app/features/permissions/manager/edit_permission/edit_permission_cubit.dart';
import 'package:pos_app/features/permissions/manager/get_permission/get_permissions_cubit.dart';
import 'package:pos_app/features/permissions/view/widget/permission_data_builder.dart';
import 'package:pos_app/features/permissions/view/widget/show_delete_permission_confirm_dialog.dart';
import 'package:pos_app/generated/l10n.dart';

class EditPermissionView extends StatelessWidget {
  const EditPermissionView({super.key, required this.permission});
  final RoleModel permission;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditPermissionCubit(
          MyServiceLocator.getSingleton<PermissionsRepo>(), permission),
      child: Scaffold(
        appBar: CustomAppBar(
          title: S.of(context).editPermission,
          actions: [
            CustomTextBtn(
                text: S.of(context).delete,
                onPressed: () async {
                  await showDeletePermissionConfirmDialog(
                      context: context, permission: permission, goBack: true);
                }),
          ],
        ),
        body: BlocConsumer<EditPermissionCubit, EditPermissionState>(
          listener: (context, state) {
            if (state is EditPermissionSuccess) {
              GetPermissionsCubit.get(context).updatePermission(state.role);
              CustomPopUp.callMyToast(
                  context: context,
                  massage: S.of(context).updatedSuccess,
                  state: PopUpState.SUCCESS);
              Navigator.pop(context);
            } else if (state is EditPermissionFailing) {
              if (context.mounted) {
                CustomPopUp.callMyToast(
                    context: context,
                    massage: mapStatusCodeToMessage(context, state.errMessage),
                    state: PopUpState.ERROR);
              }
            }
          },
          builder: (context, state) {
            return CustomLayoutBuilder(
              mobile: MyCustomScrollView(
                  child: EditPermissionMobileBody(state: state)),
              tablet: MyCustomScrollView(
                  child: EditPermissionTabletAndDesktopBody(state: state)),
              desktop: MyCustomScrollView(
                  child: EditPermissionTabletAndDesktopBody(state: state)),
            );
          },
        ),
      ),
    );
  }
}

class EditPermissionMobileBody extends StatelessWidget {
  const EditPermissionMobileBody({
    super.key,
    required this.state,
  });
  final EditPermissionState state;
  @override
  Widget build(BuildContext context) {
    return PermissionDataBuilder(
      formKey: EditPermissionCubit.get(context).formKey,
      autovalidateMode: EditPermissionCubit.get(context).autovalidateMode,
      nameController: EditPermissionCubit.get(context).nameController,
      descriptionController:
          EditPermissionCubit.get(context).descriptionController,
      isLoading: state is EditPermissionLoading,
      onPressed: () => EditPermissionCubit.get(context).editPermission(),
      permissionItems: EditPermissionCubit.get(context).permissonsItem,
      onChanged: (bool value, int index) {
        EditPermissionCubit.get(context)
            .changePermissionStatus(index: index, status: value);
      },
      isEdit: true,
    );
  }
}

class EditPermissionTabletAndDesktopBody extends StatelessWidget {
  const EditPermissionTabletAndDesktopBody({super.key, required this.state});
  final EditPermissionState state;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: SizedBox()),
        Expanded(
            flex: AppConstant.formExpandedTableandMobile,
            child: EditPermissionMobileBody(state: state)),
        const Expanded(child: SizedBox()),
      ],
    );
  }
}
