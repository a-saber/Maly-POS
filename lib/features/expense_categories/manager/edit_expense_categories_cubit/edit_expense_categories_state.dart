part of 'edit_expense_categories_cubit.dart';

@immutable
sealed class EditExpenseCategoriesState {}

final class EditExpenseCategoriesInitial extends EditExpenseCategoriesState {}

final class EditExpenseCategorieLoading extends EditExpenseCategoriesState {}

final class EditExpenseCategoriesSuccess extends EditExpenseCategoriesState {
  final ExpenseCategoriesModel expenseCategories;
  EditExpenseCategoriesSuccess({required this.expenseCategories});
}

final class EditExpenseCategoriesFailing extends EditExpenseCategoriesState {
  final ApiResponse errMessage;
  EditExpenseCategoriesFailing({required this.errMessage});
}

final class EditExpenseCategoriesUnVaild extends EditExpenseCategoriesState {}
