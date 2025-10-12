import 'dart:developer';

// import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/core/constant/constant.dart';
import 'package:pos_app/features/branch/data/repo/branches_repo.dart';
import 'package:pos_app/features/auth/login/data/model/branche_model.dart';
part 'get_all_branches_state.dart';

class GetAllBranchesCubit extends Cubit<GetAllBranchesState> {
  GetAllBranchesCubit(this.repo) : super(GetAllBranchesInitial());

  static GetAllBranchesCubit get(context) => BlocProvider.of(context);

  final BranchesRepo repo;

  ScrollController scrollController = ScrollController();

  bool canLoading() => repo.getBranchesModel?.nextPageUrl != null;
  bool isFirstTimeGetData() => repo.getBranchesModel == null;

  List<BrancheModel> branches = [];

  void init({bool haveScrollController = false}) {
    if (isFirstTimeGetData()) {
      getBranches();
    }
    if (haveScrollController) {
      scrollController.addListener(() {
        if (scrollController.position.maxScrollExtent ==
            scrollController.offset) {
          if (canLoading()) {
            getPaginationBranches();
          }
        }
      });
    }
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
            log("getPaginationBranches");
            // ignore: use_build_context_synchronously
            getPaginationBranches();
          });
        }
      });
    }
  }

  Future<void> getBranches() async {
    emit(GetAllBranchesLoading());
    // await Future.delayed(const Duration(seconds: 10));
    final result = await repo.getBranches();

    result.fold(
        (errMessage) => emit(GetAllBranchesFailing(
              errMessage: errMessage,
            )), (branches) {
      this.branches.addAll(branches);
      ifNotFillScreen();
      emit(GetAllBranchesSuccess());
    });
  }

  Future<void> getRefreshBranches() async {
    emit(GetAllBranchesLoading());
    final result = await repo.getBranches(
      isRefresh: true,
    );
    result.fold(
        (errMessage) => emit(GetAllBranchesFailing(
              errMessage: errMessage,
            )), (branches) {
      this.branches = [];
      this.branches.addAll(branches);
      ifNotFillScreen();
      emit(GetAllBranchesSuccess());
    });
  }

  Future<void> getPaginationBranches() async {
    final result = await repo.getBranches();
    result.fold(
        (errMessage) => emit(GetBranchesPaginationFailing(
              errMessage: errMessage,
            )), (branches) {
      this.branches.addAll(branches);
      ifNotFillScreen();
      emit(GetAllBranchesSuccess());
    });
  }

  void addBranches(BrancheModel branch) {
    if (!canLoading()) {
      branches.add(branch);
      emit(GetAllBranchesSuccess());
    }
  }

  void updateBranches(BrancheModel branch) {
    branches[branches.indexWhere((element) => element.id == branch.id)] =
        branch;
    emit(GetAllBranchesSuccess());
  }

  void deleteBranches(int id) {
    branches.removeWhere((element) => element.id == id);
    emit(GetAllBranchesSuccess());
  }

  void reset() {
    branches = [];
    repo.resetGetBranches();
  }

  @override
  Future<void> close() {
    scrollController.dispose();
    return super.close();
  }

  @override
  void emit(GetAllBranchesState state) {
    if (!isClosed) {
      super.emit(state);
    }
  }
}
