import 'package:flutter/material.dart';
import 'package:pos_app/core/constant/constant.dart';
import 'package:pos_app/core/router/app_route.dart';
import 'package:pos_app/core/utils/app_padding.dart';
import 'package:pos_app/core/widget/custom_app_bar.dart';
import 'package:pos_app/core/widget/custom_floating_action_btn.dart';
import 'package:pos_app/core/widget/custom_grid_view_card.dart';
import 'package:pos_app/core/widget/custom_refresh_indicator.dart';
import 'package:pos_app/features/users/manager/get_users/get_users_cubit.dart';
import 'package:pos_app/features/users/view/widget/user_cubit_build.dart';
import 'package:pos_app/features/users/view/widget/user_item_build.dart';
import 'package:pos_app/generated/l10n.dart';

class UsersView extends StatelessWidget {
  const UsersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: CustomFloatingActionBtn(onPressed: () {
        Navigator.pushNamed(context, AppRoutes.addUser);
      }),
      appBar: CustomAppBar(title: S.of(context).users),
      body: CustomRefreshIndicator(
        onRefresh: () {
          return GetUsersCubit.get(context).getRefreshUsers();
        },
        child: Padding(
          padding: AppPaddings.defaultView,
          child: UserCubitBuild(
            userLoading: (context) {
              return CustomGridViewCard(
                heightOfCard: MediaQuery.of(context).textScaler.scale(110),
                itemBuilder: (p0, p1) {
                  return UserCardLoading();
                },
                itemCount: AppConstant.numberOfCardLoading,
              );
            },
            usersBuild: (context, users) {
              return CustomGridViewCard(
                controller: GetUsersCubit.get(context).scrollController,
                canLaoding: GetUsersCubit.get(context).canLoading(),
                heightOfCard: MediaQuery.of(context).textScaler.scale(110),
                itemBuilder: (BuildContext context, int index) {
                  return UserItemBuilder(user: users[index]);
                },
                itemCount: users.length,
              );
            },
          ),
        ),
      ),
    );
  }
}
