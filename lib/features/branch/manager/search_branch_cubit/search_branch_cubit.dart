import 'dart:async';
import 'dart:developer';

// import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/core/constant/constant.dart';
import 'package:pos_app/features/auth/login/data/model/branche_model.dart';
import 'package:pos_app/features/branch/data/repo/branches_repo.dart';

part 'search_branch_state.dart';

class SearchBranchCubit extends Cubit<SearchBranchState> {
  SearchBranchCubit(this.repo) : super(SearchBranchInitial());

  static SearchBranchCubit get(context) => BlocProvider.of(context);

  ScrollController scrollController = ScrollController();

  final BranchesRepo repo;

  List<BrancheModel> searchBranches = [];
  String query = "";

  bool canLoading() => repo.getBranchesSearchModel?.nextPageUrl != null;
  bool isFirtsTime() => repo.getBranchesSearchModel == null;

  void init() {
    if (isFirtsTime()) {
      searchBranch(
        "",
      );
    }
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        if (canLoading()) {
          getPaginationBranches();
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
            getPaginationBranches();
          });
        }
      });
    }
  }

  bool _isPaginationLoading = false;
  void getPaginationBranches() async {
    if (_isPaginationLoading) return;
    _isPaginationLoading = true;

    var result = await repo.getSearchBranches(query: "");
    result.fold(
      (errMessage) =>
          emit(SearchBranchPaginationFailing(errMessage: errMessage)),
      (branches) {
        searchBranches.addAll(branches);
        ifNotFillScreen();
        _isPaginationLoading = false;
        emit(SearchBranchSuccess());
      },
    );
  }

  Timer? _debounce;

  void onChangeSearch(
    String query,
  ) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(
        const Duration(milliseconds: AppConstant.debouncingMillSeconds), () {
      this.query = query;
      searchBranch(
        query,
      );
    });
  }

  void searchBranch(
    String query,
  ) async {
    emit(SearchBranchLoading());

    var result = await repo.getSearchBranches(
      query: query,
      isFirstTime: true,
    );
    result.fold(
      (errMessage) => emit(SearchBranchFailing(errMessage: errMessage)),
      (branches) {
        searchBranches = branches;
        ifNotFillScreen();
        emit(SearchBranchSuccess());
      },
    );
  }

  @override
  void emit(SearchBranchState state) {
    if (!isClosed) {
      super.emit(state);
    }
  }

  @override
  Future<void> close() {
    scrollController.dispose();
    _debounce?.cancel();
    return super.close();
  }
}
