import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/features/auth/login/data/model/user_model.dart';
import 'package:pos_app/features/users/data/repo/users_repo.dart';

part 'delete_user_state.dart';

class DeleteUserCubit extends Cubit<DeleteUserState> {
  DeleteUserCubit(this.repo) : super(DeleteUserInitial());

  static DeleteUserCubit get(context) => BlocProvider.of(context);

  final UsersRepo repo;

  void deleteUser({
    required UserModel user,
  }) async {
    emit(DeleteUserLoading());

    var response = await repo.removeUser(
      id: user.id!,
    );

    response.fold((error) => emit(DeleteUserFailing(errMessage: error)),
        (r) => emit(DeleteUserSuccess(id: r)));
  }
}
