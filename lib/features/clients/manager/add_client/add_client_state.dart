part of 'add_client_cubit.dart';

@immutable
sealed class AddClientState {}

final class AddClientInitial extends AddClientState {}

final class AddClientNotValidate extends AddClientState {}

final class AddClientLoading extends AddClientState {}

final class AddClientSuccess extends AddClientState {
  final CustomerModel customer;

  AddClientSuccess({required this.customer});
}

final class AddClientFailing extends AddClientState {
  final ApiResponse errMessage;

  AddClientFailing({required this.errMessage});
}
