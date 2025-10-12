import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/core/helper/my_service_locator.dart';
import 'package:pos_app/core/widget/show_delete_confirm_dialog.dart';
import 'package:pos_app/features/auth/login/data/model/user_model.dart';
import 'package:pos_app/features/users/data/repo/users_repo.dart';
import 'package:pos_app/features/users/manager/delete_user/delete_user_cubit.dart';
import 'package:pos_app/features/users/manager/get_users/get_users_cubit.dart';
import 'package:pos_app/generated/l10n.dart';

Future<bool?> showDeleteUserConfirmDialog(
    {required BuildContext context,
    required UserModel user,
    bool goBack = false}) async {
  return await showDeleteConfirmationDialog(
      context: context,
      title: S.of(context).deleteUser,
      content: user.name ?? '',
      deleteButtonBuilder: (ctx, button, loading) => BlocProvider(
            create: (context) =>
                DeleteUserCubit(MyServiceLocator.getSingleton<UsersRepo>()),
            child: BlocConsumer<DeleteUserCubit, DeleteUserState>(
              listener: (context, state) {
                if (state is DeleteUserSuccess) {
                  deleteConfirmationDialogSuccess(ctx);

                  MyServiceLocator.getSingleton<GetUsersCubit>()
                      .removeUser(state.id);
                  if (goBack) {
                    Navigator.pop(context);
                  }
                } else if (state is DeleteUserFailing) {
                  if (context.mounted) {
                    deleteConfirmationDialogError(
                        ctx, mapStatusCodeToMessage(context, state.errMessage));
                  }
                }
              },
              builder: (context, state) {
                if (state is DeleteUserLoading) {
                  return loading;
                }
                return button(
                    context: context,
                    onPressed: () => DeleteUserCubit.get(context).deleteUser(
                          user: user,
                        ));
              },
            ),
          ));
}
