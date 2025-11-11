
import 'package:pos_app/features/home/data/model/end_shift_model.dart';
import 'package:pos_app/features/home/data/model/getshift.dart' ;
import 'package:pos_app/features/home/data/model/shifts_model.dart';

abstract class ShiftState {}

class ShiftInitial extends ShiftState {}

class ShiftLoading extends ShiftState {}

class ShiftSuccess extends ShiftState {
  final String? message;
  ShiftSuccess({ this.message, Shift? shift});
}
class ShiftSuccessWithData extends ShiftState {
 final List<ShiftData> shifts;
  final Data? pagination;
  ShiftSuccessWithData({required this.shifts, this.pagination});
}
class ShiftStarted extends ShiftSuccess {
  final String message;
    final ShiftData? shift;
  ShiftStarted({required this.message, this.shift}); }


class ShiftEnded extends ShiftSuccess {
  final String message;
  final EndShiftModel? endShiftModel;
  final List<ShiftData> shifts;
  final Data? pagination;
  ShiftEnded(this.endShiftModel,  {required this.message,required this.shifts, this.pagination});
}

class ShiftError extends ShiftState {
  final String message;
  ShiftError({required this.message});
}
class ShiftDetailsLoading extends ShiftState {}

class ShiftDetailsSuccess extends ShiftState {
  final GetShift shiftDetails;
  final Dataforshift? pagination;
  ShiftDetailsSuccess({required this.shiftDetails,
    this.pagination});
}

class ShiftDetailsError extends ShiftState {
  final String message;
  ShiftDetailsError({required this.message});
}
