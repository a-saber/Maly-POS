import 'package:flutter/material.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:pos_app/core/helper/formate_date_time.dart';
import 'package:pos_app/core/router/app_route.dart';
import 'package:pos_app/core/utils/app_colors.dart';
import 'package:pos_app/core/utils/app_font_style.dart';
import 'package:pos_app/core/widget/custom_cach_network_image.dart';
import 'package:pos_app/features/store_move/data/model/store_movement_data.dart';
import 'package:pos_app/features/store_move/manager/store_move_cubit/store_move_cubit.dart';
import 'package:pos_app/generated/l10n.dart';
import 'package:redacted/redacted.dart';

class StoreMoveItemBuild extends StatelessWidget {
  const StoreMoveItemBuild({super.key, required this.storeMove});

  final StoreMovementData storeMove;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.storeMoveDetailsView,
          arguments: storeMove,
        );
      },
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
              imageUrl: storeMove.product?.imageUrl,
              borderRadius: BorderRadius.circular(15),
              imageBuilder: (imageProvider) => Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover)),
              ),
              width: 75,
              height: 85,
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextHighlight(
                          text: storeMove.product?.name ??
                              S
                                  .of(context)
                                  .noName, // You need to pass the string you want the highlights
                          words: {
                            StoreMoveCubit.get(context).query: HighlightedWord(
                              decoration: BoxDecoration(
                                color: Colors.yellow,
                              ),
                            ),
                          }, // Your dictionary words
                          textStyle: AppFontStyle.itemsTitle(
                            context: context,
                            color: AppColors.black,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                        ),
                      ),

                      // Text(
                      //   storeMove.product?.name ?? S.of(context).noName,
                      //   style: AppFontStyle.itemsTitle(
                      //     context: context,
                      //     color: AppColors.black,
                      //   ),
                      // ),
                      Text(
                        "${storeMove.quantity} items",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppFontStyle.itemssmallTitle(
                          context: context,
                          color: AppColors.black,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    storeMove.user?.name ?? S.of(context).noName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppFontStyle.itemsSubTitle(
                      context: context,
                      color: AppColors.black,
                    ),
                  ),
                  Text(
                    storeMove.createdAt == null
                        ? ""
                        : getLocalTimeFormate(storeMove.createdAt!),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppFontStyle.itemsSubTitle(
                      context: context,
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StoreMoveItemBuildLoading extends StatelessWidget {
  const StoreMoveItemBuildLoading({super.key});

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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "name : name",
                      style: AppFontStyle.itemsTitle(
                        context: context,
                        color: AppColors.black,
                      ),
                    ).redacted(
                      context: context,
                      redact: true,
                      configuration: RedactedConfiguration(
                        animationDuration:
                            const Duration(milliseconds: 800), //default
                      ),
                    ),
                    Text(
                      "10 items",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
                Text(
                  "Amr Ali",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ).redacted(
                  context: context,
                  redact: true,
                  configuration: RedactedConfiguration(
                    animationDuration:
                        const Duration(milliseconds: 800), //default
                  ),
                ),
                Text(
                  "10:00 AM 5 Jan 2025",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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
