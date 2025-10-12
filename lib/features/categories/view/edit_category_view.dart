import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/core/helper/my_service_locator.dart';
import 'package:pos_app/core/widget/custom_app_bar.dart';
import 'package:pos_app/core/widget/custom_btn.dart';
import 'package:pos_app/core/widget/custom_pop_up.dart';
import 'package:pos_app/core/widget/cutsom_layout_builder.dart';
import 'package:pos_app/core/widget/my_custom_scroll_view.dart';
import 'package:pos_app/features/categories/data/model/category_model.dart';
import 'package:pos_app/features/categories/data/repo/category_repo.dart';
import 'package:pos_app/features/categories/manager/edit_category/edit_category_cubit.dart';
import 'package:pos_app/features/categories/manager/get_category/get_category_cubit.dart';
import 'package:pos_app/features/categories/view/widget/edit_category_body.dart';
import 'package:pos_app/features/categories/view/widget/show_delete_category_confirm_dialog.dart';
import 'package:pos_app/generated/l10n.dart';

class EditCategoryView extends StatelessWidget {
  const EditCategoryView({super.key, required this.category});
  final CategoryModel category;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditCategoryCubit(
        MyServiceLocator.getSingleton<CategoryRepo>(),
        category,
      ),
      child: Scaffold(
        appBar: CustomAppBar(
          title: S.of(context).addCategory,
          actions: [
            CustomTextBtn(
                text: S.of(context).delete,
                onPressed: () async {
                  await showDeleteCategoryConfirmDialog(
                      context: context, category: category, goBack: true);
                })
          ],
        ),
        body: BlocConsumer<EditCategoryCubit, EditCategoryState>(
          listener: (context, state) {
            if (state is EditCategorySuccess) {
              GetCategoryCubit.get(context).updateCategory(
                state.category,
              );

              CustomPopUp.callMyToast(
                  context: context,
                  massage: S.of(context).addedSuccess,
                  state: PopUpState.SUCCESS);
              Navigator.pop(context);
            } else if (state is EditCategoryFailing) {
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
                child: EditCategoryMobileBody(
                  state: state,
                ),
              ),
              tablet: MyCustomScrollView(
                child: EditCategoryBodyTableteAndDesktop(
                  state: state,
                ),
              ),
              desktop: MyCustomScrollView(
                child: EditCategoryBodyTableteAndDesktop(
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
