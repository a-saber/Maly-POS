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
  ShiftData? activeShift;
  int? _filterUserId;
  int? _filterBranchId;
  DateTime? _filterStartAt;
  DateTime? _filterEndAt;
  bool _isFilterMode = false;
  
  bool isLoadingMore = false;

Future<void> startShift({
  required int branchId,
  required double cash,
}) async {
  emit(ShiftLoading());

  final result = await homeRepo.startShift(branchId: branchId, cash: cash);

  result.fold(
    (failure) => emit(ShiftError(message: failure.message ?? "Failed")),
    (startShiftModel) {
      activeShift = startShiftModel.shift;

      print("=== START SHIFT RESPONSE ===");
      print("Shift ID: ${startShiftModel.shift?.id}");
      print("Opening Quantity: ${startShiftModel.shift?.openingQuantity}");
      print("Branch: ${startShiftModel.shift?.branch?.name}");
      
      emit(ShiftStarted(
        message: startShiftModel.message ?? "Shift started successfully",
        shift: startShiftModel.shift,
      ));
    },
  );
}

Future<void> endShift({required int branchId}) async {
  print(" endShift called with branchId: $branchId");
  print(" activeShift: ${activeShift?.id}");
    if (activeShift == null) {
    emit(ShiftError(message: "NO ACTIVE SHIFT"));
    return;
  }
  if (activeShift!.branchId != branchId) {
    emit(ShiftError(message: "Shift does not belong to this branch"));
    return;
  }

  
  emit(ShiftLoading());
  print(" Loading state emitted");
  
  final result = await homeRepo.endShift(branchId: branchId);
  print(" API call completed");
  
  result.fold(
    (failure) {
      print(" Error: ${failure.message}");
      emit(ShiftError(message: failure.message ?? "Failed"));
    },
    (endShiftModel) {
      print("=== END SHIFT SUCCESS ===");
      print("Shift ID: ${endShiftModel.shift?.id}");
      print("Orders Count: ${endShiftModel.shift?.ordersCount}");
      print("Summary Total: ${endShiftModel.summary?.totalAfterTax}");
      print("Summary Count: ${endShiftModel.summary?.count}");
      
      final updatedShift = endShiftModel.shift;
      emit(ShiftEnded(
        message: "Shift ended successfully",
         endShiftModel,
        shifts: updatedShift != null ? [updatedShift] : [],
      ));
      
      print(" ShiftEnded state emitted!");
      activeShift = null;
    },
  );
}

  void init() {
    getShifts(isFresh: true);

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 50) {
        loadMore();
      }
    });
  }

  Future<void> getShifts({bool isFresh = false}) async {
    if (isLoadingMore) return;

    if (isFresh) {
      shifts = [];
      emit(ShiftLoading());
    } else {
      isLoadingMore = true;
      final currentState = state;
      if (currentState is ShiftSuccessWithData) {
        emit(ShiftSuccessWithData(shifts: List.from(shifts)));
      }
    }

    final result = await homeRepo.getShifts(isFresh: isFresh);

    result.fold(
      (failure) {
        emit(ShiftError(message: failure.message ?? "Error"));
        isLoadingMore = false;
      },
      (newShifts) {
        shifts.addAll(newShifts);
        isLoadingMore = false;
        emit(ShiftSuccessWithData(shifts: List.from(shifts)));
      },
    );
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
    if (isFresh) {
      shiftOrders.clear();
      emit(ShiftDetailsLoading());
    }

    final result = await homeRepo.getShiftDetails(shiftId, isFresh: isFresh);
    result.fold(
      (failure) =>
          emit(ShiftDetailsError(message: failure.message ?? "Failed")),
      (shiftDetails) {

        if (isFresh) {
          shiftOrders = List.of(shiftDetails.data?.data ?? [])
              .map((e) => e as Map<String, dynamic>)
              .toList();
        } else {
          final newOrders = List.of(shiftDetails.data?.data ?? [])
              .map((e) => e as Map<String, dynamic>)
              .toList();
          shiftOrders.addAll(newOrders);
        }
        
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

    _filterUserId = userId;
    _filterBranchId = branchId;
    _filterStartAt = startAt;
    _filterEndAt = endAt;
    _isFilterMode = true;
  
    await _fetchAllShifts();
    
    final filtered = shifts.where((shift) {
      final userMatch = userId == null || shift.userId == userId;
      final branchMatch = branchId == null ||
          (shift.branchId == branchId) ||
          (shift.branch?.id == branchId);
      
      final startMatch = startAt == null ||
          (shift.startAt != null &&
              !DateTime.parse(shift.startAt!).isBefore(startAt));
      final endMatch = endAt == null ||
          (shift.endAt != null &&
              !DateTime.parse(shift.endAt!).isAfter(endAt));
      
      return userMatch && branchMatch && startMatch && endMatch;
    }).toList();

    shifts = filtered;
    emit(ShiftSuccessWithData(shifts: List.from(shifts)));
  }

  Future<void> _fetchAllShifts() async {
    shifts = [];
    var result = await homeRepo.getShifts(isFresh: true);
    
    await result.fold(
      (failure) async {
        print("Error fetching shifts: ${failure.message}");
      },
      (data) async {
        shifts.addAll(data);

        while (homeRepo.shiftsModel?.data?.nextPageUrl != null) {
          final nextResult = await homeRepo.getShifts(isFresh: false);
          
          await nextResult.fold(
            (failure) async {
              print("Error fetching more shifts: ${failure.message}");
              return;
            },
            (moreData) async {
              shifts.addAll(moreData);
            },
          );
        }
        
        print(" Fetched all shifts: ${shifts.length} total");
      },
    );
  }

  Future<void> loadMore() async {

    if (_isFilterMode) return;
    
    if (isLoadingMore) return;
    if (homeRepo.shiftsModel?.data?.nextPageUrl == null) return;

    await getShifts(isFresh: false);
  }
  void clearFilter() {
    _filterUserId = null;
    _filterBranchId = null;
    _filterStartAt = null;
    _filterEndAt = null;
    _isFilterMode = false;
    getShifts(isFresh: true);
  }
  void printShiftsCountByBranch() {
    final branchCounts = <int, Map<String, dynamic>>{};
    
    for (var shift in shifts) {
      final branchId = shift.branchId ?? shift.branch?.id;
      final branchName = shift.branch?.name ?? 'Unknown';
      
      if (branchId != null) {
        if (!branchCounts.containsKey(branchId)) {
          branchCounts[branchId] = {
            'name': branchName,
            'count': 0,
          };
        }
        branchCounts[branchId]!['count'] = 
            (branchCounts[branchId]!['count'] as int) + 1;
      }
    }
    
    print("=== SHIFTS COUNT BY BRANCH ===");
    branchCounts.forEach((branchId, data) {
      print("Branch ID: $branchId | Name: ${data['name']} | Shifts: ${data['count']}");
    });
    print("Total Shifts: ${shifts.length}");
    print("==============================");
  }

  int getShiftsCountForBranch(int branchId) {
    return shifts.where((shift) => 
      shift.branchId == branchId || shift.branch?.id == branchId
    ).length;
  }
}