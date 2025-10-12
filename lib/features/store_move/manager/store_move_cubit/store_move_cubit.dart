import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/core/constant/constant.dart';
import 'package:pos_app/features/auth/login/data/model/branche_model.dart';
import 'package:pos_app/features/auth/login/data/model/user_model.dart';
import 'package:pos_app/features/categories/data/model/category_model.dart';
import 'package:pos_app/features/products/data/model/product_model.dart';
import 'package:pos_app/features/store_move/data/model/store_movement_data.dart';
import 'package:pos_app/features/store_move/data/model/type_of_movement_model.dart';
import 'package:pos_app/features/store_move/data/repo/store_move_repo.dart';
import 'package:pos_app/features/units/data/model/unit_model.dart';

part 'store_move_state.dart';

class StoreMoveCubit extends Cubit<StoreMoveState> {
  StoreMoveCubit(this.repo) : super(StoreMoveInitial());

  static StoreMoveCubit get(context) => BlocProvider.of(context);

  final StoreMoveRepo repo;
  List<StoreMovementData> storeMoveList = [];
  ScrollController scrollController = ScrollController();
  String query = '';

  bool canLoading() => repo.storeMovementsModel?.movements?.nextPageUrl != null;
  bool firstTime() => repo.storeMovementsModel == null;

  BrancheModel? branch;
  CategoryModel? category;
  UnitModel? unit;
  UserModel? user;
  ProductModel? product;
  TypeOfMovementModel? typeOfmove;
  String? startDate;
  String? endDate;
  String? sortOrder;
  String? sortBy;
  String? quantityMin;
  String? quantityMax;

  void init() async {
    if (firstTime()) {
      getAllData();
    }

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          canLoading() &&
          !canPaginationLoading) {
        getAllDataPagination();
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
            getAllDataPagination();
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
      getAllData();
    });
  }

  Future<void> getAllData() async {
    emit(StoreMoveLoading());
    var response = await repo.getStoreMovementsData(
      branch: branch,
      category: category,
      unit: unit,
      user: user,
      product: product,
      typeOfmove: typeOfmove,
      startDate: startDate,
      endDate: endDate,
      search: query,
      isRefresh: true,
      sortOrder: sortOrder,
      sortBy: sortBy,
      quantityMin: quantityMin,
      quantityMax: quantityMax,
    );
    response
        .fold((errMessage) => emit(StoreMoveFailing(errMessage: errMessage)),
            (storeMoveList) {
      this.storeMoveList = storeMoveList;
      ifNotFillScreen();
      emit(StoreMoveSuccess());
    });
  }

  bool canPaginationLoading = false;

  void getAllDataPagination() async {
    if (canPaginationLoading) return;
    canPaginationLoading = true;
    var ressponse = await repo.getStoreMovementsData();
    ressponse.fold(
        (errMessage) =>
            emit(StoreMoveFailingPagination(errMessage: errMessage)),
        (storeMoveList) {
      this.storeMoveList.addAll(storeMoveList);
      ifNotFillScreen();
      canPaginationLoading = false;
      emit(StoreMoveSuccess());
    });
  }

  Future<void> filterData({
    required CategoryModel? category,
    required ProductModel? product,
    required UnitModel? unit,
    required UserModel? user,
    required BrancheModel? branch,
    required TypeOfMovementModel? typeOfmove,
    required String? startDate,
    required String? endDate,
    required String? sortOrder,
    required String? sortBy,
    required String? quantityMin,
    required String? quantityMax,
  }) async {
    this.category = category;
    this.product = product;
    this.unit = unit;
    this.user = user;
    this.branch = branch;
    this.typeOfmove = typeOfmove;
    this.startDate = startDate;
    this.endDate = endDate;
    this.sortOrder = sortOrder;
    this.sortBy = sortBy;
    this.quantityMin = quantityMin;
    this.quantityMax = quantityMax;

    getAllData();
  }

  void reset() {
    query = '';
    storeMoveList = [];
    branch = null;
    category = null;
    unit = null;
    user = null;
    product = null;
    typeOfmove = null;
    startDate = null;
    endDate = null;
    sortOrder = null;
    sortBy = null;
    quantityMin = null;
    quantityMax = null;

    repo.reset();
  }

  @override
  Future<void> close() {
    scrollController.dispose();
    _debounce?.cancel();
    return super.close();
  }
}
