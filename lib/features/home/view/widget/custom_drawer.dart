import 'package:flutter/material.dart';
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
import 'package:pos_app/core/widget/show_delete_confirm_dialog.dart';
import 'package:pos_app/generated/l10n.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key, required this.scaffoldKey});

  final GlobalKey<ScaffoldState> scaffoldKey;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: const BoxDecoration(
              color: AppColors.primary,
            ),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            //color: ColorsManager.white,
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
                          ))
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
                              style: AppFontStyle.itemsTitle(
                                context: context,
                              ),
                            ),
                            Text(
                              CustomUserHiveBox.getUser().name ??
                                  S.of(context).noName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppFontStyle.itemsSubTitle(
                                context: context,
                              ),
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
                          ))
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
                    /////////////////////////////

                    resetAllGetCubit(
                      // ignore: use_build_context_synchronously
                      context,
                    );
                    //////////////////////////////
                    Navigator.pushNamedAndRemoveUntil(
                      // ignore: use_build_context_synchronously
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
  }
}
