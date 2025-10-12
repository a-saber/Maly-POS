import 'package:flutter/material.dart';
import 'package:pos_app/core/helper/my_copy_clipboard.dart';
import 'package:pos_app/core/router/app_route.dart';
import 'package:pos_app/core/utils/app_colors.dart';
import 'package:pos_app/core/utils/app_font_style.dart';
import 'package:pos_app/core/widget/custom_cach_network_image.dart';
import 'package:pos_app/features/auth/login/data/model/user_model.dart';
import 'package:pos_app/features/users/view/widget/delete_user_confirm_dialog.dart';
import 'package:redacted/redacted.dart';

class UserItemBuilder extends StatelessWidget {
  const UserItemBuilder({super.key, required this.user});

  final UserModel user;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.editUser,
          arguments: user,
        );
      },
      onLongPress: () {
        myCopyToClipboard(context, user.phone.toString());
      },
      child: Dismissible(
        onDismissed: (direction) {},
        confirmDismiss: (direction) async {
          return await showDeleteUserConfirmDialog(
            context: context,
            user: user,
          );
        },
        key: UniqueKey(),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withAlpha(25),
                  blurRadius: 7,
                  blurStyle: BlurStyle.outer,
                ),
              ]),
          child: Row(
            children: [
              CustomCachedNetworkImage(
                imageUrl: user.imageUrl,
                borderRadius: BorderRadius.circular(15),
                imageBuilder: (imageProvider) => Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: imageProvider, fit: BoxFit.cover)),
                ),
                width: 75,
                height: 75,
              ),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      user.name ?? '',
                      style: AppFontStyle.itemsTitle(
                        context: context,
                        color: AppColors.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    user.phone == null
                        ? const SizedBox()
                        : Text(
                            user.phone ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                    user.role == null
                        ? const SizedBox()
                        : Text(
                            user.role?.name ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserCardLoading extends StatelessWidget {
  const UserCardLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withAlpha(25),
              blurRadius: 7,
              blurStyle: BlurStyle.outer,
            ),
          ]),
      child: Row(
        children: [
          Container(
            width: 75,
            height: 75,
            color: Colors.grey,
          ).redacted(
            context: context,
            redact: true,
            configuration: RedactedConfiguration(
              animationDuration: const Duration(milliseconds: 800), //default
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "user.name",
                style: AppFontStyle.itemsTitle(context: context),
              ).redacted(
                context: context,
                redact: true,
                configuration: RedactedConfiguration(
                  animationDuration:
                      const Duration(milliseconds: 800), //default
                ),
              ),
              Text(
                "0101010101",
              ).redacted(
                context: context,
                redact: true,
                configuration: RedactedConfiguration(
                  animationDuration:
                      const Duration(milliseconds: 800), //default
                ),
              ),
              Text(
                "useradm",
              ).redacted(
                context: context,
                redact: true,
                configuration: RedactedConfiguration(
                  animationDuration:
                      const Duration(milliseconds: 800), //default
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
