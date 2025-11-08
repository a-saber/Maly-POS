import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/features/home/data/model/shifts_model.dart';
import 'package:pos_app/features/home/data/repo/home_repo.dart';
import 'package:pos_app/features/home/manager/cubit/shift_cubit/shift_state.dart';

class ShiftCubit extends Cubit<ShiftState> {
  final HomeRepo homeRepo;
  ScrollController scrollController = ScrollController();
  ScrollController shiftDetailsScrollController = ScrollController();

  ShiftCubit(this.homeRepo) : super(ShiftInitial()) {
    scrollController.addListener(_onScroll);
    shiftDetailsScrollController.addListener(_onShiftDetailsScroll);
  }
  void _onShiftDetailsScroll() {
    if (shiftDetailsScrollController.position.pixels >=
            shiftDetailsScrollController.position.maxScrollExtent &&
        state is ShiftDetailsSuccess) {
      loadMoreShiftOrders(
          (state as ShiftDetailsSuccess).shiftDetails.shift!.id!);
    }
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
      (endShiftModel) {
        final updatedShift = endShiftModel.shift;

        final currentState = state;
        if (currentState is ShiftSuccessWithData && updatedShift != null) {
          final shifts = List<ShiftData>.from(currentState.shifts);
          final index = shifts.indexWhere((s) => s.id == updatedShift.id);

          if (index != -1) shifts[index] = updatedShift;

          emit(ShiftSuccessWithData(
            shifts: shifts,
            pagination: currentState.pagination,
          ));
        }

        emit(ShiftSuccess(message: "Shift ended successfully"));
      },
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
      (failure) {},
      (newShifts) {
        print("Loaded ${newShifts.length} more shifts");
        print(
            "Total shifts now: ${state is ShiftSuccessWithData ? (state as ShiftSuccessWithData).shifts.length + newShifts.length : newShifts.length}");
        final currentState = state;
        if (currentState is ShiftSuccessWithData) {
          final allShifts = List.of(currentState.shifts)..addAll(newShifts);
          emit(ShiftSuccessWithData(
            shifts: allShifts,
            pagination: homeRepo.shiftsModel?.data,
          ));
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

    final result = await homeRepo.getShiftDetails(shiftId, isFresh: false);
    result.fold(
      (failure) =>
          emit(ShiftDetailsError(message: failure.message ?? "Failed")),
      (shiftDetails) => emit(ShiftDetailsSuccess(
        shiftDetails: shiftDetails,
        pagination: homeRepo.getShift?.data,
      )),
    );
  }

 Future<void> loadMoreShiftOrders(int shiftId) async {
  final currentState = state;
  if (currentState is! ShiftDetailsSuccess) return;

  if (homeRepo.getShift?.data?.nextPageUrl == null) return;

  final result = await homeRepo.getShiftDetails(shiftId, isFresh: false);

  result.fold(
    (failure) => null,
    (newShiftDetails) {
      final currentOrders = List.of(currentState.shiftDetails.data?.data ?? []);
      final newOrders = newShiftDetails.data?.data ?? [];
      final allOrders = currentOrders..addAll(newOrders);

      final updatedShiftDetails = currentState.shiftDetails;
      updatedShiftDetails.data?.data = allOrders;
      updatedShiftDetails.data?.nextPageUrl = newShiftDetails.data?.nextPageUrl;

      emit(ShiftDetailsSuccess(
        shiftDetails: updatedShiftDetails,
        pagination: updatedShiftDetails.data,
      ));
    },
  );
}

}
