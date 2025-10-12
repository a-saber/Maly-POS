import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/core/constant/constant.dart';
import 'package:pos_app/features/products/data/model/product_model.dart';
import 'package:pos_app/features/products/data/repo/products_repo.dart';

part 'search_product_state.dart';

class SearchProductCubit extends Cubit<SearchProductState> {
  SearchProductCubit(this.repo) : super(SearchProductInitial());
  static SearchProductCubit get(context) => BlocProvider.of(context);

  final ProductsRepo repo;

  ScrollController scrollController = ScrollController();
  String query = '';
  List<ProductModel> products = [];

  bool canLoading() => repo.searchProductsModel?.data?.nextPageUrl != null;
  bool firstTime() => repo.searchProductsModel == null;

  void init() async {
    if (firstTime()) {
      getSearchProducts();
    }

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          canLoading() &&
          !canPaginationLoading) {
        getProductsPagination();
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
            getProductsPagination();
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
      getSearchProducts();
    });
  }

  void getSearchProducts() async {
    emit(SearchProductLoading());
    var response = await repo.searchProducts(
      query: query,
      isfresh: true,
    );
    response.fold(
      (errMessage) => emit(SearchProductFailing(errMessage: errMessage)),
      (products) {
        this.products = products;
        ifNotFillScreen();
        emit(SearchProductSuccess());
      },
    );
  }

  bool canPaginationLoading = false;
  void getProductsPagination() async {
    if (canPaginationLoading) return;
    canPaginationLoading = true;
    var response = await repo.getProducts();
    response.fold(
      (errMessage) => emit(SearchProductFailing(errMessage: errMessage)),
      (products) {
        this.products.addAll(products);
        ifNotFillScreen();
        canPaginationLoading = false;
        emit(SearchProductSuccess());
      },
    );
  }

  void reset() {
    // query = '';
    // products = [];
    // repo.resetSearch();
  }

  @override
  Future<void> close() {
    scrollController.dispose();
    _debounce?.cancel();
    return super.close();
  }
}
