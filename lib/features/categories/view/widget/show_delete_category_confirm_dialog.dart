import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/core/helper/my_service_locator.dart';
import 'package:pos_app/core/widget/show_delete_confirm_dialog.dart';
import 'package:pos_app/features/categories/data/model/category_model.dart';
import 'package:pos_app/features/categories/data/repo/category_repo.dart';
import 'package:pos_app/features/categories/manager/delete_category/delete_category_cubit.dart';
import 'package:pos_app/features/categories/manager/get_category/get_category_cubit.dart';
import 'package:pos_app/generated/l10n.dart';

Future<bool?> showDeleteCategoryConfirmDialog(
    {required BuildContext context,
    required CategoryModel category,
    bool goBack = false}) async {
  return await showDeleteConfirmationDialog(
    context: context,
    title: S.of(context).deleteCategory,
    content: category.name ?? '',
    deleteButtonBuilder: (ctx, button, loading) => BlocProvider(
      create: (context) =>
          DeleteCategoryCubit(MyServiceLocator.getSingleton<CategoryRepo>()),
      child: BlocConsumer<DeleteCategoryCubit, DeleteCategoryState>(
        listener: (context, state) {
          if (state is DeleteCategorySuccess) {
            deleteConfirmationDialogSuccess(ctx);
            // can use getit
            MyServiceLocator.getSingleton<GetCategoryCubit>().deleteCategory(
              state.id,
            );

            if (goBack) {
              Navigator.of(context).pop();
            }
          } else if (state is DeleteCategoryFailing) {
            if (context.mounted) {
              deleteConfirmationDialogError(
                  ctx, mapStatusCodeToMessage(context, state.errMessage));
            }
          }
        },
        builder: (context, state) {
          if (state is DeleteCategoryLoading) {
            return loading;
          }
          return button(
            context: context,
            onPressed: () => DeleteCategoryCubit.get(context).deleteCategory(
              category: category,
            ),
          );
        },
      ),
    ),
  );
}
