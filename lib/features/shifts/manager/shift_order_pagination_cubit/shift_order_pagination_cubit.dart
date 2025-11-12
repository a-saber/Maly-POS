import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/features/shifts/data/model/getshift.dart';
import 'package:pos_app/features/shifts/data/repo/shift_repo.dart';

part 'shift_order_pagination_state.dart';

class ShiftOrderPaginationCubit extends Cubit<ShiftOrderPaginationState> {
  ShiftOrderPaginationCubit({
    required this.dataforshift,
    required this.orderData,
    required this.repo,
  }) : super(ShiftOrderPaginationInitial());
  final ShiftRepo repo;
  Dataforshift dataforshift;
  List<OrderData> orderData;

  static ShiftOrderPaginationCubit get(context) => BlocProvider.of(context);

  bool noMoreData() => dataforshift.nextPageUrl == null;

  void getOrderPagination() async {
    if (noMoreData()) return;
    emit(ShiftOrderPaginationLoadingState());
    final result =
        await repo.getOrderPagination(url: dataforshift.nextPageUrl!);
    result.fold(
      (l) => emit(ShiftOrderPaginationErrorState(
        message: l,
      )),
      (r) {
        dataforshift = r;
        orderData.addAll(r.data ?? []);
        emit(ShiftOrderPaginationSuccessState());
      },
    );
  }
}
