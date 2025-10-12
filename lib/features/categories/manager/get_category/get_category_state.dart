part of 'get_category_cubit.dart';

@immutable
sealed class GetCategoryState {}

final class GetCategoryInitial extends GetCategoryState {}

final class GetCategoryLoading extends GetCategoryState {}

final class GetCategorySuccess extends GetCategoryState {}

final class GetCategoryError extends GetCategoryState {
  final ApiResponse errMessage;
  GetCategoryError(this.errMessage);
}

final class GetPaginationCategoryError extends GetCategoryState {
  final ApiResponse errMessage;
  GetPaginationCategoryError(this.errMessage);
}
