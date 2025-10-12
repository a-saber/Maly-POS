import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/core/constant/constant.dart';
import 'package:pos_app/features/discounts/data/model/discount_model.dart';
import 'package:pos_app/features/discounts/data/repo/discounts_repo.dart';

part 'search_discount_state.dart';

class SearchDiscountCubit extends Cubit<SearchDiscountState> {
  SearchDiscountCubit(this.repo) : super(SearchDiscountInitial());

  static SearchDiscountCubit get(context) => BlocProvider.of(context);
  final DiscountsRepo repo;
  ScrollController scrollController = ScrollController();
  List<DiscountModel> discounts = [];
  String query = '';
  bool canLoading() => repo.getDiscountSearchModel?.nextPageUrl != null;
  bool isFirstTime() => repo.getDiscountSearchModel == null;

  void init() async {
    if (isFirstTime()) {
      getDiscounts();
    }

    scrollController.addListener(
      () {
        if (scrollController.position.maxScrollExtent ==
                scrollController.offset &&
            canLoading() &&
            !_canPaginationLoading) {
          getPagination();
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
            getPagination();
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
      getDiscounts();
    });
  }

  void getDiscounts() async {
    emit(SearchDiscountLoading());
    var response = await repo.searchDiscounts(
      search: query,
      isRefresh: true,
    );
    response.fold((error) => emit(SearchDiscountFailing(errMessage: error)),
        (data) {
      discounts = data;
      ifNotFillScreen();
      emit(SearchDiscountSuccess());
    });
  }

  bool _canPaginationLoading = false;
  void getPagination() async {
    if (_canPaginationLoading) {
      return;
    }
    _canPaginationLoading = true;
    var response = await repo.searchDiscounts(
      search: query,
    );
    response.fold(
        (error) => emit(SearchDiscountFailingPagination(errMessage: error)),
        (data) {
      discounts.addAll(data);
      ifNotFillScreen();
      _canPaginationLoading = false;
      emit(SearchDiscountSuccess());
    });
  }

  void reset() {
    // discounts = [];
    // query = '';
    // repo.resetSearch();
  }

  @override
  Future<void> close() {
    scrollController.dispose();
    _debounce?.cancel();
    return super.close();
  }
}
