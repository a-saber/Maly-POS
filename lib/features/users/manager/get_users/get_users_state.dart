part of 'get_users_cubit.dart';

@immutable
sealed class GetUsersState {}

final class GetUsersInitial extends GetUsersState {}

final class GetUsersLoading extends GetUsersState {}

final class GetUsersSuccess extends GetUsersState {}

final class GetUsersFailing extends GetUsersState {
  final ApiResponse errMessage;

  GetUsersFailing({required this.errMessage});
}

final class GetUsersPaginationFailing extends GetUsersState {
  final ApiResponse errMessage;

  GetUsersPaginationFailing({required this.errMessage});
}
