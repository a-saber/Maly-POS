import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/core/constant/constant.dart';
import 'package:pos_app/features/auth/login/data/model/branche_model.dart';
import 'package:pos_app/features/categories/data/model/category_model.dart';
import 'package:pos_app/features/products/data/model/product_model.dart';
import 'package:pos_app/features/store_quantity/data/model/store_quantity_product_model.dart';
import 'package:pos_app/features/store_quantity/data/repo/store_quantity_repo.dart';
import 'package:pos_app/features/units/data/model/unit_model.dart';

part 'store_quantity_state.dart';

class StoreQuantityCubit extends Cubit<StoreQuantityState> {
  StoreQuantityCubit(this.repo) : super(StoreQunatityInitial());

  static StoreQuantityCubit get(context) => BlocProvider.of(context);

  final StoreQuantityRepo repo;

  String query = '';

  ScrollController scrollController = ScrollController();

  BrancheModel? branch;
  ProductModel? product;
  List<StoreQuantityProductModel> products = [];

  bool canLoading() => repo.getStoreQuantityModel?.data?.nextPageUrl != null;
  bool firstTime() => repo.getStoreQuantityModel == null;

  void init() {
    if (firstTime()) {
      getProducts();
    }

    scrollController.addListener(() {
      if (canLoading() &&
          scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
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
      getProducts();
    });
  }

  void getProducts({
    CategoryModel? category,
    UnitModel? unit,
    double? minPrice,
    double? maxPrice,
    int? minQuantity,
    int? maxQuantity,
  }) async {
    emit(StoreQunatityLoading());
    var response = await repo.getProducts(
      category: category,
      unit: unit,
      minPrice: minPrice,
      maxPrice: maxPrice,
      minQuantity: minQuantity,
      maxQuantity: maxQuantity,
      search: query,
      branch: branch,
      product: product,
      isfresh: true,
    );
    response.fold(
      (errMessage) => emit(
        StoreQunatityFailing(
          errMessage: errMessage,
        ),
      ),
      (products) {
        this.products = products;
        ifNotFillScreen();
        emit(StoreQunatitySuccess());
      },
    );
  }

  bool canPaginationLoading = false;

  void getProductsPagination() async {
    if (canPaginationLoading) return;
    canPaginationLoading = true;
    var response = await repo.getProducts();
    response.fold(
      (errMessage) => emit(
        StoreQunatityPaginationFailing(
          errMessage: errMessage,
        ),
      ),
      (products) {
        this.products.addAll(products);
        canPaginationLoading = false;
        ifNotFillScreen();
        emit(StoreQunatitySuccess());
      },
    );
  }

  void filterProductsInBranch({
    required CategoryModel? category,
    required UnitModel? unit,
    required double? minPrice,
    required double? maxPrice,
    required int? minQuantity,
    required int? maxQuantity,
  }) async {
    getProducts(
      category: category,
      unit: unit,
      minPrice: minPrice,
      maxPrice: maxPrice,
      minQuantity: minQuantity,
      maxQuantity: maxQuantity,
    );
  }

  void changeBranch(
    BrancheModel? newBranch,
  ) {
    if (branch?.id != newBranch?.id) {
      branch = newBranch;
      getProducts();
    }
  }

  void resetBranch() {
    branch = null;
    getProducts();
  }

  void changeProduct(
    ProductModel? newProduct,
  ) {
    if (product?.id != newProduct?.id) {
      product = newProduct;
      getProducts();
    }
  }

  void resetProduct() {
    product = null;
    getProducts();
  }

  void reset() {
    query = '';
    branch = null;
    product = null;
    products = [];
    repo.clear();
  }

  @override
  void emit(StoreQuantityState state) {
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
