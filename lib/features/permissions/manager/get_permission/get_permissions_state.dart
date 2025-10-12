part of 'get_permissions_cubit.dart';

@immutable
sealed class GetPermissionsState {}

final class GetPermissionsInitial extends GetPermissionsState {}

final class GetPermissionsLoading extends GetPermissionsState {}

final class GetPermissionsSuccess extends GetPermissionsState {
  GetPermissionsSuccess();
}

final class GetAginPermissionsSuccess extends GetPermissionsState {
  GetAginPermissionsSuccess();
}

final class GetPermissionsFailing extends GetPermissionsState {
  final ApiResponse errMessage;

  GetPermissionsFailing({required this.errMessage});
}

final class GetPermissionsPaginationFailing extends GetPermissionsState {
  final ApiResponse errMessage;

  GetPermissionsPaginationFailing({required this.errMessage});
}
