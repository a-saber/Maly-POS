import 'package:flutter/material.dart';
import 'package:pos_app/core/widget/custom_grid_view_card.dart';
import 'package:pos_app/features/categories/data/model/category_model.dart';
import 'package:pos_app/features/categories/manager/get_category/get_category_cubit.dart';
import 'package:pos_app/features/categories/view/widget/category_item_builder.dart';

class ShowListOfCategory extends StatelessWidget {
  const ShowListOfCategory({super.key, required this.categories});
  final List<CategoryModel> categories;
  @override
  Widget build(BuildContext context) {
    return CustomGridViewCard(
      canLaoding: GetCategoryCubit.get(context).canLoading(),
      controller: GetCategoryCubit.get(context).scrollController,
      itemCount: categories.length,
      itemBuilder: (context, index) => CategoryItemBuilder(
        index: index,
        category: categories[index],
      ),
    );
  }
}
