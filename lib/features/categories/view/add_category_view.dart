import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/core/helper/my_service_locator.dart';
import 'package:pos_app/core/widget/custom_app_bar.dart';
import 'package:pos_app/core/widget/custom_pop_up.dart';
import 'package:pos_app/core/widget/cutsom_layout_builder.dart';
import 'package:pos_app/core/widget/my_custom_scroll_view.dart';
import 'package:pos_app/features/categories/data/repo/category_repo.dart';
import 'package:pos_app/features/categories/manager/add_category/add_gategory_cubit.dart';
import 'package:pos_app/features/categories/manager/get_category/get_category_cubit.dart';
import 'package:pos_app/features/categories/view/widget/add_category_body.dart';
import 'package:pos_app/generated/l10n.dart';

class AddCategoryView extends StatelessWidget {
  const AddCategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AddCategoryCubit(MyServiceLocator.getSingleton<CategoryRepo>()),
      child: Scaffold(
        appBar: CustomAppBar(title: S.of(context).addCategory),
        body: BlocConsumer<AddCategoryCubit, AddCategoryState>(
          listener: (context, state) {
            if (state is AddCategorySuccess) {
              GetCategoryCubit.get(context).addCategory(state.category);
              CustomPopUp.callMyToast(
                  context: context,
                  massage: S.of(context).addedSuccess,
                  state: PopUpState.SUCCESS);
              Navigator.pop(context);
            } else if (state is AddCategoryFailing) {
              if (context.mounted) {
                CustomPopUp.callMyPopUp(
                    context: context,
                    massage: mapStatusCodeToMessage(
                      context,
                      state.errMessage,
                    ),
                    state: PopUpState.ERROR);
              }
            }
          },
          builder: (context, state) {
            return CustomLayoutBuilder(
              mobile: MyCustomScrollView(
                child: AddCategoryMobileBody(
                  state: state,
                ),
              ),
              tablet: MyCustomScrollView(
                child: AddCategoryBodyTableteAndDesktop(
                  state: state,
                ),
              ),
              desktop: MyCustomScrollView(
                child: AddCategoryBodyTableteAndDesktop(
                  state: state,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
