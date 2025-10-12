import 'package:flutter/material.dart';
import 'package:pos_app/core/constant/constant.dart';
import 'package:pos_app/features/categories/manager/edit_category/edit_category_cubit.dart';
import 'package:pos_app/features/categories/view/widget/category_data_build.dart';

class EditCategoryMobileBody extends StatelessWidget {
  const EditCategoryMobileBody({
    super.key,
    required this.state,
  });
  final EditCategoryState state;
  @override
  Widget build(BuildContext context) {
    return CategoryDataBuilder(
      formKey: EditCategoryCubit.get(context).formKey,
      autovalidateMode: EditCategoryCubit.get(context).autovalidateMode,
      nameController: EditCategoryCubit.get(context).nameController,
      descriptionController:
          EditCategoryCubit.get(context).descriptionController,
      onTap: () => EditCategoryCubit.get(context).onTap(),
      imageUrl: EditCategoryCubit.get(context).categoryModel.imageUrl,
      onSelected: EditCategoryCubit.get(context).onSelectImage,
      isLoading: state is EditCategoryLoading,
      isEdit: true,
    );
  }
}

class EditCategoryBodyTableteAndDesktop extends StatelessWidget {
  const EditCategoryBodyTableteAndDesktop({
    super.key,
    required this.state,
  });
  final EditCategoryState state;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: SizedBox()),
        Expanded(
          flex: AppConstant.formExpandedTableandMobile,
          child: EditCategoryMobileBody(state: state),
        ),
        const Expanded(child: SizedBox()),
      ],
    );
  }
}
