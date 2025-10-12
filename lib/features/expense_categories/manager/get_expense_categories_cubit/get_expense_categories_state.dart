part of 'get_expense_categories_cubit.dart';

@immutable
sealed class GetExpenseCategoriesState {}

final class GetExpenseCategoriesInitial extends GetExpenseCategoriesState {}

final class GetExpenseCategoriesLoading extends GetExpenseCategoriesState {}

final class GetExpenseCategoriesSuccess extends GetExpenseCategoriesState {}

final class GetExpenseCategoriesFailing extends GetExpenseCategoriesState {
  final ApiResponse errMessage;
  GetExpenseCategoriesFailing({required this.errMessage});
}

final class GetExpenseCategoriesPaginationFailing
    extends GetExpenseCategoriesState {
  final ApiResponse errMessage;
  GetExpenseCategoriesPaginationFailing({required this.errMessage});
}
