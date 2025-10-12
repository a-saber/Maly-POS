part of 'search_discount_cubit.dart';

@immutable
sealed class SearchDiscountState {}

final class SearchDiscountInitial extends SearchDiscountState {}

final class SearchDiscountLoading extends SearchDiscountState {}

final class SearchDiscountSuccess extends SearchDiscountState {}

final class SearchDiscountFailing extends SearchDiscountState {
  final ApiResponse errMessage;
  SearchDiscountFailing({required this.errMessage});
}

final class SearchDiscountFailingPagination extends SearchDiscountState {
  final ApiResponse errMessage;
  SearchDiscountFailingPagination({required this.errMessage});
}
