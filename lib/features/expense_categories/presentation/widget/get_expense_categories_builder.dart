import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/core/widget/custom_empty_view.dart';
import 'package:pos_app/core/widget/custom_error_view.dart';
import 'package:pos_app/core/widget/custom_pop_up.dart';
import 'package:pos_app/features/expense_categories/data/model/expense_categories_model.dart';
import 'package:pos_app/features/expense_categories/manager/get_expense_categories_cubit/get_expense_categories_cubit.dart';

class GetExpenseCategoriesBuilder extends StatelessWidget {
  const GetExpenseCategoriesBuilder(
      {super.key,
      required this.expenseCategoriesLoading,
      required this.expenseCategoriesSuccess});
  final Widget Function(BuildContext context) expenseCategoriesLoading;
  final Widget Function(BuildContext context, List<ExpenseCategoriesModel>)
      expenseCategoriesSuccess;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GetExpenseCategoriesCubit, GetExpenseCategoriesState>(
      listener: (context, state) {
        if (state is GetExpenseCategoriesPaginationFailing) {
          if (context.mounted) {
            CustomPopUp.callMyPopUp(
                context: context,
                massage: mapStatusCodeToMessage(context, state.errMessage),
                state: PopUpState.ERROR);
          }
        }
      },
      builder: (context, state) {
        if (state is GetExpenseCategoriesFailing) {
          return CustomError(
            error: context.mounted
                ? mapStatusCodeToMessage(context, state.errMessage)
                : "error",
            onPressed: () =>
                GetExpenseCategoriesCubit.get(context).getExpenseCategories(),
          );
        } else if (state is GetExpenseCategoriesLoading) {
          return expenseCategoriesLoading(context);
        }

        if (GetExpenseCategoriesCubit.get(context).expenseCategories.isEmpty) {
          return CustomEmptyView(
            onPressed: () =>
                GetExpenseCategoriesCubit.get(context).getExpenseCategories(),
          );
        }
        return expenseCategoriesSuccess(
            context, GetExpenseCategoriesCubit.get(context).expenseCategories);
      },
    );
  }
}
