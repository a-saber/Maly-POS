import 'package:flutter/material.dart';
import 'package:pos_app/core/constant/constant.dart';
import 'package:pos_app/features/categories/manager/add_category/add_gategory_cubit.dart';
import 'package:pos_app/features/categories/view/widget/category_data_build.dart';

class AddCategoryBodyTableteAndDesktop extends StatelessWidget {
  const AddCategoryBodyTableteAndDesktop({super.key, required this.state});
  final AddCategoryState state;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: SizedBox()),
        Expanded(
          flex: AppConstant.formExpandedTableandMobile,
          child: AddCategoryMobileBody(
            state: state,
          ),
        ),
        const Expanded(child: SizedBox()),
      ],
    );
  }
}

class AddCategoryMobileBody extends StatelessWidget {
  const AddCategoryMobileBody({
    super.key,
    required this.state,
  });
  final AddCategoryState state;
  @override
  Widget build(BuildContext context) {
    return CategoryDataBuilder(
      formKey: AddCategoryCubit.get(context).formKey,
      autovalidateMode: AddCategoryCubit.get(context).autovalidateMode,
      nameController: AddCategoryCubit.get(context).nameController,
      descriptionController:
          AddCategoryCubit.get(context).descriptionController,
      onTap: () => AddCategoryCubit.get(context).onTap(),
      onSelected: AddCategoryCubit.get(context).onSelectImage,
      isLoading: state is AddCategoryLoading,
      isEdit: false,
    );
  }
}
