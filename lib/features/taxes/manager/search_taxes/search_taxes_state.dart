part of 'search_taxes_cubit.dart';

@immutable
sealed class SearchTaxesState {}

final class SearchTaxesInitial extends SearchTaxesState {}

final class SearchTaxesLoading extends SearchTaxesState {}

final class SearchTaxesSuccess extends SearchTaxesState {}

final class SearchTaxesFailing extends SearchTaxesState {
  final ApiResponse errMessage;

  SearchTaxesFailing({required this.errMessage});
}

final class SearchTaxesPaginationFailing extends SearchTaxesState {
  final ApiResponse errMessage;

  SearchTaxesPaginationFailing({required this.errMessage});
}
