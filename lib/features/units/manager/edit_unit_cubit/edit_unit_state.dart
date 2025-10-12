part of 'edit_unit_cubit.dart';

@immutable
sealed class EditUnitState {}

final class EditUnitInitial extends EditUnitState {}

final class EditUnitLoading extends EditUnitState {}

final class EditUnitSuccess extends EditUnitState {
  final UnitModel unit;
  EditUnitSuccess({required this.unit});
}

final class EditUnitFailing extends EditUnitState {
  final ApiResponse errMessage;
  EditUnitFailing({required this.errMessage});
}

final class EditUnitUnVaild extends EditUnitState {}
