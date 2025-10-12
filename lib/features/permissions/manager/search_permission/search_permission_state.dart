part of 'search_permission_cubit.dart';

@immutable
sealed class SearchPermissionState {}

final class SearchPermissionInitial extends SearchPermissionState {}

final class SearchPermissionReset extends SearchPermissionState {}

final class SearchPermissionLoading extends SearchPermissionState {}

final class SearchPermissionSuccess extends SearchPermissionState {}

final class SearchPermissionFailing extends SearchPermissionState {
  final ApiResponse errMessage;
  SearchPermissionFailing({required this.errMessage});
}

final class SearchPermissionPaginationFailing extends SearchPermissionState {
  final ApiResponse errMessage;
  SearchPermissionPaginationFailing({required this.errMessage});
}
