import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/features/clients/data/repo/clients_repo.dart';

part 'delete_client_state.dart';

class DeleteClientCubit extends Cubit<DeleteClientState> {
  DeleteClientCubit(this.repo) : super(DeleteClientInitial());

  static DeleteClientCubit get(context) => BlocProvider.of(context);

  final ClientsRepo repo;

  Future<void> deleteClient({
    required int id,
  }) async {
    emit(DeleteClientLoading());

    var response = await repo.deleteClient(
      id: id,
    );

    response.fold(
      (errMessage) => emit(DeleteClientFailing(errMessage: errMessage)),
      (r) => emit(DeleteClientSuccess(id: id)),
    );
  }
}
