part of 'delete_permission_cubit.dart';

@immutable
sealed class DeletePermissionState {}

final class DeletePermissionInitial extends DeletePermissionState {}

final class DeletePermissionLaoding extends DeletePermissionState {}

final class DeletePermissionSuccess extends DeletePermissionState {
  final RoleModel role;

  DeletePermissionSuccess({required this.role});
}

final class DeletePermissionFailing extends DeletePermissionState {
  final ApiResponse errMessage;

  DeletePermissionFailing({required this.errMessage});
}
