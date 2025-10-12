part of 'search_product_cubit.dart';

@immutable
sealed class SearchProductState {}

final class SearchProductInitial extends SearchProductState {}

final class SearchProductLoading extends SearchProductState {}

final class SearchProductSuccess extends SearchProductState {}

final class SearchProductFailing extends SearchProductState {
  final ApiResponse errMessage;
  SearchProductFailing({required this.errMessage});
}

final class SearchProductFailingPagination extends SearchProductState {
  final ApiResponse errMessage;
  SearchProductFailingPagination({required this.errMessage});
}
