import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pos_app/core/helper/formate_date_time.dart';
import 'package:pos_app/core/router/app_route.dart';
import 'package:pos_app/core/utils/app_colors.dart';
import 'package:pos_app/core/utils/app_font_style.dart';
import 'package:pos_app/features/sales/data/model/sales_model.dart';
import 'package:pos_app/generated/l10n.dart';
import 'package:redacted/redacted.dart';

class SalesItemBuild extends StatelessWidget {
  const SalesItemBuild({super.key, required this.salesModel});
  final SalesModel salesModel;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.salesDetailsView,
          arguments: salesModel,
        );
      },
      key: UniqueKey(),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: salesModel.salesReturnId != null
                ? AppColors.grey
                : AppColors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withAlpha(25),
                blurRadius: 7,
                blurStyle: BlurStyle.outer,
              ),
            ]),
        child: Align(
          alignment: AlignmentDirectional.centerStart,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ID + Date Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      spacing: 6,
                      children: [
                        icon(
                          Icons.tag,
                          context: context,
                        ),
                        Expanded(
                          child: Text(
                            "${salesModel.id ?? S.of(context).unknown}",
                            style: AppFontStyle.itemsTitle(
                              context: context,
                              color: AppColors.black,
                            ).copyWith(fontWeight: FontWeight.w600),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      salesModel.createdAt != null
                          ? getLocalTimeFormate(salesModel.createdAt!)
                          : S.of(context).unknownDate,
                      style: AppFontStyle.itemssmallTitle(
                        context: context,
                        color: AppColors.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),

              // const SizedBox(height: 6),

              // User
              Row(
                spacing: 6,
                children: [
                  icon(
                    Icons.person,
                    context: context,
                  ),
                  Expanded(
                    child: Text(
                      salesModel.user?.name ?? S.of(context).unknown,
                      style: AppFontStyle.itemsTitle(
                        context: context,
                        color: AppColors.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 6),

              // Branch
              Row(
                spacing: 6,
                children: [
                  icon(
                    Icons.store,
                    context: context,
                  ),
                  Expanded(
                    child: Text(
                      salesModel.branch?.name ?? S.of(context).unknown,
                      style: AppFontStyle.itemsTitle(
                        context: context,
                        color: AppColors.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 6),

              // Price
              Row(
                spacing: 6,
                children: [
                  icon(
                    Icons.money,
                    context: context,
                  ),
                  Expanded(
                    child: Text(
                      "${salesModel.totalAfterTax ?? S.of(context).unknown} ",
                      style: AppFontStyle.itemsTitle(
                        context: context,
                        color: AppColors.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 6),

              // Discount (if exists)
              if (salesModel.discount != null)
                Row(
                  spacing: 6,
                  children: [
                    icon(
                      Icons.discount,
                      context: context,
                    ),
                    Expanded(
                      child: Text(
                        "${salesModel.discountTotal ?? S.of(context).unknown} ",
                        style: AppFontStyle.itemsTitle(
                          context: context,
                          color: AppColors.black,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget icon(
    IconData icon, {
    required BuildContext context,
  }) {
    return Icon(
      icon,
      size: min(
        MediaQuery.of(context).size.width * 0.03,
        MediaQuery.of(context).size.height * 0.03,
      ).clamp(
        25,
        50,
      ),
      color:
          salesModel.salesReturnId != null ? AppColors.black : AppColors.grey,
    );
  }
}

class SalesItemLoadingBuild extends StatelessWidget {
  const SalesItemLoadingBuild({
    super.key,
  });

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
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "id : 0",
                  style: AppFontStyle.itemsTitle(
                    context: context,
                    color: AppColors.black,
                  ),
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
                  "2.2 am 10/10/2022",
                  style: AppFontStyle.s8(
                    context: context,
                    color: AppColors.black,
                  ),
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
              "price : 10\$",
              style: AppFontStyle.itemsTitle(
                context: context,
                color: AppColors.black,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ).redacted(
              context: context,
              redact: true,
              configuration: RedactedConfiguration(
                animationDuration: const Duration(milliseconds: 800), //default
              ),
            ),
            Text(
              "discount : 5 \$",
              style: AppFontStyle.itemsTitle(
                context: context,
                color: AppColors.black,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
                .redacted(
                  context: context,
                  redact: true,
                  configuration: RedactedConfiguration(
                    animationDuration:
                        const Duration(milliseconds: 800), //default
                  ),
                )
                .redacted(
                  context: context,
                  redact: true,
                  configuration: RedactedConfiguration(
                    animationDuration:
                        const Duration(milliseconds: 800), //default
                  ),
                ),
            Text(
              "user : name",
              style: AppFontStyle.itemsTitle(
                context: context,
                color: AppColors.black,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ).redacted(
              context: context,
              redact: true,
              configuration: RedactedConfiguration(
                animationDuration: const Duration(milliseconds: 800), //default
              ),
            ),
            Text(
              "branch : name",
              style: AppFontStyle.itemsTitle(
                context: context,
                color: AppColors.black,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ).redacted(
              context: context,
              redact: true,
              configuration: RedactedConfiguration(
                animationDuration: const Duration(milliseconds: 800), //default
              ),
            ),
          ],
        ),
      ),
    );
  }
}
