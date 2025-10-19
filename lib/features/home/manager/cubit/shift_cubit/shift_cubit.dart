import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/features/home/data/repo/home_repo.dart';
import 'package:pos_app/features/home/manager/cubit/shift_cubit/shift_state.dart';

class ShiftCubit extends Cubit<ShiftState> {
  final HomeRepo homeRepo;
  ShiftCubit(this.homeRepo) : super(ShiftInitial());
  static ShiftCubit get(context) => BlocProvider.of<ShiftCubit>(context);
  Future<void> startShift() async {
    emit(ShiftLoading());
    final result = await homeRepo.startShift();
    result.fold(
      (failure) => emit(ShiftError(message: failure.message ?? "Failed")),
      (_) => emit(ShiftSuccess(message: "Shift started successfully")),
    );
  }

  Future<void> endShift() async {
    emit(ShiftLoading());
    final result = await homeRepo.endShift();
    result.fold(
      (failure) => emit(ShiftError(message: failure.message ?? "Failed")),
      (_) => emit(ShiftSuccess(message: "Shift ended successfully")),
    );
  }
  Future<void> fetchShifts({bool isFresh = true}) async {
    emit(ShiftLoading());
    final result = await homeRepo.getShifts();
    result.fold(
      (failure) => emit(ShiftError(message: failure.message ?? "Failed to fetch shifts")),
      (shiftsModel) => emit(ShiftSuccessWithData(shifts:shiftsModel)),
    );
  }
}

