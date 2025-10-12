part of 'search_category_cubit.dart';

@immutable
sealed class SearchCategoryState {}

final class SearchCategoryInitial extends SearchCategoryState {}

final class SearchCategoryLoading extends SearchCategoryState {}

final class SearchCategorySuccess extends SearchCategoryState {}

final class SearchCategoryFailing extends SearchCategoryState {
  final ApiResponse errMessage;
  SearchCategoryFailing({required this.errMessage});
}

final class SearchCategoryPaginationFailing extends SearchCategoryState {
  final ApiResponse errMessage;
  SearchCategoryPaginationFailing({required this.errMessage});
}
