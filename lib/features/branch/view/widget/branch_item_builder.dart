import 'package:flutter/material.dart';
import 'package:pos_app/core/helper/my_copy_clipboard.dart';
import 'package:pos_app/core/router/app_route.dart';
import 'package:pos_app/core/utils/app_colors.dart';
import 'package:pos_app/core/utils/app_font_style.dart';
import 'package:pos_app/features/branch/view/widget/show_delete_branch_confirm_dialog.dart';
import 'package:pos_app/generated/l10n.dart';
import 'package:redacted/redacted.dart';
import 'package:pos_app/features/auth/login/data/model/branche_model.dart';

class BranchItemBuilder extends StatelessWidget {
  const BranchItemBuilder({super.key, required this.branch});

  final BrancheModel branch;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.editBranch,
          arguments: branch,
        );
      },
      onLongPress: () {
        myCopyToClipboard(context, branch.address.toString());
      },
      child: Dismissible(
        onDismissed: (direction) {},
        confirmDismiss: (direction) async {
          return await showDeleteBranchConfirmDialog(
            context: context,
            branch: branch,
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
              // CustomCachedNetworkImage(
              //   imageUrl:
              //       'https://images.pexels.com/photos/269077/pexels-photo-269077.jpeg?_gl=1*1m3i365*_ga*Nzk3MzQxMDE0LjE3Mjg2NTQyOTQ.*_ga_8JE65Q40S6*czE3NTM3MDAyNTQkbzE0JGcxJHQxNzUzNzAwMjk5JGoxNSRsMCRoMA..',
              //   borderRadius: BorderRadius.circular(15),
              //   imageBuilder: (imageProvider) => Container(
              //     decoration: BoxDecoration(
              //         image: DecorationImage(
              //             image: imageProvider, fit: BoxFit.cover)),
              //   ),
              //   width: 75,
              //   height: 75,
              // ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      branch.name ?? S.of(context).noName,
                      style: AppFontStyle.itemsTitle(
                        context: context,
                        color: AppColors.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    branch.address == null
                        ? const SizedBox()
                        : Text(
                            branch.address ?? '',
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

class BranchCardLoading extends StatelessWidget {
  const BranchCardLoading({super.key});

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
          // Container(
          //   width: 75,
          //   height: 75,
          //   color: Colors.grey,
          // ).redacted(
          //   context: context,
          //   redact: true,
          //   configuration: RedactedConfiguration(
          //     animationDuration: const Duration(milliseconds: 800), //default
          //   ),
          // ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "branchname",
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
                  "addressaddress",
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
          ),
        ],
      ),
    );
  }
}
