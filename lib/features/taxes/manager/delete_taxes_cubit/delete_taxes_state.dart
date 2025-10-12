part of 'delete_taxes_cubit.dart';

@immutable
sealed class DeleteTaxesState {}

final class DeleteTaxesInitial extends DeleteTaxesState {}

final class DeleteTaxesLoading extends DeleteTaxesState {}

final class DeleteTaxesSuccess extends DeleteTaxesState {
  final int id;
  DeleteTaxesSuccess({required this.id});
}

final class DeleteTaxesFailing extends DeleteTaxesState {
  final ApiResponse errMessage;
  DeleteTaxesFailing({required this.errMessage});
}
