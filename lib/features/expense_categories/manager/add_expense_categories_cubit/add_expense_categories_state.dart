part of 'add_expense_categories_cubit.dart';

@immutable
sealed class AddExpenseCategoriesState {}

final class AddExpenseCategoriesInitial extends AddExpenseCategoriesState {}

final class AddExpenseCategoriesLoading extends AddExpenseCategoriesState {}

final class AddExpenseCategoriesSuccess extends AddExpenseCategoriesState {
  final ExpenseCategoriesModel expenseCategoriesModel;
  AddExpenseCategoriesSuccess({required this.expenseCategoriesModel});
}

final class AddExpenseCategoriesFailing extends AddExpenseCategoriesState {
  final ApiResponse errorMessage;
  AddExpenseCategoriesFailing({
    required this.errorMessage,
  });
}

final class AddExpenseCategoriesUnVaild extends AddExpenseCategoriesState {}
