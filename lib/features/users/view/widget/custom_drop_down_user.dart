import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/helper/my_service_locator.dart';
import 'package:pos_app/core/utils/app_font_style.dart';
import 'package:pos_app/core/widget/custom_drop_down.dart';
import 'package:pos_app/core/widget/custom_form_field.dart';
import 'package:pos_app/features/auth/login/data/model/user_model.dart';
import 'package:pos_app/features/users/manager/search_user/search_user_cubit.dart';
import 'package:pos_app/features/users/view/widget/search_user_build.dart';
import 'package:pos_app/generated/l10n.dart';

class CustomDropDownUser extends StatelessWidget {
  const CustomDropDownUser({
    super.key,
    this.user,
    required this.onChanged,
  });
  final UserModel? user;
  final ValueChanged<UserModel?> onChanged;
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: MyServiceLocator.getSingleton<SearchUserCubit>(),
      child: Builder(builder: (context) {
        return CustomDropdown<UserModel>(
          // search: true,
          hint: S.of(context).selectUser,
          compareFn: (item1, item2) {
            if (item1.name == null ||
                item2.name == null ||
                item1.name!.isEmpty ||
                item2.name!.isEmpty) {
              return false;
            } else {
              return (item1.name!
                      .toLowerCase()
                      .contains(item2.name!.toLowerCase()) ||
                  item2.name!
                      .toLowerCase()
                      .contains(item1.name!.toLowerCase()));
            }
          },
          value: user,
          items: SearchUserCubit.get(context).users,
          filterFn: (item, filter) {
            return item.name!.toLowerCase().contains(filter.toLowerCase());
          },
          onChanged: (UserModel? user) {
            // if (user != null) {
            //   FilterStoreMoveCubit.get(context)
            //   .changeUser(user);
            // }
          },
          containerBuilder: (p0, p1) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomFormField(
                    hintText: S.of(context).searchUser,
                    controller: TextEditingController(
                        text: SearchUserCubit.get(context).query),
                    onChanged: (value) =>
                        SearchUserCubit.get(context).onChangeSearch(
                      query: value,
                    ),
                  ),
                ),
                Expanded(
                  child: SearchUserBuild(
                    name: user?.name ?? '',
                    child: p1,
                    onTap: (p0) {
                      onChanged(p0);
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            );
          },
          builder: (UserModel? user) {
            if (user != null) {
              return Text(
                user.name ?? "no name",
                style: AppFontStyle.formText(
                  context: context,
                ),
              );
            } else {
              return SizedBox();
            }
          },
        );
      }),
    );
  }
}
