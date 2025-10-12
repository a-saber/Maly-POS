import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_response.dart';

import 'package:pos_app/features/auth/login/data/model/role_model.dart';
import 'package:pos_app/features/permissions/data/repo/permission_repo.dart';

part 'delete_permission_state.dart';

class DeletePermissionCubit extends Cubit<DeletePermissionState> {
  DeletePermissionCubit(this.repo) : super(DeletePermissionInitial());

  static DeletePermissionCubit get(context) => BlocProvider.of(context);

  final PermissionsRepo repo;

  Future<void> deletePermission({
    required RoleModel permission,
  }) async {
    emit(DeletePermissionLaoding());

    var response = await repo.deletePermission(
      permission: permission,
    );
    response.fold(
        (errMessage) => emit(DeletePermissionFailing(errMessage: errMessage)),
        (r) => emit(DeletePermissionSuccess(role: r)));
  }
}
