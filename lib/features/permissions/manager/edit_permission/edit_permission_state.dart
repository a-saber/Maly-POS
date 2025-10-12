part of 'edit_permission_cubit.dart';

@immutable
sealed class EditPermissionState {}

final class EditPermissionInitial extends EditPermissionState {}

final class EditPermissionChnagePermission extends EditPermissionState {}

final class EditPermissionUnvalidate extends EditPermissionState {}

final class EditPermissionLoading extends EditPermissionState {}

final class EditPermissionSuccess extends EditPermissionState {
  final RoleModel role;

  EditPermissionSuccess({required this.role});
}

final class EditPermissionFailing extends EditPermissionState {
  final ApiResponse errMessage;

  EditPermissionFailing({required this.errMessage});
}
