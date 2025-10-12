import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/features/expense_categories/data/model/expense_categories_model.dart';
import 'package:pos_app/features/expense_categories/data/repo/expense_categories_repo.dart';

part 'edit_expense_categories_state.dart';

class EditExpenseCategoriesCubit extends Cubit<EditExpenseCategoriesState> {
  EditExpenseCategoriesCubit(
      {required this.repo, required this.expenseCategoriesModel})
      : super(EditExpenseCategoriesInitial()) {
    nameController = TextEditingController(text: expenseCategoriesModel.name);
    descriptionController =
        TextEditingController(text: expenseCategoriesModel.description);
  }

  static EditExpenseCategoriesCubit get(context) => BlocProvider.of(context);

  final ExpenseCategoriesRepo repo;
  final ExpenseCategoriesModel expenseCategoriesModel;

  late TextEditingController nameController;
  late TextEditingController descriptionController;

  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  GlobalKey<FormState> formKey = GlobalKey();

  void editExpenseCategories() async {
    emit(EditExpenseCategorieLoading());
    if (formKey.currentState!.validate()) {
      var response = await repo.updateExpenseCategory(
        expenseCategoriesModel: ExpenseCategoriesModel.createWithoutId(
          id: expenseCategoriesModel.id,
          name: nameController.text,
          description: descriptionController.text,
        ),
      );
      response.fold(
        (error) => emit(EditExpenseCategoriesFailing(errMessage: error)),
        (r) => emit(EditExpenseCategoriesSuccess(expenseCategories: r)),
      );
    } else {
      autovalidateMode = AutovalidateMode.always;
      emit(EditExpenseCategoriesUnVaild());
    }
  }

  @override
  Future<void> close() {
    nameController.dispose();
    descriptionController.dispose();
    return super.close();
  }
}
