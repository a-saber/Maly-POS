import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/core/constant/constant.dart';
import 'package:pos_app/core/helper/my_service_locator.dart';
import 'package:pos_app/core/widget/custom_app_bar.dart';
import 'package:pos_app/core/widget/custom_pop_up.dart';
import 'package:pos_app/core/widget/cutsom_layout_builder.dart';
import 'package:pos_app/core/widget/my_custom_scroll_view.dart';
import 'package:pos_app/features/users/data/repo/users_repo.dart';
import 'package:pos_app/features/users/manager/add_user/add_user_cubit.dart';
import 'package:pos_app/features/users/manager/get_users/get_users_cubit.dart';
import 'package:pos_app/features/users/view/widget/user_data_builder.dart';
import 'package:pos_app/generated/l10n.dart';

class AddUserView extends StatelessWidget {
  const AddUserView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) =>
            AddUserCubit(MyServiceLocator.getSingleton<UsersRepo>()),
        child: Scaffold(
          appBar: CustomAppBar(title: S.of(context).addUser),
          body: BlocConsumer<AddUserCubit, AddUserState>(
            listener: (context, state) {
              if (state is AddUserSuccess) {
                GetUsersCubit.get(context).addUser(state.user);

                CustomPopUp.callMyToast(
                    context: context,
                    massage: S.of(context).addedSuccess,
                    state: PopUpState.SUCCESS);
                Navigator.pop(context);
              } else if (state is AddUserFailing) {
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
              return CustomLayoutBuilder(
                mobile: MyCustomScrollView(
                  child: AddUserBodyOfMobile(
                    state: state,
                  ),
                ),
                tablet: MyCustomScrollView(
                  child: AddUserTableAndDescktopBody(
                    state: state,
                  ),
                ),
                desktop: MyCustomScrollView(
                  child: AddUserTableAndDescktopBody(
                    state: state,
                  ),
                ),
              );
            },
          ),
        ));
  }
}

class AddUserBodyOfMobile extends StatelessWidget {
  const AddUserBodyOfMobile({
    super.key,
    required this.state,
  });
  final AddUserState state;
  @override
  Widget build(BuildContext context) {
    return UserDataBuilder(
      autovalidateMode: AddUserCubit.get(context).autovalidateMode,
      onSelectedImage: (image) => AddUserCubit.get(context).image = image,
      formKey: AddUserCubit.get(context).formKey,
      nameController: AddUserCubit.get(context).nameController,
      emailController: AddUserCubit.get(context).emailController,
      phoneController: AddUserCubit.get(context).phoneController,
      addressController: AddUserCubit.get(context).addressController,
      passwordController: AddUserCubit.get(context).passwordController,
      isLoading: state is AddUserLoading,
      onPressed: () => AddUserCubit.get(context).addUser(),
      permission: AddUserCubit.get(context).permissionModel,
      onChangedPermission: AddUserCubit.get(context).changeUserPermission,
      onChangedBranch: AddUserCubit.get(context).addBranch,
      branche: AddUserCubit.get(context).branches,
      onDeleteBranch: AddUserCubit.get(context).removeBranch,
      isEdit: false,
    );
  }
}

class AddUserTableAndDescktopBody extends StatelessWidget {
  const AddUserTableAndDescktopBody({super.key, required this.state});
  final AddUserState state;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: SizedBox()),
        Expanded(
          flex: AppConstant.formExpandedTableandMobile,
          child: AddUserBodyOfMobile(state: state),
        ),
        const Expanded(child: SizedBox()),
      ],
    );
  }
}
