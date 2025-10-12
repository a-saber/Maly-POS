import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/core/helper/my_service_locator.dart';
import 'package:pos_app/features/products/data/model/product_model.dart';
import 'package:pos_app/features/selling_point/data/model/category_saving_data_model.dart';
import 'package:pos_app/features/selling_point/data/repo/selling_point_repo.dart';
import 'package:pos_app/features/selling_point/manager/selling_point_product_cubit/selling_point_product_cubit.dart';

part 'selling_point_state.dart';

class SellingPointCubit extends Cubit<SellingPointState> {
  SellingPointCubit(this.repo) : super(SellingPointInitial());

  static SellingPointCubit get(context) => BlocProvider.of(context);
  final SellingPointRepo repo;

  int categoryId = -2;

  late ScrollController scrollController;

  late String query;

  // bool canLoading() => repo.canLoading;
  // bool firstTime() => repo.getProductsSearchModel == null;

  List<CategorySavingDataModel> categorySavingDataModels = [];

  List<ProductModel> getProducts() {
    int index = repo.currentIndex(categoryId: categoryId);
    if (index == -1) {
      return [];
    } else {
      if (query.isEmpty) {
        return categorySavingDataModels[index].products ?? [];
      } else {
        return categorySavingDataModels[index].searchProduct ?? [];
      }
    }
  }

  bool canLoading() {
    int index = repo.currentIndex(categoryId: categoryId);
    if (index == -1) {
      return false;
    }

    if (query.isEmpty &&
        repo.categorySavingDataModels[index].getProductsModel?.data
                ?.nextPageUrl ==
            null) {
      return false;
    }
    if (query.isNotEmpty &&
        repo.categorySavingDataModels[index].getProductsSearchModel?.data
                ?.nextPageUrl ==
            null) {
      return false;
    }
    return true;
  }

  bool isFirstTime = true;

  void init() {
    // if (firstTime()) {
    //   getCategoryProduct(context: context);
    // }
    if (isFirstTime) {
      scrollController = ScrollController();

      query = '';
      categorySavingDataModels = [];
      categoryId = -2;
      isFirstTime = false;
    }
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
              scrollController.offset &&
          (canLoading())) {
        getPaginationProduct();
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
        if (ifScrollNotFillScreen() && canLoading()) {
          getPaginationProduct();
        }
      });
    }
  }

  Future<void> getCategoryProduct(
      {bool newData = false, bool refreshAllData = false}) async {
    emit(SellingPointInitialGetProductLoading());
    final result = await repo.getData(
      refreshAllData: refreshAllData,
      refreshCurrentCategory: query.isEmpty ? newData : false,
      categortyId: categoryId,
      search: query,
      perpage: 20,
    );
    result.fold(
        (errMessage) =>
            emit(SellingPointInitialGetProductFailing(errMessage: errMessage)),
        (saving) {
      categorySavingDataModels = List.from(saving);
      ifNotFillScreen();
      emit(
        SellingPointInitialGetProductSuccess(),
      );
    });
  }

  bool _paginationLOading = false;

  Future<void> getPaginationProduct() async {
    if (_paginationLOading) {
      return;
    }
    _paginationLOading = true;
    final result = await repo.getData(
      search: query,
      categortyId: categoryId,
    );
    result.fold(
        (errMessage) => emit(
            SellingPointPaginationGetProductFailing(errMessage: errMessage)),
        (data) {
      categorySavingDataModels = List.from(data);

      _paginationLOading = false;
      ifNotFillScreen();
      emit(
        SellingPointPaginationGetProductSuccess(),
      );
    });
  }

  void changeCategorytId({
    required int? id,
  }) {
    if (id == null) {
      return;
    }
    if (categoryId != id) {
      categoryId = id;

      getCategoryProduct();
    }
  }

  Timer? _debounce;
  void onSearchChanged(
    String query,
  ) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 300), () {
      this.query = query;
      getCategoryProduct();
    });
  }

  void addProduct(ProductModel product) {
    bool add = repo.addProductToAllAndSpecificCategory(product: product);
    if (add) {
      categorySavingDataModels = repo.categorySavingDataModels;
      emit(SellingPointProductsUpdate());
    }
  }

  void updateProduct(ProductModel product,
      {required int? oldCayegoryId, required BuildContext context}) {
    bool update = repo.updateProductToAllAndSpecificCategory(
        product: product, oldCayegoryId: oldCayegoryId);
    if (update) {
      categorySavingDataModels = repo.categorySavingDataModels;
      MyServiceLocator.getSingleton<SellingPointProductCubit>()
          .updateProduct(product);
      emit(SellingPointProductsUpdate());
    }
  }

  void deleteProduct(ProductModel product, {required BuildContext context}) {
    bool delete = repo.deleteProductToAllAndSpecificCategory(product: product);
    if (delete) {
      categorySavingDataModels = repo.categorySavingDataModels;
      MyServiceLocator.getSingleton<SellingPointProductCubit>()
          .deleteProduct(product);
      emit(SellingPointProductsUpdate());
    }
  }

  bool getProduct = false;

  void getFirstTimeProduct() {
    if (!getProduct) {
      changeCategorytId(
        id: -1,
      );
      getProduct = true;
    }
  }

  void reset({required BuildContext context}) {
    categorySavingDataModels = [];
    getProduct = false;
    categoryId = -2;
    repo.resetModel();
    isFirstTime = true;
    MyServiceLocator.getSingleton<SellingPointProductCubit>().init();

    emit(SellingPointInitial());
  }

  @override
  void emit(SellingPointState state) {
    if (!isClosed) {
      super.emit(state);
    }
  }
}
