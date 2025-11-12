import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/cache/cache_helper.dart';
import 'package:pos_app/core/cache/cache_keys.dart';
import 'package:pos_app/core/cache/custom_secure_storage.dart';
import 'package:pos_app/core/cache/custom_user_hive_box.dart';
import 'package:pos_app/core/constant/device_size.dart';
import 'package:pos_app/core/helper/reset_all_get_cubit.dart';
import 'package:pos_app/core/router/app_route.dart';
import 'package:pos_app/core/utils/app_asset.dart';
import 'package:pos_app/core/utils/app_colors.dart';
import 'package:pos_app/core/utils/app_font_style.dart';
import 'package:pos_app/core/widget/custom_btn.dart';
import 'package:pos_app/core/widget/show_delete_confirm_dialog.dart';
import 'package:pos_app/features/shifts/manager/shift_cubit/shift_cubit.dart';
import 'package:pos_app/features/shifts/manager/shift_cubit/shift_state.dart';
import 'package:pos_app/features/shifts/view/widget/showdialog_for_end.dart';
import 'package:pos_app/features/shifts/view/widget/showdialog_for_shift.dart';
import 'package:pos_app/generated/l10n.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key, required this.scaffoldKey});

  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShiftCubit, ShiftState>(
      listener: (context, state) {
        if (state is ShiftSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is ShiftError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        return Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                ),
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: DeviceSize.getHeight(context: context) * 0.02,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10.0)),
                            child: SizedBox(
                              height: 60,
                              width: 60,
                              child: Image.asset(
                                ImagesAsset.logo,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              scaffoldKey.currentState?.closeDrawer();
                            },
                            icon: const Icon(
                              Icons.cancel,
                              color: AppColors.white,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: DeviceSize.getHeight(context: context) * 0.02,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  S.of(context).hello,
                                  style:
                                      AppFontStyle.itemsTitle(context: context),
                                ),
                                Text(
                                  CustomUserHiveBox.getUser().name ??
                                      S.of(context).noName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppFontStyle.itemsSubTitle(
                                      context: context),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            splashColor: AppColors.white,
                            onPressed: () {
                              Navigator.pushNamed(context, AppRoutes.profile);
                            },
                            icon: const Icon(
                              Icons.edit_square,
                              color: AppColors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: Text(S.of(context).settings),
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.settingsView);
                },
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 32,
                        child: CustomFilledBtn(
                          text: 'Start',
                          backgroundColor: Colors.blueAccent,
                          onPressed: state is ShiftLoading
                              ? () {}
                              : () => showStartShiftDialog(context),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: SizedBox(
                        height: 32,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.blueAccent),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: CustomFilledBtn(
                            text: 'End',
                            backgroundColor: Colors.transparent,
                            onPressed: state is ShiftLoading
                                ? () {}
                                : () => showEndShiftDialog(context),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: Text(S.of(context).logout),
                onTap: () {
                  showDeleteConfirmationDialog(
                    context: context,
                    title: S.of(context).logout,
                    content: S.of(context).sureWannaLogOut,
                    deleteButtonBuilder: (ctx, button, loading) => button(
                      context: ctx,
                      title: S.of(context).logout,
                      onPressed: () async {
                        await CacheHelper.saveData(
                          key: CacheKeys.isLogin,
                          value: false,
                        );
                        CacheHelper.removeData(key: CacheKeys.accessToken);
                        CacheHelper.removeData(key: CacheKeys.domain);
                        await CustomSecureStorage.delete(
                          key: CacheKeys.accessToken,
                        );
                        await CustomSecureStorage.delete(
                          key: CacheKeys.domain,
                        );
                        CustomUserHiveBox.removeUser();

                        resetAllGetCubit(context);

                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          AppRoutes.login,
                          (route) => false,
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
