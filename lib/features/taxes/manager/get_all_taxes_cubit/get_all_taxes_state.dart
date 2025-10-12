part of 'get_all_taxes_cubit.dart';

@immutable
sealed class GetAllTaxesState {}

final class GetAllTaxesInitial extends GetAllTaxesState {}

final class GetAllTaxesLoading extends GetAllTaxesState {}

final class GetAllTaxesSuccess extends GetAllTaxesState {}

final class GetAllTaxesFailing extends GetAllTaxesState {
  final ApiResponse errMessage;

  GetAllTaxesFailing({required this.errMessage});
}

final class GetAllTaxesPaginationFailing extends GetAllTaxesState {
  final ApiResponse errMessage;

  GetAllTaxesPaginationFailing({required this.errMessage});
}
