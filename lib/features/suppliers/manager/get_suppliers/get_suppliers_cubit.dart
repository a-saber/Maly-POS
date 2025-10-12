import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/constant/constant.dart';
import 'package:pos_app/features/suppliers/data/models/supplier_model.dart';
import 'get_supplier_state.dart';
import '../../data/repo/suppliers_repo.dart';

class GetSuppliersCubit extends Cubit<GetSuppliersState> {
  final SuppliersRepo repo;

  GetSuppliersCubit(this.repo) : super(GetSuppliersInitial());

  static GetSuppliersCubit get(context) => BlocProvider.of(context);

  ScrollController scrollController = ScrollController();

  bool canLoading() => repo.getSuppliersModel!.nextPageUrl != null;
  bool firstTimeGetData() => repo.getSuppliersModel == null;

  List<SupplierModel> suppliers = [];

  void init() {
    if (firstTimeGetData()) {
      getSuppliers();
    }

    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        if (canLoading()) {
          getSuppliersPagination();
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
            getSuppliersPagination();
          });
        }
      });
    }
  }

  void getSuppliers() async {
    emit(GetSuppliersLoading());
    //  Remove wait
    // await Future.delayed(const Duration(seconds: 10));
    var response = await repo.getSuppliers(isRefresh: true);

    response.fold((error) => emit(GetSuppliersError(error)), (data) {
      suppliers = data;
      ifNotFillScreen();
      emit(GetSuppliersSuccess());
    });
  }

  bool paginationLoading = false;

  void getSuppliersPagination() async {
    if (paginationLoading) return;
    paginationLoading = true;
    var response = await repo.getSuppliers();

    response.fold((error) => emit(GetSuppliersErrorPagination(error)), (data) {
      suppliers.addAll(data);
      paginationLoading = false;
      ifNotFillScreen();
      emit(GetSuppliersSuccess());
    });
  }

  void deleteSupplier(int id) {
    suppliers.removeWhere((element) => element.id == id);
    emit(GetSuppliersSuccess());
  }

  void updateSupplier(SupplierModel supplier) {
    suppliers[suppliers.indexWhere((element) => element.id == supplier.id)] =
        supplier;
    emit(GetSuppliersSuccess());
  }

  void addSupplier(SupplierModel supplier) {
    if (!canLoading()) {
      suppliers.add(supplier);
      emit(GetSuppliersSuccess());
    }
  }

  void reset() {
    suppliers = [];
    repo.reset();
  }

  @override
  Future<void> close() {
    scrollController.dispose();
    return super.close();
  }
}
