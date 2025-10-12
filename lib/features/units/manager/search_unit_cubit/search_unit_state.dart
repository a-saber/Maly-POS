part of 'search_unit_cubit.dart';

@immutable
sealed class SearchUnitState {}

final class SearchUnitInitial extends SearchUnitState {}

final class SearchUnitLoading extends SearchUnitState {}

final class SearchUnitSuccess extends SearchUnitState {}

final class SearchUnitFailing extends SearchUnitState {
  final ApiResponse errMessage;
  SearchUnitFailing({required this.errMessage});
}

final class SearchUnitPaginationFailing extends SearchUnitState {
  final ApiResponse errMessage;
  SearchUnitPaginationFailing({required this.errMessage});
}
