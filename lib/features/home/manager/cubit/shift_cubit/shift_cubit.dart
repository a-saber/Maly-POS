import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/features/home/data/model/shifts_model.dart';
import 'package:pos_app/features/home/data/repo/home_repo.dart';
import 'package:pos_app/features/home/manager/cubit/shift_cubit/shift_state.dart';

class ShiftCubit extends Cubit<ShiftState> {
  final HomeRepo homeRepo;
  List<ShiftData> shifts = [];
  ScrollController scrollController = ScrollController();
  ScrollController shiftDetailsScrollController = ScrollController();
  ShiftCubit(this.homeRepo) : super(ShiftInitial());
  static ShiftCubit get(context) => BlocProvider.of<ShiftCubit>(context);
  List<Map<String, dynamic>> shiftOrders = [];
  bool _isLoadingMoreShiftOrders = false;
  final TextEditingController useridController = TextEditingController();
  final TextEditingController cashController = TextEditingController();
  final formKey = GlobalKey<FormState>();
 Future<void> startShift({
  required int branchId,
  required double cash,
}) async {
  emit(ShiftLoading());

  final result = await homeRepo.startShift(branchId: branchId, cash: cash);
  
  result.fold(
    (failure) => emit(ShiftError(message: failure.message ?? "Failed")),
    (shift) async {
      final shiftDetailsResult = await homeRepo.getShiftDetails(branchId, isFresh: true);

      shiftDetailsResult.fold(
        (failure) => emit(ShiftError(message: failure.message ?? "Failed to fetch shift details")),
        (shiftDetails) {
          print("=== START SHIFT RESPONSE ===");
          print("Shift ID: ${shiftDetails.shift?.id}");
          print("Opening Quantity: ${shiftDetails.shift?.openingQuantity}");
          print("Full Response: ${shiftDetails.toJson()}");
          emit (ShiftStarted(message: "Shift started successfully",
         shift: shiftDetails.shift, ));
        },
      );
    },
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

         emit(
          ShiftEnded(message: "Shift ended successfully", shifts: shifts,
          endShiftModel,
          pagination: currentState.pagination,)
         );
        }else{
           emit(
          ShiftEnded(
            message: "Shift ended successfully",
            endShiftModel,
            shifts: updatedShift != null ? [updatedShift] : [],
          ),
        );
        }

        
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
    final result = await homeRepo.getShifts(isFresh: isFresh);
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

    final result = await homeRepo.getShifts();
    result.fold(
      (l) => emit(ShiftError(message: l.message ?? "Error")),
      (data) {
        shifts.addAll(data);
        emit(ShiftSuccessWithData(shifts: List.from(shifts)));
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

  final result = await homeRepo.getShiftDetails(shiftId, isFresh: isFresh);
  result.fold(
    (failure) => emit(ShiftDetailsError(message: failure.message ?? "Failed")),
    (shiftDetails) {
      // orders
      shiftOrders = List.of(shiftDetails.data?.data ?? [])
          .map((e) => e as Map<String, dynamic>)
          .toList();
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
    if (homeRepo.getShift?.data?.nextPageUrl == null) return;
    _isLoadingMoreShiftOrders = true;

    final result = await homeRepo.getShiftDetails(shiftId, isFresh: false);
    result.fold(
      (_) => _isLoadingMoreShiftOrders = false,
      (newShiftDetails) {
        final newOrders = (newShiftDetails.data?.data ?? [])
            .map((e) => e as Map<String, dynamic>)
            .toList();
        shiftOrders.addAll(newOrders);
        final updatedShiftDetails = homeRepo.getShift!;
        emit(ShiftDetailsSuccess(
          shiftDetails: updatedShiftDetails,
          pagination: updatedShiftDetails.data,
        ));

        _isLoadingMoreShiftOrders = false;
      },
    );
  }
  Future<void> filterShifts({
  int? userId,
  int? branchId,
  DateTime? startAt,
  DateTime? endAt,
}) async {
  emit(ShiftLoading());

  final result = await homeRepo.getShifts(isFresh: true);
  result.fold(
    (failure) => emit(ShiftError(message: failure.message ?? "Failed")),
    (data) {
      final filtered = data.where((shift) {
        final userMatch = userId == null || shift.userId == userId;
        final branchMatch = branchId == null || shift.branchId == branchId;
        final startMatch = startAt == null ||
            (shift.startAt != null &&
                DateTime.tryParse(shift.startAt!)!.isAfter(startAt));
        final endMatch = endAt == null ||
            (shift.endAt != null &&
                DateTime.tryParse(shift.endAt!)!.isBefore(endAt));
        return userMatch && branchMatch && startMatch && endMatch;
      }).toList();

      emit(ShiftSuccessWithData(shifts: filtered));
    },
  );
}

}
