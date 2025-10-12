import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/helper/my_form_validators.dart';
import 'package:pos_app/core/helper/my_service_locator.dart';
import 'package:pos_app/core/utils/app_font_style.dart';
import 'package:pos_app/core/widget/custom_drop_down.dart';
import 'package:pos_app/core/widget/custom_form_field.dart';
import 'package:pos_app/features/categories/data/model/category_model.dart';
import 'package:pos_app/features/categories/manager/search_category/search_category_cubit.dart';
import 'package:pos_app/features/categories/view/widget/search_category_build.dart';
import 'package:pos_app/generated/l10n.dart';

class CustomDropDownCategory extends StatelessWidget {
  const CustomDropDownCategory({
    super.key,
    this.value,
    required this.onChangedCategory,
  });

  final CategoryModel? value;
  final Function(CategoryModel?) onChangedCategory;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: MyServiceLocator.getSingleton<SearchCategoryCubit>(),
      child: Builder(builder: (context) {
        return CustomDropdown<CategoryModel>(
          // search: true,
          hint: S.of(context).selectCategory,
          compareFn: (item1, item2) {
            if (item1.name == null || item2.name == null) {
              return false;
            } else {
              return (item1.name!
                      .toLowerCase()
                      .contains(item2.name!.toLowerCase()) ||
                  item2.name!
                      .toLowerCase()
                      .contains(item1.name!.toLowerCase()));
            }
          },
          validator: (value) =>
              MyFormValidators.validateTypeRequired<CategoryModel>(value,
                  context: context),
          value: value,
          items: SearchCategoryCubit.get(context).categories,
          filterFn: (item, filter) {
            return item.name?.toLowerCase().contains(filter.toLowerCase()) ??
                false;
          },
          onChanged: (CategoryModel? category) {
            // if (category != null) {
            //   widget.onChangedGroup(category);
            // }
          },
          containerBuilder: (p0, p1) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomFormField(
                    hintText: S.of(context).searchCategory,
                    controller: TextEditingController(
                        text: SearchCategoryCubit.get(context).query),
                    onChanged: (value) =>
                        SearchCategoryCubit.get(context).onChangeSearch(
                      query: value,
                    ),
                  ),
                ),
                Expanded(
                  child: SearchCategoryBuild(
                    name: value?.name ?? '',
                    child: p1,
                    onTap: (p0) {
                      onChangedCategory(p0);
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            );
          },
          builder: (CategoryModel? category) {
            if (category != null) {
              return Text(
                category.name ?? '-',
                style: AppFontStyle.formText(
                  context: context,
                ),
              );
            } else {
              return SizedBox();
            }
          },
        );
      }),
    );
  }
}
