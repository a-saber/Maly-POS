import 'package:flutter/material.dart';
import 'package:pos_app/core/router/app_route.dart';
import 'package:pos_app/core/utils/app_colors.dart';
import 'package:pos_app/core/utils/app_font_style.dart';
import 'package:pos_app/features/discounts/data/model/discount_model.dart';
import 'package:pos_app/features/discounts/data/model/discount_type.dart';
import 'package:pos_app/features/discounts/view/widget/show_delete_discount_confirm_dialog.dart';
import 'package:pos_app/generated/l10n.dart';
import 'package:redacted/redacted.dart';

class DiscountItemBuild extends StatelessWidget {
  const DiscountItemBuild({super.key, required this.discount});
  final DiscountModel discount;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.editDiscount,
          arguments: discount,
        );
      },
      child: Dismissible(
        onDismissed: (direction) {},
        confirmDismiss: (direction) async {
          return await showDeleteDiscountConfirmDialog(
              context: context, discount: discount);
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
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: Padding(
              padding: EdgeInsetsDirectional.only(start: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    discount.title ?? S.of(context).noName,
                    style: AppFontStyle.itemsTitle(
                      context: context,
                      color: AppColors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    discount.type == DiscountType.percentage
                        ? "${discount.value} %"
                        : "${discount.value} ",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DiscountItemLoading extends StatelessWidget {
  const DiscountItemLoading({super.key});

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
            Text(
              "unit name",
              style: AppFontStyle.itemsTitle(
                context: context,
                color: AppColors.black,
              ),
            ).redacted(
              context: context,
              redact: true,
              configuration: RedactedConfiguration(
                animationDuration: const Duration(milliseconds: 800), //default
              ),
            ),
            Text(
              "100 %",
            ).redacted(
              context: context,
              redact: true,
              configuration: RedactedConfiguration(
                animationDuration: const Duration(milliseconds: 800), //default
              ),
            ),
            Text(
              "descriptiondescription",
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
