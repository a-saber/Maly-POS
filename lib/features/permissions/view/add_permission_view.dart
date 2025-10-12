import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/core/constant/constant.dart';
import 'package:pos_app/core/helper/my_service_locator.dart';
import 'package:pos_app/core/widget/custom_app_bar.dart';
import 'package:pos_app/core/widget/custom_pop_up.dart';
import 'package:pos_app/core/widget/cutsom_layout_builder.dart';
import 'package:pos_app/core/widget/my_custom_scroll_view.dart';
import 'package:pos_app/features/permissions/data/repo/permission_repo.dart';
import 'package:pos_app/features/permissions/manager/add_permission/add_permission_cubit.dart';
import 'package:pos_app/features/permissions/manager/get_permission/get_permissions_cubit.dart';
import 'package:pos_app/features/permissions/view/widget/permission_data_builder.dart';
import 'package:pos_app/generated/l10n.dart';

class AddPermissionView extends StatelessWidget {
  const AddPermissionView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AddPermissionCubit(MyServiceLocator.getSingleton<PermissionsRepo>()),
      child: Scaffold(
        appBar: CustomAppBar(title: S.of(context).addPermission),
        body: BlocConsumer<AddPermissionCubit, AddPermissionState>(
          listener: (context, state) {
            if (state is AddPermissionSuccess) {
              GetPermissionsCubit.get(context).addPermission(
                state.role,
              );
              CustomPopUp.callMyToast(
                  context: context,
                  massage: S.of(context).addedSuccess,
                  state: PopUpState.SUCCESS);
              Navigator.pop(context);
            } else if (state is AddPermissionFailing) {
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
                  child: AddPermissionMobileBody(state: state)),
              tablet: MyCustomScrollView(
                  child: AddPermissionTabletAndDesktopBody(state: state)),
              desktop: MyCustomScrollView(
                  child: AddPermissionTabletAndDesktopBody(state: state)),
            );
          },
        ),
      ),
    );
  }
}

class AddPermissionMobileBody extends StatelessWidget {
  const AddPermissionMobileBody({
    super.key,
    required this.state,
  });
  final AddPermissionState state;
  @override
  Widget build(BuildContext context) {
    return PermissionDataBuilder(
        autovalidateMode: AddPermissionCubit.get(context).autovalidateMode,
        formKey: AddPermissionCubit.get(context).formKey,
        nameController: AddPermissionCubit.get(context).nameController,
        descriptionController:
            AddPermissionCubit.get(context).descriptionController,
        isLoading: state is AddPermissionLoading,
        onPressed: () => AddPermissionCubit.get(context).addPermission(),
        permissionItems: AddPermissionCubit.get(context).permissionItems,
        onChanged: (bool value, int index) {
          AddPermissionCubit.get(context)
              .changePermissionStatus(index: index, status: value);
        },
        isEdit: false);
  }
}

class AddPermissionTabletAndDesktopBody extends StatelessWidget {
  const AddPermissionTabletAndDesktopBody({super.key, required this.state});
  final AddPermissionState state;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: SizedBox()),
        Expanded(
          flex: AppConstant.formExpandedTableandMobile,
          child: AddPermissionMobileBody(state: state),
        ),
        Expanded(child: SizedBox()),
      ],
    );
  }
}
