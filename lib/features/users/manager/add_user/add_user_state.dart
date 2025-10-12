part of 'add_user_cubit.dart';

@immutable
sealed class AddUserState {}

final class AddUserInitial extends AddUserState {}

final class AddUserLoading extends AddUserState {}

final class AddUserChangePermission extends AddUserState {}

final class AddUserChangeBranch extends AddUserState {}

final class AddUserUnValidate extends AddUserState {}

final class AddUserSuccess extends AddUserState {
  final UserModel user;

  AddUserSuccess({required this.user});
}

final class AddUserFailing extends AddUserState {
  final ApiResponse errMessage;

  AddUserFailing({required this.errMessage});
}
