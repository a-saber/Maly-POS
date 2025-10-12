import 'package:flutter/material.dart';
import 'package:pos_app/core/router/app_route.dart';
import 'package:pos_app/core/utils/app_colors.dart';
import 'package:pos_app/core/utils/app_font_style.dart';
import 'package:pos_app/features/taxes/data/model/taxes_model.dart';
import 'package:pos_app/features/taxes/view/widget/show_delete_taxes_confirm_dialog.dart';
import 'package:pos_app/generated/l10n.dart';
import 'package:redacted/redacted.dart';

class TaxesItemBuild extends StatelessWidget {
  const TaxesItemBuild({super.key, required this.taxes});
  final TaxesModel taxes;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.editTaxes,
          arguments: taxes,
        );
      },
      child: Dismissible(
        onDismissed: (direction) {},
        confirmDismiss: (direction) async {
          return await showDeleteTaxesConfirmDialog(
              context: context, taxes: taxes);
        },
        key: UniqueKey(),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
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
                  taxes.title ?? S.of(context).noName,
                  style: AppFontStyle.itemsTitle(
                    context: context,
                    color: AppColors.black,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  "${taxes.percentage ?? 0} %",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TaxesItemLoading extends StatelessWidget {
  const TaxesItemLoading({super.key});

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
            // Text(
            //   "100 %",
            // ).redacted(
            //   context: context,
            //   redact: true,
            //   configuration: RedactedConfiguration(
            //     animationDuration: const Duration(milliseconds: 800), //default
            //   ),
            // ),
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
