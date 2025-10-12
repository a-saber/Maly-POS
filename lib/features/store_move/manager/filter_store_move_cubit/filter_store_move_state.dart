part of 'filter_store_move_cubit.dart';

@immutable
sealed class FilterStoreMoveState {}

final class FilterStoreMoveInitial extends FilterStoreMoveState {}

final class FilterStoreMoveChangeItem extends FilterStoreMoveState {}
