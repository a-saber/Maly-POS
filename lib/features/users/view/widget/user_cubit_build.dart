import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/core/widget/custom_empty_view.dart';
import 'package:pos_app/core/widget/custom_error_view.dart';
import 'package:pos_app/core/widget/custom_pop_up.dart';
import 'package:pos_app/features/auth/login/data/model/user_model.dart';
import 'package:pos_app/features/users/manager/get_users/get_users_cubit.dart';

class UserCubitBuild extends StatelessWidget {
  const UserCubitBuild({
    super.key,
    required this.usersBuild,
    required this.userLoading,
  });
  final Widget Function(BuildContext context, List<UserModel> users) usersBuild;
  final Widget Function(BuildContext context) userLoading;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GetUsersCubit, GetUsersState>(
      listener: (context, state) {
        if (state is GetUsersPaginationFailing) {
          if (context.mounted) {
            CustomPopUp.callMyToast(
                context: context,
                massage: mapStatusCodeToMessage(context, state.errMessage),
                state: PopUpState.ERROR);
          }
        }
      },
      builder: (context, state) {
        return BlocBuilder<GetUsersCubit, GetUsersState>(
          builder: (context, state) {
            if (state is GetUsersFailing) {
              return CustomError(
                  error: context.mounted
                      ? mapStatusCodeToMessage(context, state.errMessage)
                      : 'error',
                  onPressed: () {
                    GetUsersCubit.get(context).getUsers();
                  });
            } else if (state is GetUsersLoading) {
              return userLoading(context);
            }
            if (GetUsersCubit.get(context).users.isEmpty) {
              return CustomEmptyView(
                onPressed: () => GetUsersCubit.get(context).getUsers(),
              );
            }
            return usersBuild(context, GetUsersCubit.get(context).users);
          },
        );
      },
    );
  }
}
