
import 'package:pos_app/features/home/data/model/shifts_model.dart';

abstract class ShiftState {}

class ShiftInitial extends ShiftState {}

class ShiftLoading extends ShiftState {}

class ShiftSuccess extends ShiftState {
  final String message;
  ShiftSuccess({required this.message});
}
class ShiftSuccessWithData extends ShiftState {
 final List<ShiftData> shifts;
  final Data? pagination;
  ShiftSuccessWithData({required this.shifts, this.pagination});
}

class ShiftError extends ShiftState {
  final String message;
  ShiftError({required this.message});
}
