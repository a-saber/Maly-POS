
abstract class ShiftState {}

class ShiftInitial extends ShiftState {}

class ShiftLoading extends ShiftState {}

class ShiftSuccess extends ShiftState {
  final String message;
  ShiftSuccess({required this.message});
}
class ShiftSuccessWithData extends ShiftState {
  final dynamic shifts;
  ShiftSuccessWithData({required this.shifts});
}

class ShiftError extends ShiftState {
  final String message;
  ShiftError({required this.message});
}
