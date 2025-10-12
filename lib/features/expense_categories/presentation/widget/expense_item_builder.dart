import 'package:flutter/material.dart';
import 'package:pos_app/core/router/app_route.dart';
import 'package:pos_app/core/utils/app_colors.dart';
import 'package:pos_app/core/utils/app_font_style.dart';
import 'package:pos_app/features/expense_categories/data/model/expense_categories_model.dart';
import 'package:pos_app/features/expense_categories/presentation/widget/show_delete_expense_category_confirm_dialog.dart';
import 'package:pos_app/generated/l10n.dart';
import 'package:redacted/redacted.dart';

class ExpenseItemBuilder extends StatelessWidget {
  const ExpenseItemBuilder({super.key, required this.expenseCategorie});
  final ExpenseCategoriesModel expenseCategorie;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.editexpenseCategoriesView,
          arguments: expenseCategorie,
        );
      },
      child: Dismissible(
        onDismissed: (direction) {},
        confirmDismiss: (direction) async {
          return await showDeleteExpenseCategoryConfirmDialog(
            context: context,
            expenseCategoriesModel: expenseCategorie,
          );
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
                  expenseCategorie.name ?? S.of(context).noName,
                  style: AppFontStyle.itemsTitle(
                    context: context,
                    color: AppColors.black,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                expenseCategorie.description == null
                    ? const SizedBox.shrink()
                    : Text(
                        expenseCategorie.description!,
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

class ExpenseItemBuilderLoading extends StatelessWidget {
  const ExpenseItemBuilderLoading({super.key});

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
              "expanse name",
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
