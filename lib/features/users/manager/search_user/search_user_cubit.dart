import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/core/constant/constant.dart';
import 'package:pos_app/features/auth/login/data/model/user_model.dart';
import 'package:pos_app/features/users/data/repo/users_repo.dart';

part 'search_user_state.dart';

class SearchUserCubit extends Cubit<SearchUserState> {
  SearchUserCubit(this.repo) : super(SearchUserInitial());

  static SearchUserCubit get(context) => BlocProvider.of(context);

  ScrollController scrollController = ScrollController();

  final UsersRepo repo;

  List<UserModel> users = [];
  String query = '';

  bool canLoading() => repo.getSearchUserModel?.nextPageUrl != null;
  bool isFirstTime() => repo.getSearchUserModel == null;

  void init() async {
    if (isFirstTime()) {
      getUsers();
    }

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          canLoading() &&
          !canPaginationLoading) {
        getUserPagination();
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
            // ignore: use_build_context_synchronously
            getUserPagination();
          });
        }
      });
    }
  }

  Timer? _debounce;

  void onChangeSearch({
    String? query,
  }) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(
        const Duration(milliseconds: AppConstant.debouncingMillSeconds), () {
      this.query = query ?? "";
      getUsers();
    });
  }

  void getUsers() async {
    emit(SearchUserLoading());
    var result = await repo.searchUser(
      query: query,
      isRefresh: true,
    );
    result.fold((failure) {
      emit(SearchUserFailing(errMessage: failure));
    }, (users) {
      this.users = users;
      ifNotFillScreen();
      emit(SearchUserSuccess());
    });
  }

  bool canPaginationLoading = false;
  void getUserPagination() async {
    if (canPaginationLoading) return;
    canPaginationLoading = true;
    var result = await repo.searchUser(
      query: query,
    );
    result.fold((failure) {
      emit(SearchUserPaginationFailing(errMessage: failure));
    }, (users) {
      this.users.addAll(users);
      ifNotFillScreen();
      canPaginationLoading = false;
      emit(SearchUserSuccess());
    });
  }

  void reset() {
    // query = '';
    // users = [];
    // repo.resetSearch();
  }

  @override
  Future<void> close() {
    scrollController.dispose();
    return super.close();
  }
}
