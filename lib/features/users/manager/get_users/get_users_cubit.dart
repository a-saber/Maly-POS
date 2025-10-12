import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/core/constant/constant.dart';
import 'package:pos_app/features/auth/login/data/model/user_model.dart';
import 'package:pos_app/features/users/data/repo/users_repo.dart';

part 'get_users_state.dart';

class GetUsersCubit extends Cubit<GetUsersState> {
  GetUsersCubit(this.repo) : super(GetUsersInitial());
  static GetUsersCubit get(context) => BlocProvider.of(context);

  final UsersRepo repo;

  List<UserModel> users = [];
  ScrollController scrollController = ScrollController();

  bool canLoading() => repo.getUserModel?.nextPageUrl != null;
  bool firstTimeGetData() => repo.getUserModel == null;

  void init() {
    if (firstTimeGetData()) {
      getUsers();
    }

    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        if (canLoading()) {
          getPaginationUsers();
        }
      }
    });
  }

  bool ifScrollNotFillScreen() {
    if (!scrollController.hasClients) return false;
    return scrollController.position.maxScrollExtent == 0;
  }

  void ifNotFillScreen() {
    if (canLoading()) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (ifScrollNotFillScreen()) {
          Future.delayed(
              const Duration(seconds: AppConstant.callPaginationSeconds), () {
            log("getPaginationPermissions");
            // ignore: use_build_context_synchronously
            getPaginationUsers();
          });
        }
      });
    }
  }

  Future<void> getUsers() async {
    emit(GetUsersLoading());

    var response = await repo.getUsers();
    response.fold((errMessage) => emit(GetUsersFailing(errMessage: errMessage)),
        (users) {
      this.users.addAll(users);
      ifNotFillScreen();
      emit(GetUsersSuccess());
    });
  }

  Future<void> getRefreshUsers() async {
    emit(GetUsersLoading());

    var response = await repo.getUsers(
      isRefresh: true,
    );
    response.fold((errMessage) => emit(GetUsersFailing(errMessage: errMessage)),
        (users) {
      this.users = [];
      this.users.addAll(users);
      ifNotFillScreen();
      emit(GetUsersSuccess());
    });
  }

  Future<void> getPaginationUsers() async {
    var response = await repo.getUsers();
    response.fold(
        (errMessage) => emit(GetUsersPaginationFailing(errMessage: errMessage)),
        (users) {
      this.users.addAll(users);
      ifNotFillScreen();
      emit(GetUsersSuccess());
    });
  }

  void addUser(UserModel user) {
    if (!canLoading()) {
      users.add(user);
      emit(GetUsersSuccess());
    }
  }

  void editUser(UserModel user) {
    users[users.indexWhere((element) => element.id == user.id)] = user;

    emit(GetUsersSuccess());
  }

  void removeUser(int id) {
    users.removeWhere((element) => element.id == id);
    emit(GetUsersSuccess());
  }

  @override
  void emit(GetUsersState state) {
    if (!isClosed) {
      super.emit(state);
    }
  }

  @override
  Future<void> close() {
    scrollController.dispose();
    return super.close();
  }

  void reset() {
    users = [];
    repo.reset();
  }
}
