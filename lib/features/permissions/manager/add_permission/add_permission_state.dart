part of 'add_permission_cubit.dart';

@immutable
sealed class AddPermissionState {}

final class AddPermissionInitial extends AddPermissionState {}

final class AddPermissionChangePermission extends AddPermissionState {}

final class AddPermissionUnValidate extends AddPermissionState {}

final class AddPermissionLoading extends AddPermissionState {}

final class AddPermissionSuccess extends AddPermissionState {
  final RoleModel role;

  AddPermissionSuccess({required this.role});
}

final class AddPermissionFailing extends AddPermissionState {
  final ApiResponse errMessage;

  AddPermissionFailing({required this.errMessage});
}
