import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/features/shifts/data/model/shifts_model.dart';
import 'package:pos_app/features/shifts/data/repo/shift_repo.dart';
import 'package:pos_app/features/shifts/manager/shift_cubit/shift_state.dart';

class ShiftCubit extends Cubit<ShiftState> {
  final ShiftRepo shiftRepo;
  List<ShiftData> shifts = [];
  ScrollController scrollController = ScrollController();
  ScrollController shiftDetailsScrollController = ScrollController();
  ShiftCubit(this.shiftRepo) : super(ShiftInitial());
  static ShiftCubit get(context) => BlocProvider.of<ShiftCubit>(context);
  List<Map<String, dynamic>> shiftOrders = [];
  bool _isLoadingMoreShiftOrders = false;

  Future<void> startShift({
    required int branchId,
    required double cash,
  }) async {
    emit(ShiftLoading());
    final result = await shiftRepo.startShift(branchId: branchId, cash: cash);
    result.fold(
      (failure) => emit(ShiftError(message: failure.message ?? "Failed")),
      (_) => emit(ShiftSuccess(message: "Shift started successfully")),
    );
  }

  Future<void> endShift({required int branchId}) async {
    emit(ShiftLoading());
    final result = await shiftRepo.endShift(branchId: branchId);
    result.fold(
      (failure) => emit(ShiftError(message: failure.message ?? "Failed")),
      (endShiftModel) {
        // final updatedShift = endShiftModel.shift;

        // final currentState = state;
        // if (currentState is ShiftSuccessWithData && updatedShift != null) {
        //   final shifts = List<ShiftData>.from(currentState.shifts);
        //   final index = shifts.indexWhere((s) => s.id == updatedShift.id);

        //   if (index != -1) shifts[index] = updatedShift;

        // }

        emit(ShiftSuccessEndWithData(
          endShiftModel: endShiftModel,
          shifts: shifts,
          // pagination: currentState.pagination,
        ));

        // emit(ShiftSuccess(message: "Shift ended successfully"));
      },
    );
  }

  void init() {
    getShifts(isFresh: true);

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        loadMore();
      }
    });
  }

  bool isLoadingMore = false;
  Future<void> getShifts({bool isFresh = false}) async {
    emit(ShiftLoading());
    final result = await shiftRepo.getShifts(isFresh: isFresh);
    result.fold(
      (l) => emit(ShiftError(message: l.message ?? "Error")),
      (data) {
        shifts = data;
        emit(ShiftSuccessWithData(shifts: List.from(shifts)));
      },
    );
  }

  Future<void> loadMore() async {
    if (isLoadingMore) return;
    isLoadingMore = true;

    final result = await shiftRepo.getShifts();
    result.fold(
      (l) => emit(ShiftError(message: l.message ?? "Error")),
      (data) {
        if (data.isNotEmpty) {
          shifts = data;
          emit(ShiftSuccessWithData(shifts: data));
        }
      },
    );

    isLoadingMore = false;
  }

  void initShiftDetails(int shiftId) {
    fetchShiftDetails(shiftId, isFresh: true);

    shiftDetailsScrollController.removeListener(_shiftDetailsListener);
    shiftDetailsScrollController.addListener(_shiftDetailsListener);
  }

  void _shiftDetailsListener() {
    if (!shiftDetailsScrollController.hasClients) return;

    if (shiftDetailsScrollController.position.pixels >=
        shiftDetailsScrollController.position.maxScrollExtent - 20) {
      final currentState = state;
      if (currentState is ShiftDetailsSuccess) {
        loadMoreShiftOrders(currentState.shiftDetails.shift?.id ?? 0);
      }
    }
  }

  Future<void> fetchShiftDetails(int shiftId, {bool isFresh = false}) async {
    if (isFresh) shiftOrders.clear();

    emit(ShiftDetailsLoading());

    final result = await shiftRepo.getShiftDetails(shiftId, isFresh: isFresh);
    result.fold(
      (failure) =>
          emit(ShiftDetailsError(message: failure.message ?? "Failed")),
      (shiftDetails) {
        emit(ShiftDetailsSuccess(
          shiftDetails: shiftDetails,
          pagination: shiftDetails.data,
        ));
      },
    );
  }

  Future<void> loadMoreShiftOrders(int shiftId) async {
    final currentState = state;
    if (currentState is! ShiftDetailsSuccess) return;
    if (_isLoadingMoreShiftOrders) return;
    if (shiftRepo.getShift?.data?.nextPageUrl == null) return;
    _isLoadingMoreShiftOrders = true;

    final result = await shiftRepo.getShiftDetails(shiftId, isFresh: false);
    result.fold(
      (_) => _isLoadingMoreShiftOrders = false,
      (newShiftDetails) {
        final newOrders = (newShiftDetails.data?.data ?? [])
            .map((e) => e as Map<String, dynamic>)
            .toList();
        shiftOrders.addAll(newOrders);
        final updatedShiftDetails = shiftRepo.getShift!;
        emit(ShiftDetailsSuccess(
          shiftDetails: updatedShiftDetails,
          pagination: updatedShiftDetails.data,
        ));

        _isLoadingMoreShiftOrders = false;
      },
    );
  }
}
