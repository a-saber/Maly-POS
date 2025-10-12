import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/core/helper/my_service_locator.dart';
import 'package:pos_app/core/widget/show_delete_confirm_dialog.dart';
import 'package:pos_app/features/auth/login/data/model/branche_model.dart';
import 'package:pos_app/features/branch/data/repo/branches_repo.dart';
import 'package:pos_app/features/branch/manager/delete_branch_cubit/delete_branch_cubit.dart';
import 'package:pos_app/features/branch/manager/get_all_branches_cubit/get_all_branches_cubit.dart';
import 'package:pos_app/generated/l10n.dart';

Future<bool?> showDeleteBranchConfirmDialog(
    {required BuildContext context,
    required BrancheModel branch,
    bool goBack = false}) async {
  return await showDeleteConfirmationDialog(
      context: context,
      title: S.of(context).deleteBranch,
      content: branch.name ?? '',
      deleteButtonBuilder: (ctx, button, loading) => BlocProvider(
            create: (context) => DeleteBranchCubit(
                MyServiceLocator.getSingleton<BranchesRepo>()),
            child: BlocConsumer<DeleteBranchCubit, DeleteBranchState>(
              listener: (context, state) {
                if (state is DeleteBranchSuccess) {
                  deleteConfirmationDialogSuccess(ctx);

                  MyServiceLocator.getSingleton<GetAllBranchesCubit>()
                      .deleteBranches(state.id);
                  if (goBack) {
                    Navigator.pop(context);
                  }
                } else if (state is DeleteBranchFailing) {
                  if (context.mounted) {
                    deleteConfirmationDialogError(
                        ctx, mapStatusCodeToMessage(context, state.errMessage));
                  }
                }
              },
              builder: (context, state) {
                if (state is DeleteBranchLoading) {
                  return loading;
                }
                return button(
                  context: context,
                  onPressed: () => DeleteBranchCubit.get(context).deleteBranch(
                    branch: branch,
                  ),
                );
              },
            ),
          ));
}
