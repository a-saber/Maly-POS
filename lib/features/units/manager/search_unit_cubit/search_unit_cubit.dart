import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/core/constant/constant.dart';
import 'package:pos_app/features/units/data/model/unit_model.dart';
import 'package:pos_app/features/units/data/repo/units_repo.dart';

part 'search_unit_state.dart';

class SearchUnitCubit extends Cubit<SearchUnitState> {
  SearchUnitCubit(this.repo) : super(SearchUnitInitial());

  static SearchUnitCubit get(context) => BlocProvider.of(context);
  ScrollController scrollController = ScrollController();
  final UnitsRepo repo;
  List<UnitModel> units = [];
  String query = "";

  bool canLoading() => repo.getUnitSearchModel?.nextPageUrl != null;
  bool isFirstTimeGetData() => repo.getUnitSearchModel == null;

  void init() {
    if (isFirstTimeGetData()) {
      getSearchUnits(search: query);
    }

    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
              scrollController.offset &&
          canLoading() &&
          !_paginationLoading) {
        paginationSearchUnits();
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
            paginationSearchUnits();
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
      log("onChangeSearch");
      this.query = query ?? "";
      getSearchUnits(
        search: this.query,
      );
    });
  }

  void getSearchUnits({
    required String search,
  }) async {
    emit(SearchUnitLoading());
    final result = await repo.searchUnit(
      query: search,
      isNew: true,
    );
    result.fold((errMessage) => emit(SearchUnitFailing(errMessage: errMessage)),
        (r) {
      units = r;
      ifNotFillScreen();
      emit(SearchUnitSuccess());
    });
  }

  bool _paginationLoading = false;
  void paginationSearchUnits() async {
    if (_paginationLoading) {
      return;
    }
    _paginationLoading = true;

    final result = await repo.searchUnit(
      query: '',
    );
    result.fold(
        (errMessage) =>
            emit(SearchUnitPaginationFailing(errMessage: errMessage)), (r) {
      units.addAll(r);
      _paginationLoading = false;
      ifNotFillScreen();
      emit(SearchUnitSuccess());
    });
  }

  void resetSearch() {
    // units = [];
    // repo.resetSearch();
  }

  @override
  Future<void> close() {
    scrollController.dispose();
    _debounce?.cancel();
    return super.close();
  }
}
