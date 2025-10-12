part of 'delete_unit_cubit.dart';

@immutable
sealed class DeleteUnitState {}

final class DeleteUnitInitial extends DeleteUnitState {}

final class DeleteUnitLoading extends DeleteUnitState {}

final class DeleteUnitSuccess extends DeleteUnitState {
  final int id;
  DeleteUnitSuccess({required this.id});
}

final class DeleteUnitFailing extends DeleteUnitState {
  final ApiResponse errMessage;
  DeleteUnitFailing({required this.errMessage});
}
