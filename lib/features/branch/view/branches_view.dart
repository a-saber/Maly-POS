import 'package:flutter/material.dart';
import 'package:pos_app/core/constant/constant.dart';
import 'package:pos_app/core/router/app_route.dart';
import 'package:pos_app/core/utils/app_padding.dart';
import 'package:pos_app/core/widget/custom_app_bar.dart';
import 'package:pos_app/core/widget/custom_floating_action_btn.dart';
import 'package:pos_app/core/widget/custom_grid_view_card.dart';
import 'package:pos_app/core/widget/custom_refresh_indicator.dart';
import 'package:pos_app/features/branch/manager/get_all_branches_cubit/get_all_branches_cubit.dart';
import 'package:pos_app/features/branch/view/widget/branch_cubit_builder.dart';
import 'package:pos_app/features/branch/view/widget/branch_item_builder.dart';
import 'package:pos_app/generated/l10n.dart';

class BranchesView extends StatelessWidget {
  const BranchesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: CustomFloatingActionBtn(onPressed: () {
        Navigator.pushNamed(context, AppRoutes.addBranch);
      }),
      appBar: CustomAppBar(title: S.of(context).branches),
      body: CustomRefreshIndicator(
        onRefresh: () {
          return GetAllBranchesCubit.get(context).getRefreshBranches();
        },
        child: Padding(
          padding: AppPaddings.defaultView,
          child: BranchesCubitBuilder(
            branchesLoading: (context) => CustomGridViewCard(
              itemBuilder: (context, index) {
                return BranchCardLoading();
              },
              itemCount: AppConstant.numberOfCardLoading,
            ),
            branchesBuild: (context, branches) => CustomGridViewCard(
              controller: GetAllBranchesCubit.get(context).scrollController,
              canLaoding: GetAllBranchesCubit.get(context).canLoading(),
              itemBuilder: (BuildContext context, index) {
                return BranchItemBuilder(branch: branches[index]);
              },
              itemCount: branches.length,
            ),
          ),
        ),
      ),
    );
  }
}
