import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/core/constant/constant.dart';
import 'package:pos_app/features/products/data/model/product_model.dart';
import 'package:pos_app/features/products/data/repo/products_repo.dart';

part 'get_all_products_state.dart';

class GetAllProductsCubit extends Cubit<GetAllProductsState> {
  GetAllProductsCubit(this.repo) : super(GetAllProductsInitial());
  static GetAllProductsCubit get(context) => BlocProvider.of(context);
  final ProductsRepo repo;

  ScrollController scrollController = ScrollController();
  List<ProductModel> products = [];

  bool canLoading() => repo.getProductsModel?.data?.nextPageUrl != null;
  bool isFirtsTime() => repo.getProductsModel == null;

  void init() {
    if (isFirtsTime()) {
      getProducts();
    }

    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        if (canLoading()) {
          getProductsPagination();
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
            log("getPaginationProducts");
            // ignore: use_build_context_synchronously
            getProductsPagination();
          });
        }
      });
    }
  }

  Future<void> getProducts() async {
    emit(GetAllProductsLoading());
    //  : Remove wait
    // await Future.delayed(const Duration(seconds: 10));
    final result = await repo.getProducts(
      isfresh: true,
    );
    result.fold(
        (errMessage) => emit(GetAllProductsFailing(errMessage: errMessage)),
        (products) {
      this.products = products;
      ifNotFillScreen();
      emit(GetAllProductsSuccess());
    });
  }

  bool getPgination = false;
  Future<void> getProductsPagination() async {
    if (getPgination) return;
    getPgination = true;
    final result = await repo.getProducts();
    result.fold(
        (errMessage) =>
            emit(GetAllProductsPaginationFailing(errMessage: errMessage)),
        (products) {
      this.products.addAll(products);
      getPgination = false;
      ifNotFillScreen();

      emit(GetAllProductsSuccess());
    });
  }

  void addProduct(ProductModel product) {
    if (!canLoading()) {
      products.add(product);
      emit(GetAllProductsSuccess());
    }
  }

  void removeProduct(int id) {
    products.removeWhere((element) => element.id == id);
    emit(GetAllProductsSuccess());
  }

  void updateProduct(ProductModel product) {
    products[products.indexWhere((element) => element.id == product.id)] =
        product;
    emit(GetAllProductsSuccess());
  }

  @override
  void emit(GetAllProductsState state) {
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
    products = [];
    repo.reset();
  }
}
