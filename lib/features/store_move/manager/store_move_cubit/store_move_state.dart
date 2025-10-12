part of 'store_move_cubit.dart';

@immutable
sealed class StoreMoveState {}

final class StoreMoveInitial extends StoreMoveState {}

final class StoreMoveLoading extends StoreMoveState {}

final class StoreMoveSuccess extends StoreMoveState {}

final class StoreMoveFailing extends StoreMoveState {
  final ApiResponse errMessage;

  StoreMoveFailing({required this.errMessage});
}

final class StoreMoveFailingPagination extends StoreMoveState {
  final ApiResponse errMessage;

  StoreMoveFailingPagination({required this.errMessage});
}
