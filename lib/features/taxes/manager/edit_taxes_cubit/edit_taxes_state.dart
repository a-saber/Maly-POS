part of 'edit_taxes_cubit.dart';

@immutable
sealed class EditTaxesState {}

final class EditTaxesInitial extends EditTaxesState {}

final class EditTaxesLoading extends EditTaxesState {}

final class EditTaxesSuccess extends EditTaxesState {
  final TaxesModel tax;
  EditTaxesSuccess({required this.tax});
}

final class EditTaxesFailing extends EditTaxesState {
  final ApiResponse errMessage;
  EditTaxesFailing({required this.errMessage});
}

final class EditTaxesUnValid extends EditTaxesState {}

final class EditTaxesChangTaxesType extends EditTaxesState {}
