import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/core/constant/constant.dart';
import 'package:pos_app/features/auth/login/data/model/role_model.dart';
import 'package:pos_app/features/permissions/data/repo/permission_repo.dart';

part 'search_permission_state.dart';

class SearchPermissionCubit extends Cubit<SearchPermissionState> {
  SearchPermissionCubit(this.repo) : super(SearchPermissionInitial());

  static SearchPermissionCubit get(context) => BlocProvider.of(context);

  final PermissionsRepo repo;
  List<RoleModel> roleSearch = [];
  ScrollController scrollController = ScrollController();
  String query = '';

  void init() {
    if (isFirstTimeSearch()) {
      searchPermission(
        '',
      );
    }

    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        if (canLoading() && !_isLoadingPagination) {
          pagination();
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
            pagination();
          });
        }
      });
    }
  }

  Timer? _debounce;
  void onSearchChange(
    String? name, {
    bool isNewSearch = false,
  }) {
    {
      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(
          const Duration(milliseconds: AppConstant.debouncingMillSeconds), () {
        debugPrint("Search Word : $name");
        query = name ?? "";
        searchPermission(
          name ?? '',
          isNewSearch: isNewSearch,
        );
      });
    }
  }

  bool isFirstTimeSearch() => repo.getRoleSearchModel == null;
  bool canLoading() => repo.getRoleSearchModel?.nextPageUrl != null;
  bool _isLoadingPagination = false;

  void pagination() async {
    if (_isLoadingPagination) return;

    _isLoadingPagination = true;
    var response = await repo.getSearchRoles(
      search: "",
      isNewSearch: false,
    );
    response.fold(
        (errMessage) => emit(SearchPermissionFailing(errMessage: errMessage)),
        (listOfRoles) {
      roleSearch.addAll(listOfRoles);
      ifNotFillScreen();
      _isLoadingPagination = false;
      emit(SearchPermissionSuccess());
    });
  }

  void searchPermission(
    String name, {
    bool isNewSearch = false,
  }) async {
    if (isFirstTimeSearch()) {
      emit(SearchPermissionLoading());
    }
    var response = await repo.getSearchRoles(
      search: name,
      isNewSearch: isNewSearch,
    );
    response.fold(
        (errMessage) => emit(SearchPermissionFailing(errMessage: errMessage)),
        (listOfRoles) {
      roleSearch = listOfRoles;
      ifNotFillScreen();
      emit(SearchPermissionSuccess());
    });
  }

  @override
  void emit(SearchPermissionState state) {
    if (!isClosed) {
      super.emit(state);
    }
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
