import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/core/helper/my_service_locator.dart';
import 'package:pos_app/core/widget/show_delete_confirm_dialog.dart';
import 'package:pos_app/features/expense_categories/data/model/expense_categories_model.dart';
import 'package:pos_app/features/expense_categories/data/repo/expense_categories_repo.dart';
import 'package:pos_app/features/expense_categories/manager/delete_expense_categories_cubit/delete_expense_categories_cubit.dart';
import 'package:pos_app/features/expense_categories/manager/get_expense_categories_cubit/get_expense_categories_cubit.dart';
import 'package:pos_app/generated/l10n.dart';

Future<bool?> showDeleteExpenseCategoryConfirmDialog(
    {required BuildContext context,
    required ExpenseCategoriesModel expenseCategoriesModel,
    bool goBack = false}) async {
  return await showDeleteConfirmationDialog(
      context: context,
      title: S.of(context).deleteexpensecategories,
      content: expenseCategoriesModel.name ?? S.of(context).noName,
      deleteButtonBuilder: (ctx, button, loading) => BlocProvider(
            create: (context) => DeleteExpenseCategoriesCubit(
                MyServiceLocator.getSingleton<ExpenseCategoriesRepo>()),
            child: BlocConsumer<DeleteExpenseCategoriesCubit,
                DeleteExpenseCategoriesState>(
              listener: (context, state) {
                if (state is DeleteExpenseCategoriesSuccess) {
                  deleteConfirmationDialogSuccess(ctx);
                  MyServiceLocator.getSingleton<GetExpenseCategoriesCubit>()
                      .deleteExpenseCategories(
                    id: state.id,
                  );
                  if (goBack) {
                    Navigator.of(context).pop();
                  }
                } else if (state is DeleteExpenseCategoriesFailing) {
                  if (context.mounted) {
                    deleteConfirmationDialogError(
                        ctx, mapStatusCodeToMessage(context, state.errMessage));
                  }
                }
              },
              builder: (context, state) {
                if (state is DeleteExpenseCategoriesLoading) {
                  return loading;
                }
                return button(
                  context: context,
                  onPressed: () => DeleteExpenseCategoriesCubit.get(context)
                      .deleteExpenseCategories(
                    id: expenseCategoriesModel.id ?? -1,
                  ),
                );
              },
            ),
          ));
}
