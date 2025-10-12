import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/core/constant/constant.dart';
import 'package:pos_app/features/auth/login/data/model/role_model.dart';
import 'package:pos_app/features/permissions/data/repo/permission_repo.dart';

part 'get_permissions_state.dart';

class GetPermissionsCubit extends Cubit<GetPermissionsState> {
  GetPermissionsCubit(this.repo) : super(GetPermissionsInitial());

  static GetPermissionsCubit get(context) => BlocProvider.of(context);

  final PermissionsRepo repo;

  List<RoleModel> roles = [];
  ScrollController controller = ScrollController();

  bool canLoading() => repo.getRoleModel?.nextPageUrl != null;
  bool firstTimeGetData() => repo.getRoleModel == null;

  void init({bool haveScrollController = false}) {
    if (firstTimeGetData()) {
      getPermissions();
    }
    if (haveScrollController) {
      controller.addListener(
        () {
          if (controller.position.maxScrollExtent == controller.offset) {
            if (canLoading()) {
              getPaginationPermissions();
            }
          }
        },
      );
    }
  }

  bool ifScrollNotFillScreen() {
    if (!controller.hasClients) return false;
    return controller.position.maxScrollExtent == 0;
  }

  void ifNotFillScreen() {
    if (canLoading()) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (ifScrollNotFillScreen()) {
          Future.delayed(
              const Duration(seconds: AppConstant.callPaginationSeconds), () {
            log("getPaginationPermissions");
            // ignore: use_build_context_synchronously
            getPaginationPermissions();
          });
        }
      });
    }
  }

  Future<void> getPermissions() async {
    emit(GetPermissionsLoading());
    //  remove wait
    // await Future.delayed(const Duration(seconds: 10));
    final result = await repo.getRoles();
    result.fold(
        (errMessage) => emit(GetPermissionsFailing(errMessage: errMessage)),
        (listOfRoles) {
      roles.addAll(listOfRoles);
      ifNotFillScreen();
      emit(GetPermissionsSuccess());
    });
  }

  bool paginationLoading = false;

  Future<void> getPaginationPermissions() async {
    if (paginationLoading) return;
    paginationLoading = true;
    final result = await repo.getRoles();
    result.fold(
        (errMessage) =>
            emit(GetPermissionsPaginationFailing(errMessage: errMessage)),
        (listOfRoles) {
      roles.addAll(listOfRoles);
      paginationLoading = false;
      ifNotFillScreen();
      emit(GetPermissionsSuccess());
    });
  }

  Future<void> getRefreshPermissions() async {
    emit(GetPermissionsLoading());

    final result = await repo.getRoles(
      isRefresh: true,
    );
    result.fold(
        (errMessage) => emit(GetPermissionsFailing(errMessage: errMessage)),
        (listOfRoles) {
      roles = [];
      roles.addAll(listOfRoles);
      ifNotFillScreen();
      emit(GetAginPermissionsSuccess());
    });
  }

  void addPermission(RoleModel role) {
    if (!canLoading()) {
      roles.add(role);
      emit(GetPermissionsSuccess());
    }
  }

  void updatePermission(RoleModel role) {
    final index = roles.indexWhere((r) => r.id == role.id);

    if (index != -1) {
      // Replace the old role with the updated one
      roles[index] = role;
    }

    emit(GetPermissionsSuccess());
  }

  void deletePermission(RoleModel role) {
    roles.removeWhere((r) => r.id == role.id);

    emit(GetPermissionsSuccess());
  }

  @override
  void emit(GetPermissionsState state) {
    if (!isClosed) {
      super.emit(state);
    }
  }

  @override
  Future<void> close() {
    controller.dispose();

    return super.close();
  }

  void reset() {
    roles = [];
    repo.reset();
  }
}
