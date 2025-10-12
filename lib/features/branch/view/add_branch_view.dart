import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/core/constant/constant.dart';
import 'package:pos_app/core/helper/my_service_locator.dart';
import 'package:pos_app/core/widget/custom_app_bar.dart';
import 'package:pos_app/core/widget/custom_pop_up.dart';
import 'package:pos_app/core/widget/cutsom_layout_builder.dart';
import 'package:pos_app/core/widget/my_custom_scroll_view.dart';
import 'package:pos_app/features/branch/data/repo/branches_repo.dart';
import 'package:pos_app/features/branch/manager/add_branch_cubit/add_branch_cubit.dart';
import 'package:pos_app/features/branch/manager/get_all_branches_cubit/get_all_branches_cubit.dart';
import 'package:pos_app/features/branch/view/widget/branch_data_builder.dart';
import 'package:pos_app/generated/l10n.dart';

class AddBranchView extends StatelessWidget {
  const AddBranchView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AddBranchCubit(MyServiceLocator.getSingleton<BranchesRepo>()),
      child: Scaffold(
        appBar: CustomAppBar(title: S.of(context).addBranch),
        body: BlocConsumer<AddBranchCubit, AddBranchState>(
          listener: (context, state) {
            if (state is AddBranchSuccess) {
              GetAllBranchesCubit.get(context).addBranches(state.branch);
              CustomPopUp.callMyToast(
                  context: context,
                  massage: S.of(context).addedSuccess,
                  state: PopUpState.SUCCESS);
              Navigator.pop(context);
            } else if (state is AddBranchFailing) {
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
                child: AddBranchBodyOfMobile(
                  state: state,
                ),
              ),
              tablet: MyCustomScrollView(
                child: AddBranchTableAndDescktopBody(
                  state: state,
                ),
              ),
              desktop: MyCustomScrollView(
                child: AddBranchTableAndDescktopBody(
                  state: state,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class AddBranchBodyOfMobile extends StatelessWidget {
  const AddBranchBodyOfMobile({
    super.key,
    required this.state,
  });
  final AddBranchState state;
  @override
  Widget build(BuildContext context) {
    return BranchDataBuilder(
      autovalidateMode: AddBranchCubit.get(context).autovalidateMode,
      onSelectedImage: (image) => AddBranchCubit.get(context).imageFile = image,
      formKey: AddBranchCubit.get(context).formKey,
      nameController: AddBranchCubit.get(context).nameController,
      addressController: AddBranchCubit.get(context).addressController,
      phoneController: AddBranchCubit.get(context).phoneController,
      emailController: AddBranchCubit.get(context).emailController,
      isLoading: state is AddBranchLoading,
      onPressed: () => AddBranchCubit.get(context).addBranch(),
      isEdit: false,
    );
  }
}

class AddBranchTableAndDescktopBody extends StatelessWidget {
  const AddBranchTableAndDescktopBody({super.key, required this.state});
  final AddBranchState state;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: SizedBox()),
        Expanded(
          flex: AppConstant.formExpandedTableandMobile,
          child: AddBranchBodyOfMobile(state: state),
        ),
        const Expanded(child: SizedBox()),
      ],
    );
  }
}
