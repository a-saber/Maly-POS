part of 'get_all_units_cubit.dart';

@immutable
sealed class GetAllUnitsState {}

final class GetAllUnitsInitial extends GetAllUnitsState {}

final class GetAllUnitsLoading extends GetAllUnitsState {}

final class GetAllUnitsSuccess extends GetAllUnitsState {}

final class GetAllUnitsFailing extends GetAllUnitsState {
  final ApiResponse errMessage;
  GetAllUnitsFailing({required this.errMessage});
}

final class GetAllUnitsPaginationFailing extends GetAllUnitsState {
  final ApiResponse errMessage;
  GetAllUnitsPaginationFailing({required this.errMessage});
}
