import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/core/widget/custom_empty_view.dart';
import 'package:pos_app/core/widget/custom_error_view.dart';
import 'package:pos_app/core/widget/custom_pop_up.dart';
import 'package:pos_app/features/auth/login/data/model/branche_model.dart';
import 'package:pos_app/features/branch/manager/get_all_branches_cubit/get_all_branches_cubit.dart';

class BranchesCubitBuilder extends StatelessWidget {
  const BranchesCubitBuilder({
    super.key,
    required this.branchesLoading,
    required this.branchesBuild,
  });

  final Widget Function(BuildContext context) branchesLoading;
  final Widget Function(BuildContext context, List<BrancheModel> units)
      branchesBuild;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GetAllBranchesCubit, GetAllBranchesState>(
      listener: (context, state) {
        if (state is GetBranchesPaginationFailing) {
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
        return BlocBuilder<GetAllBranchesCubit, GetAllBranchesState>(
          builder: (context, state) {
            if (state is GetAllBranchesFailing) {
              return CustomError(
                  error: context.mounted
                      ? mapStatusCodeToMessage(context, state.errMessage)
                      : 'error',
                  onPressed: () {
                    GetAllBranchesCubit.get(context).getBranches();
                  });
            } else if (state is GetAllBranchesLoading) {
              return branchesLoading(context);
            }
            if (GetAllBranchesCubit.get(context).branches.isEmpty) {
              return CustomEmptyView(
                onPressed: () => GetAllBranchesCubit.get(context).getBranches(),
              );
            }
            return branchesBuild(
                context, GetAllBranchesCubit.get(context).branches);
          },
        );
      },
    );
  }
}
