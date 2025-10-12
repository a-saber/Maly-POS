part of 'add_taxes_cubit.dart';

@immutable
sealed class AddTaxesState {}

final class AddTaxesInitial extends AddTaxesState {}

final class AddTaxesLoading extends AddTaxesState {}

final class AddTaxesSuccess extends AddTaxesState {
  final TaxesModel taxes;
  AddTaxesSuccess({required this.taxes});
}

final class AddTaxesFailing extends AddTaxesState {
  final ApiResponse errMessage;
  AddTaxesFailing({required this.errMessage});
}

final class AddTaxesUnValid extends AddTaxesState {}

final class AddTaxesChangeTaxesType extends AddTaxesState {}
