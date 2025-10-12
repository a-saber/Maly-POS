part of 'edit_user_cubit.dart';

@immutable
sealed class EditUserState {}

final class EditUserInitial extends EditUserState {}

final class EditUserLoading extends EditUserState {}

final class EditUserUnValidate extends EditUserState {}

final class EditUserChnagePermission extends EditUserState {}

final class EditUserChnageBranche extends EditUserState {}

final class EditUserFailing extends EditUserState {
  final ApiResponse errMessage;

  EditUserFailing({required this.errMessage});
}

final class EditUserSuccess extends EditUserState {
  final UserModel user;

  EditUserSuccess({required this.user});
}
