import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/features/home/data/repo/home_repo.dart';
import 'package:pos_app/features/home/manager/cubit/shift_cubit/shift_state.dart';

class ShiftCubit extends Cubit<ShiftState> {
    final HomeRepo homeRepo;
  ScrollController scrollController = ScrollController();

  ShiftCubit(this.homeRepo) : super(ShiftInitial()) {
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent &&
        state is ShiftSuccessWithData) {
      loadMoreShifts();
    }
  }
  static ShiftCubit get(context) => BlocProvider.of<ShiftCubit>(context);
 Future<void> startShift({
  required int branchId,
  required double cash,
}) async {
  emit(ShiftLoading());
  final result = await homeRepo.startShift(branchId: branchId, cash: cash);
  result.fold(
    (failure) => emit(ShiftError(message: failure.message ?? "Failed")),
    (_) => emit(ShiftSuccess(message: "Shift started successfully")),
  );
}


  Future<void> endShift({required int branchId}) async {
    emit(ShiftLoading());
    final result = await homeRepo.endShift(branchId: branchId);
    result.fold(
      (failure) => emit(ShiftError(message: failure.message ?? "Failed")),
      (_) => emit(ShiftSuccess(message: "Shift ended successfully")),
    );
  }
Future<void> fetchShifts({bool isFresh = true}) async {
  emit(ShiftLoading());

  final result = await homeRepo.getShifts(isFresh: isFresh);
  result.fold(
    (failure) {
      emit(ShiftError(message: failure.message ?? "Failed to fetch shifts"));
    },
    (shiftsList) {
      emit(
        ShiftSuccessWithData(
          shifts: shiftsList,
          pagination: homeRepo.shiftsModel?.data, 
        ),
      );
    },
  );
}

Future<void> loadMoreShifts() async {
  if (homeRepo.shiftsModel?.data?.nextPageUrl == null) return;

  final result = await homeRepo.getShifts(isFresh: false);

  result.fold(
    (failure) {
    },
    (newShifts) {
       print("Loaded ${newShifts.length} more shifts");
      print("Total shifts now: ${state is ShiftSuccessWithData ? (state as ShiftSuccessWithData).shifts.length + newShifts.length : newShifts.length}");
      final currentState = state;
      if (currentState is ShiftSuccessWithData) {
        final allShifts = List.of(currentState.shifts)..addAll(newShifts);

        emit(
          ShiftSuccessWithData(
            shifts: allShifts,
            pagination: homeRepo.shiftsModel?.data,
          ),
        );
      } else {
        emit(
          ShiftSuccessWithData(
            shifts: newShifts,
            pagination: homeRepo.shiftsModel?.data,
          ),
        );
      }
    },
  );
}


Future<void> fetchShiftDetails(int shiftId) async {
  emit(ShiftDetailsLoading());

  final result = await homeRepo.getShiftDetails(shiftId);

  result.fold(
    (failure) => emit(ShiftDetailsError(message: failure.message ?? "Failed")),
    (shiftDetails) => emit(ShiftDetailsSuccess(shiftDetails: shiftDetails)),
  );
}


}

