import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/core/widget/custom_empty_view.dart';
import 'package:pos_app/core/widget/custom_error_view.dart';
import 'package:pos_app/core/widget/custom_pop_up.dart';
import 'package:pos_app/features/categories/data/model/category_model.dart';
import 'package:pos_app/features/categories/manager/get_category/get_category_cubit.dart';

class CategoryCubitBuilder extends StatelessWidget {
  const CategoryCubitBuilder({
    super.key,
    required this.categoriesBuilder,
    required this.categoiresLoading,
    this.errAndLoadingRow = false,
  });
  final Widget Function(BuildContext context, List<CategoryModel> categories)
      categoriesBuilder;
  final Widget Function(BuildContext context) categoiresLoading;
  // I make this bool for only Selling point show (the colum give me overflow)
  final bool errAndLoadingRow;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GetCategoryCubit, GetCategoryState>(
      listener: (context, state) {
        if (state is GetPaginationCategoryError) {
          if (context.mounted) {
            CustomPopUp.callMyPopUp(
              context: context,
              massage: mapStatusCodeToMessage(context, state.errMessage),
              state: PopUpState.ERROR,
            );
          }
        }
      },
      builder: (context, state) {
        if (state is GetCategoryError) {
          return CustomError(
            row: errAndLoadingRow,
            error: context.mounted
                ? mapStatusCodeToMessage(context, state.errMessage)
                : 'error',
            onPressed: () {
              GetCategoryCubit.get(context).getCategories();
            },
          );
        } else if (state is GetCategoryLoading) {
          return categoiresLoading(context);
        }

        if (GetCategoryCubit.get(context).categories.isEmpty) {
          return CustomEmptyView(
            row: errAndLoadingRow,
            onPressed: () => GetCategoryCubit.get(context).getCategories(),
          );
        }
        return categoriesBuilder(
            context, GetCategoryCubit.get(context).categories);
      },
    );
  }
}
