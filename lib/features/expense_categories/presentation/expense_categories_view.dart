import 'package:flutter/material.dart';
import 'package:pos_app/core/constant/constant.dart';
import 'package:pos_app/core/router/app_route.dart';
import 'package:pos_app/core/widget/custom_app_bar.dart';
import 'package:pos_app/core/widget/custom_floating_action_btn.dart';
import 'package:pos_app/core/widget/custom_grid_view_card.dart';
import 'package:pos_app/core/widget/custom_refresh_indicator.dart';
import 'package:pos_app/features/expense_categories/manager/get_expense_categories_cubit/get_expense_categories_cubit.dart';
import 'package:pos_app/features/expense_categories/presentation/widget/expense_item_builder.dart';
import 'package:pos_app/features/expense_categories/presentation/widget/get_expense_categories_builder.dart';
import 'package:pos_app/generated/l10n.dart';

import '../../../core/utils/app_padding.dart';

class ExpenseCategoriesView extends StatelessWidget {
  const ExpenseCategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: CustomFloatingActionBtn(onPressed: () {
        Navigator.pushNamed(context, AppRoutes.addexpenseCategoriesView);
      }),
      appBar: CustomAppBar(title: S.of(context).expensecategories),
      body: CustomRefreshIndicator(
        onRefresh: () async {
          GetExpenseCategoriesCubit.get(context).getExpenseCategories();
        },
        child: Padding(
          padding: AppPaddings.defaultView,
          child: GetExpenseCategoriesBuilder(
            expenseCategoriesLoading: (context) {
              return CustomGridViewCard(
                itemBuilder: (context, index) {
                  return ExpenseItemBuilderLoading();
                },
                itemCount: AppConstant.numberOfCardLoading,
              );
            },
            expenseCategoriesSuccess: (context, expenseCategories) {
              return CustomGridViewCard(
                  controller:
                      GetExpenseCategoriesCubit.get(context).scrollController,
                  canLaoding:
                      GetExpenseCategoriesCubit.get(context).canLoading(),
                  itemBuilder: (context, index) => ExpenseItemBuilder(
                        expenseCategorie: expenseCategories[index],
                      ),
                  itemCount: expenseCategories.length);
            },
          ),
        ),
      ),
    );
  }
}
