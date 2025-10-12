import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/core/constant/constant.dart';
import 'package:pos_app/core/helper/my_service_locator.dart';
import 'package:pos_app/core/widget/custom_app_bar.dart';
import 'package:pos_app/core/widget/custom_pop_up.dart';
import 'package:pos_app/core/widget/cutsom_layout_builder.dart';
import 'package:pos_app/core/widget/my_custom_scroll_view.dart';
import 'package:pos_app/features/expense_categories/data/repo/expense_categories_repo.dart';
import 'package:pos_app/features/expense_categories/manager/add_expense_categories_cubit/add_expense_categories_cubit.dart';
import 'package:pos_app/features/expense_categories/manager/get_expense_categories_cubit/get_expense_categories_cubit.dart';
import 'package:pos_app/features/expense_categories/presentation/widget/expense_data_builder.dart';
import 'package:pos_app/generated/l10n.dart';

class AddExpenseCategoriesView extends StatelessWidget {
  const AddExpenseCategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddExpenseCategoriesCubit(
          MyServiceLocator.getSingleton<ExpenseCategoriesRepo>()),
      child: Scaffold(
        appBar: CustomAppBar(title: S.of(context).addexpensecategories),
        body:
            BlocConsumer<AddExpenseCategoriesCubit, AddExpenseCategoriesState>(
          listener: (context, state) {
            if (state is AddExpenseCategoriesSuccess) {
              GetExpenseCategoriesCubit.get(context).addExpenseCategories(
                expenseCategories: state.expenseCategoriesModel,
              );
              CustomPopUp.callMyToast(
                  context: context,
                  massage: S.of(context).addedSuccess,
                  state: PopUpState.SUCCESS);
              Navigator.pop(context);
            } else if (state is AddExpenseCategoriesFailing) {
              if (context.mounted) {
                CustomPopUp.callMyToast(
                    context: context,
                    massage:
                        mapStatusCodeToMessage(context, state.errorMessage),
                    state: PopUpState.ERROR);
              }
            }
          },
          builder: (context, state) {
            return CustomLayoutBuilder(
              mobile: MyCustomScrollView(
                  child: AddExpenseCategoriesMobileBody(state: state)),
              tablet: MyCustomScrollView(
                  child:
                      AddExpenseCategoriesTabletAndDesktopBody(state: state)),
              desktop: MyCustomScrollView(
                  child:
                      AddExpenseCategoriesTabletAndDesktopBody(state: state)),
            );
          },
        ),
      ),
    );
  }
}

class AddExpenseCategoriesMobileBody extends StatelessWidget {
  const AddExpenseCategoriesMobileBody({
    super.key,
    required this.state,
  });
  final AddExpenseCategoriesState state;
  @override
  Widget build(BuildContext context) {
    return ExpenseDataBuilder(
      autovalidateMode: AddExpenseCategoriesCubit.get(context).autovalidateMode,
      formKey: AddExpenseCategoriesCubit.get(context).formKey,
      nameController: AddExpenseCategoriesCubit.get(context).nameController,
      descriptionController:
          AddExpenseCategoriesCubit.get(context).descriptionController,
      isLoading: state is AddExpenseCategoriesLoading,
      onPressed: () =>
          AddExpenseCategoriesCubit.get(context).addExpenseCategories(),
      isEdit: false,
    );
  }
}

class AddExpenseCategoriesTabletAndDesktopBody extends StatelessWidget {
  const AddExpenseCategoriesTabletAndDesktopBody(
      {super.key, required this.state});
  final AddExpenseCategoriesState state;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: SizedBox()),
        Expanded(
          flex: AppConstant.formExpandedTableandMobile,
          child: AddExpenseCategoriesMobileBody(state: state),
        ),
        Expanded(child: SizedBox()),
      ],
    );
  }
}
