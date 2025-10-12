import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/core/cache/custom_user_hive_box.dart';
import 'package:pos_app/core/constant/constant.dart';
import 'package:pos_app/core/helper/my_service_locator.dart';
import 'package:pos_app/core/widget/custom_app_bar.dart';
import 'package:pos_app/core/widget/custom_btn.dart';
import 'package:pos_app/core/widget/custom_pop_up.dart';
import 'package:pos_app/core/widget/cutsom_layout_builder.dart';
import 'package:pos_app/core/widget/my_custom_scroll_view.dart';
import 'package:pos_app/features/auth/login/data/model/user_model.dart';
import 'package:pos_app/features/home/manager/cubit/home_cubit.dart';
import 'package:pos_app/features/selling_point/manager/selling_point_product_cubit/selling_point_product_cubit.dart';
import 'package:pos_app/features/users/data/repo/users_repo.dart';
import 'package:pos_app/features/users/manager/edit_user/edit_user_cubit.dart';
import 'package:pos_app/features/users/manager/get_users/get_users_cubit.dart';
import 'package:pos_app/features/users/view/widget/delete_user_confirm_dialog.dart';
import 'package:pos_app/features/users/view/widget/user_data_builder.dart';
import 'package:pos_app/generated/l10n.dart';

class EditUserView extends StatelessWidget {
  const EditUserView({super.key, required this.user});
  final UserModel user;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          EditUserCubit(user, MyServiceLocator.getSingleton<UsersRepo>()),
      child: Scaffold(
        appBar: CustomAppBar(
          title: S.of(context).editUser,
          actions: [
            CustomTextBtn(
                text: S.of(context).delete,
                onPressed: () async {
                  await showDeleteUserConfirmDialog(
                      context: context, user: user, goBack: true);
                }),
          ],
        ),
        body: BlocConsumer<EditUserCubit, EditUserState>(
          listener: (context, state) {
            if (state is EditUserSuccess) {
              GetUsersCubit.get(context).editUser(state.user);
              if (user.id == CustomUserHiveBox.getUser().id) {
                HomeCubit.get(context).init();
                MyServiceLocator.getSingleton<SellingPointProductCubit>()
                    .onChangeBranche(null);
              }
              CustomPopUp.callMyToast(
                context: context,
                massage: S.of(context).updatedSuccess,
                state: PopUpState.SUCCESS,
              );
              Navigator.pop(context);
            } else if (state is EditUserFailing) {
              if (context.mounted) {
                CustomPopUp.callMyToast(
                  context: context,
                  massage: mapStatusCodeToMessage(context, state.errMessage),
                  state: PopUpState.ERROR,
                );
              }
            }
          },
          builder: (context, state) {
            log(user.id.toString());
            return CustomLayoutBuilder(
              mobile:
                  MyCustomScrollView(child: EditUserMobileBody(state: state)),
              tablet: MyCustomScrollView(
                  child: EditUserTabletAndDesktopBody(state: state)),
              desktop: MyCustomScrollView(
                  child: EditUserTabletAndDesktopBody(state: state)),
            );
          },
        ),
      ),
    );
  }
}

class EditUserMobileBody extends StatelessWidget {
  const EditUserMobileBody({
    super.key,
    required this.state,
  });
  final EditUserState state;
  @override
  Widget build(BuildContext context) {
    return UserDataBuilder(
      onSelectedImage: (image) => EditUserCubit.get(context).image = image,
      formKey: EditUserCubit.get(context).formKey,
      autovalidateMode: EditUserCubit.get(context).autovalidateMode,
      nameController: EditUserCubit.get(context).nameController,
      emailController: EditUserCubit.get(context).emailController,
      phoneController: EditUserCubit.get(context).phoneController,
      addressController: EditUserCubit.get(context).addressController,
      passwordController: EditUserCubit.get(context).passwordController,
      isLoading: state is EditUserLoading,
      onPressed: () => EditUserCubit.get(context).editUser(),
      imageUrl: EditUserCubit.get(context).user.imageUrl,
      onChangedPermission: EditUserCubit.get(context).changeUserPermission,
      permission: EditUserCubit.get(context).permissionModel,
      onChangedBranch: EditUserCubit.get(context).addBranches,
      branche: EditUserCubit.get(context).branches ?? [],
      onDeleteBranch: EditUserCubit.get(context).removeBranches,
      isEdit: true,
    );
  }
}

class EditUserTabletAndDesktopBody extends StatelessWidget {
  const EditUserTabletAndDesktopBody({super.key, required this.state});
  final EditUserState state;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: SizedBox()),
        Expanded(
          flex: AppConstant.formExpandedTableandMobile,
          child: EditUserMobileBody(state: state),
        ),
        const Expanded(child: SizedBox()),
      ],
    );
  }
}
