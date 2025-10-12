part of 'delete_user_cubit.dart';

@immutable
sealed class DeleteUserState {}

final class DeleteUserInitial extends DeleteUserState {}

final class DeleteUserLoading extends DeleteUserState {}

final class DeleteUserSuccess extends DeleteUserState {
  final int id;

  DeleteUserSuccess({required this.id});
}

final class DeleteUserFailing extends DeleteUserState {
  final ApiResponse errMessage;

  DeleteUserFailing({required this.errMessage});
}
