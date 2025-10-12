import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/core/constant/constant.dart';
import 'package:pos_app/core/helper/my_service_locator.dart';
import 'package:pos_app/core/widget/custom_app_bar.dart';
import 'package:pos_app/core/widget/custom_btn.dart';
import 'package:pos_app/core/widget/custom_pop_up.dart';
import 'package:pos_app/core/widget/cutsom_layout_builder.dart';
import 'package:pos_app/core/widget/my_custom_scroll_view.dart';
import 'package:pos_app/features/expense_categories/data/model/expense_categories_model.dart';
import 'package:pos_app/features/expense_categories/data/repo/expense_categories_repo.dart';
import 'package:pos_app/features/expense_categories/manager/edit_expense_categories_cubit/edit_expense_categories_cubit.dart';
import 'package:pos_app/features/expense_categories/manager/get_expense_categories_cubit/get_expense_categories_cubit.dart';
import 'package:pos_app/features/expense_categories/presentation/widget/expense_data_builder.dart';
import 'package:pos_app/features/expense_categories/presentation/widget/show_delete_expense_category_confirm_dialog.dart';
import 'package:pos_app/generated/l10n.dart';

class EditExpenseCategoriesView extends StatelessWidget {
  const EditExpenseCategoriesView({super.key, required this.expenseCategories});
  final ExpenseCategoriesModel expenseCategories;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditExpenseCategoriesCubit(
          repo: MyServiceLocator.getSingleton<ExpenseCategoriesRepo>(),
          expenseCategoriesModel: expenseCategories),
      child: Scaffold(
        appBar: CustomAppBar(
          title: S.of(context).editexpensecategories,
          actions: [
            CustomTextBtn(
                text: S.of(context).delete,
                onPressed: () async {
                  await showDeleteExpenseCategoryConfirmDialog(
                      context: context,
                      expenseCategoriesModel: expenseCategories,
                      goBack: true);
                })
          ],
        ),
        body: BlocConsumer<EditExpenseCategoriesCubit,
            EditExpenseCategoriesState>(
          listener: (context, state) {
            if (state is EditExpenseCategoriesSuccess) {
              GetExpenseCategoriesCubit.get(context).updateExpenseCategories(
                expense: state.expenseCategories,
              );
              CustomPopUp.callMyToast(
                  context: context,
                  massage: S.of(context).updatedSuccess,
                  state: PopUpState.SUCCESS);
              Navigator.pop(context);
            } else if (state is EditExpenseCategoriesFailing) {
              if (context.mounted) {
                CustomPopUp.callMyToast(
                    context: context,
                    massage: mapStatusCodeToMessage(context, state.errMessage),
                    state: PopUpState.ERROR);
              }
            }
          },
          builder: (context, state) {
            return CustomLayoutBuilder(
              mobile: MyCustomScrollView(
                child: EditExpenseCategoriesMobileBody(
                  state: state,
                ),
              ),
              tablet: MyCustomScrollView(
                child: EditExpenseCategoriesTabletAndDesktopBody(
                  state: state,
                ),
              ),
              desktop: MyCustomScrollView(
                child: EditExpenseCategoriesTabletAndDesktopBody(
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

class EditExpenseCategoriesMobileBody extends StatelessWidget {
  const EditExpenseCategoriesMobileBody({
    super.key,
    required this.state,
  });
  final EditExpenseCategoriesState state;
  @override
  Widget build(BuildContext context) {
    return ExpenseDataBuilder(
      autovalidateMode:
          EditExpenseCategoriesCubit.get(context).autovalidateMode,
      formKey: EditExpenseCategoriesCubit.get(context).formKey,
      nameController: EditExpenseCategoriesCubit.get(context).nameController,
      descriptionController:
          EditExpenseCategoriesCubit.get(context).descriptionController,
      isLoading: state is EditExpenseCategorieLoading,
      onPressed: () =>
          EditExpenseCategoriesCubit.get(context).editExpenseCategories(),
      isEdit: true,
    );
  }
}

class EditExpenseCategoriesTabletAndDesktopBody extends StatelessWidget {
  const EditExpenseCategoriesTabletAndDesktopBody(
      {super.key, required this.state});
  final EditExpenseCategoriesState state;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: SizedBox()),
        Expanded(
          flex: AppConstant.formExpandedTableandMobile,
          child: EditExpenseCategoriesMobileBody(state: state),
        ),
        Expanded(child: SizedBox()),
      ],
    );
  }
}
