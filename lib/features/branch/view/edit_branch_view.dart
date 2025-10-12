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
import 'package:pos_app/features/auth/login/data/model/branche_model.dart';
import 'package:pos_app/features/branch/data/repo/branches_repo.dart';
import 'package:pos_app/features/branch/manager/edit_branch_cubit/edit_branch_cubit.dart';
import 'package:pos_app/features/branch/manager/get_all_branches_cubit/get_all_branches_cubit.dart';
import 'package:pos_app/features/branch/view/widget/branch_data_builder.dart';
import 'package:pos_app/features/branch/view/widget/show_delete_branch_confirm_dialog.dart';
import 'package:pos_app/features/categories/manager/edit_category/edit_category_cubit.dart';
import 'package:pos_app/generated/l10n.dart';

class EditBranchView extends StatelessWidget {
  const EditBranchView({super.key, required this.branch});
  final BrancheModel branch;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditBranchCubit(
          MyServiceLocator.getSingleton<BranchesRepo>(), branch),
      child: Scaffold(
        appBar: CustomAppBar(
          title: S.of(context).editBranch,
          actions: [
            CustomTextBtn(
                text: S.of(context).delete,
                onPressed: () async {
                  await showDeleteBranchConfirmDialog(
                      context: context, branch: branch, goBack: true);
                }),
          ],
        ),
        body: BlocConsumer<EditBranchCubit, EditBranchState>(
          listener: (context, state) {
            if (state is EditBranchSuccess) {
              GetAllBranchesCubit.get(context).updateBranches(state.branch);
              CustomPopUp.callMyToast(
                context: context,
                massage: S.of(context).updatedSuccess,
                state: PopUpState.SUCCESS,
              );
              Navigator.pop(context);
            } else if (state is EditBranchFailing) {
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
                child: EditBranchBodyOfMobile(state: state),
              ),
              tablet: MyCustomScrollView(
                child: EditBranchTableAndDescktopBody(state: state),
              ),
              desktop: MyCustomScrollView(
                child: EditBranchTableAndDescktopBody(state: state),
              ),
            );
          },
        ),
      ),
    );
  }
}

class EditBranchBodyOfMobile extends StatelessWidget {
  const EditBranchBodyOfMobile({
    super.key,
    required this.state,
  });
  final EditBranchState state;
  @override
  Widget build(BuildContext context) {
    return BranchDataBuilder(
      autovalidateMode: EditBranchCubit.get(context).autovalidateMode,
      onSelectedImage: (image) =>
          EditBranchCubit.get(context).imageFile = image,
      formKey: EditBranchCubit.get(context).formkey,
      imageUrl: null,
      nameController: EditBranchCubit.get(context).nameController,
      addressController: EditBranchCubit.get(context).addressController,
      phoneController: EditBranchCubit.get(context).phoneController,
      emailController: EditBranchCubit.get(context).emailController,
      isLoading: state is EditCategoryLoading,
      onPressed: () => EditBranchCubit.get(context).editBranch(),
      isEdit: true,
    );
  }
}

class EditBranchTableAndDescktopBody extends StatelessWidget {
  const EditBranchTableAndDescktopBody({super.key, required this.state});
  final EditBranchState state;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: SizedBox()),
        Expanded(
          flex: AppConstant.formExpandedTableandMobile,
          child: EditBranchBodyOfMobile(state: state),
        ),
        const Expanded(child: SizedBox()),
      ],
    );
  }
}
