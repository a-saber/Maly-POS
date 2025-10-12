part of 'add_unit_cubit.dart';

@immutable
sealed class AddUnitState {}

final class AddUnitInitial extends AddUnitState {}

final class AddUnitLoading extends AddUnitState {}

final class AddUnitSuccess extends AddUnitState {
  final UnitModel unit;
  AddUnitSuccess({required this.unit});
}

final class AddUnitFailing extends AddUnitState {
  final ApiResponse errMessage;
  AddUnitFailing({required this.errMessage});
}

final class AddUnitUnVaild extends AddUnitState {}
