import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/core/constant/constant.dart';
import 'package:pos_app/features/taxes/data/model/taxes_model.dart';
import 'package:pos_app/features/taxes/data/repo/taxes_repo.dart';

part 'search_taxes_state.dart';

class SearchTaxesCubit extends Cubit<SearchTaxesState> {
  SearchTaxesCubit(this.repo) : super(SearchTaxesInitial());

  static SearchTaxesCubit get(context) => BlocProvider.of(context);

  final TaxesRepo repo;

  ScrollController scrollController = ScrollController();
  String query = '';
  List<TaxesModel> searchTaxes = [];

  bool canLoading() => repo.getTaxesSearchModel?.nextPageUrl != null;
  bool isFirstTime() => repo.getTaxesSearchModel == null;

  void init() async {
    if (isFirstTime()) {
      getSearchTaxes();
    }

    scrollController.addListener(
      () {
        if (scrollController.position.maxScrollExtent ==
                scrollController.offset &&
            !_canLoadingPagination &&
            canLoading()) {
          getPaginationTaxes();
        }
      },
    );
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
            log("getPaginationTaxes");
            // ignore: use_build_context_synchronously
            getPaginationTaxes();
          });
        }
      });
    }
  }

  Timer? _debounce;
  void onSearchChanged(
    String query,
  ) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 300), () {
      this.query = query;
      getSearchTaxes();
    });
  }

  void getSearchTaxes() async {
    emit(SearchTaxesLoading());
    var response = await repo.getSearchTaxes(search: query, isRefresh: true);
    response.fold((errMessage) {
      emit(SearchTaxesFailing(errMessage: errMessage));
    }, (taxes) {
      searchTaxes = taxes;
      ifNotFillScreen();
      emit(SearchTaxesSuccess());
    });
  }

  bool _canLoadingPagination = false;

  void getPaginationTaxes() async {
    if (_canLoadingPagination) {
      return;
    }
    _canLoadingPagination = true;
    var response = await repo.getSearchTaxes(
      search: query,
    );
    response.fold((errMessage) {
      emit(SearchTaxesPaginationFailing(errMessage: errMessage));
    }, (taxes) {
      searchTaxes.addAll(taxes);
      _canLoadingPagination = false;
      ifNotFillScreen();

      emit(SearchTaxesSuccess());
    });
  }

  void reset() {
    // query = '';
    // searchTaxes = [];
    // repo.resetSearch();
    // emit(SearchTaxesInitial());
  }

  @override
  Future<void> close() {
    scrollController.dispose();
    _debounce?.cancel();
    return super.close();
  }
}
