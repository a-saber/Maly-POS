part of 'delete_expense_categories_cubit.dart';

@immutable
sealed class DeleteExpenseCategoriesState {}

final class DeleteExpenseCategoriesInitial
    extends DeleteExpenseCategoriesState {}

final class DeleteExpenseCategoriesLoading
    extends DeleteExpenseCategoriesState {}

final class DeleteExpenseCategoriesSuccess
    extends DeleteExpenseCategoriesState {
  final int id;
  DeleteExpenseCategoriesSuccess({required this.id});
}

final class DeleteExpenseCategoriesFailing
    extends DeleteExpenseCategoriesState {
  final ApiResponse errMessage;

  DeleteExpenseCategoriesFailing({required this.errMessage});
}
