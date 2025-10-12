import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/features/expense_categories/data/repo/expense_categories_repo.dart';

part 'delete_expense_categories_state.dart';

class DeleteExpenseCategoriesCubit extends Cubit<DeleteExpenseCategoriesState> {
  DeleteExpenseCategoriesCubit(this.repo)
      : super(DeleteExpenseCategoriesInitial());

  static DeleteExpenseCategoriesCubit get(context) => BlocProvider.of(context);

  final ExpenseCategoriesRepo repo;

  void deleteExpenseCategories({
    required int id,
  }) async {
    emit(DeleteExpenseCategoriesLoading());
    var response = await repo.deleteExpenseCategory(
      id: id,
    );
    response.fold(
      (l) => emit(DeleteExpenseCategoriesFailing(errMessage: l)),
      (r) => emit(DeleteExpenseCategoriesSuccess(id: r)),
    );
  }
}
