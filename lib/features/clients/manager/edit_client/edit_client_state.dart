part of 'edit_client_cubit.dart';

@immutable
sealed class EditClientState {}

final class EditClientInitial extends EditClientState {}

final class EditClientLoading extends EditClientState {}

final class EditClientSuccess extends EditClientState {
  final CustomerModel customer;

  EditClientSuccess({required this.customer});
}

final class EditClientFailing extends EditClientState {
  final ApiResponse errMessage;

  EditClientFailing({required this.errMessage});
}

final class EditClientUnVaildate extends EditClientState {}
