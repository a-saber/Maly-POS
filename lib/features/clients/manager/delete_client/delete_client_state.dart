part of 'delete_client_cubit.dart';

@immutable
sealed class DeleteClientState {}

final class DeleteClientInitial extends DeleteClientState {}

final class DeleteClientLoading extends DeleteClientState {}

final class DeleteClientSuccess extends DeleteClientState {
  final int id;

  DeleteClientSuccess({required this.id});
}

final class DeleteClientFailing extends DeleteClientState {
  final ApiResponse errMessage;

  DeleteClientFailing({required this.errMessage});
}
