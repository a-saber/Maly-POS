part of 'shift_order_pagination_cubit.dart';

@immutable
sealed class ShiftOrderPaginationState {}

final class ShiftOrderPaginationInitial extends ShiftOrderPaginationState {}

final class ShiftOrderPaginationLoadingState
    extends ShiftOrderPaginationState {}

final class ShiftOrderPaginationErrorState extends ShiftOrderPaginationState {
  final ApiResponse message;
  ShiftOrderPaginationErrorState({required this.message});
}

final class ShiftOrderPaginationSuccessState
    extends ShiftOrderPaginationState {}
