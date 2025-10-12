part of 'get_clients_cubit.dart';

@immutable
sealed class GetClientsState {}

final class GetClientsInitial extends GetClientsState {}

final class GetClientsLoading extends GetClientsState {}

final class GetClientsSuccess extends GetClientsState {}

final class GetClientsFailing extends GetClientsState {
  final ApiResponse errMessage;

  GetClientsFailing({required this.errMessage});
}

final class GetClientsPaginationFailing extends GetClientsState {
  final ApiResponse errMessage;

  GetClientsPaginationFailing({required this.errMessage});
}
