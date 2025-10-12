import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/features/expense_categories/data/model/expense_categories_model.dart';
import 'package:pos_app/features/expense_categories/data/repo/expense_categories_repo.dart';

part 'add_expense_categories_state.dart';

class AddExpenseCategoriesCubit extends Cubit<AddExpenseCategoriesState> {
  AddExpenseCategoriesCubit(this.repo) : super(AddExpenseCategoriesInitial());

  static AddExpenseCategoriesCubit get(context) => BlocProvider.of(context);

  final ExpenseCategoriesRepo repo;

  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  final formKey = GlobalKey<FormState>();

  void addExpenseCategories() async {
    emit(AddExpenseCategoriesLoading());
    if (formKey.currentState!.validate()) {
      var response = await repo.addExpenseCategory(
        expenseCategoriesModel: ExpenseCategoriesModel.createWithoutId(
          name: nameController.text,
          description: descriptionController.text,
        ),
      );
      response.fold(
        (error) => emit(AddExpenseCategoriesFailing(errorMessage: error)),
        (r) => emit(AddExpenseCategoriesSuccess(expenseCategoriesModel: r)),
      );
    } else {
      autovalidateMode = AutovalidateMode.always;
      emit(AddExpenseCategoriesUnVaild());
    }
  }

  @override
  Future<void> close() {
    nameController.dispose();
    descriptionController.dispose();
    return super.close();
  }
}
