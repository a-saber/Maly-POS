import 'package:flutter/material.dart';
import 'package:pos_app/core/router/app_route.dart';
import 'package:pos_app/core/utils/app_padding.dart';
import 'package:pos_app/core/widget/custom_app_bar.dart';
import 'package:pos_app/core/widget/custom_floating_action_btn.dart';
import 'package:pos_app/core/widget/custom_refresh_indicator.dart';
import 'package:pos_app/features/categories/manager/get_category/get_category_cubit.dart';
import 'package:pos_app/features/categories/view/widget/category_cubit_builder.dart';
import 'package:pos_app/features/categories/view/widget/show_list_of_category.dart';
import 'package:pos_app/features/categories/view/widget/show_list_of_category_loading.dart';
import 'package:pos_app/generated/l10n.dart';

class CategoriesView extends StatelessWidget {
  const CategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: CustomFloatingActionBtn(
        onPressed: () {
          Navigator.pushNamed(
            context,
            AppRoutes.addCategory,
          );
        },
      ),
      appBar: CustomAppBar(title: S.of(context).categories),
      body: Padding(
        padding: AppPaddings.defaultView,
        child: CustomRefreshIndicator(
          onRefresh: () async {
            return await GetCategoryCubit.get(context).getCategories();
          },
          child: CategoryCubitBuilder(
            categoiresLoading: (context) => ShowListOfCategoryLaoding(),
            categoriesBuilder: (context, categories) =>
                ShowListOfCategory(categories: categories),
          ),
        ),
      ),
    );
  }
}
