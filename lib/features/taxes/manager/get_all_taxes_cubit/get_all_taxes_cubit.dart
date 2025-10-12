import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/core/constant/constant.dart';
import 'package:pos_app/features/taxes/data/model/taxes_model.dart';
import 'package:pos_app/features/taxes/data/repo/taxes_repo.dart';

part 'get_all_taxes_state.dart';

class GetAllTaxesCubit extends Cubit<GetAllTaxesState> {
  GetAllTaxesCubit(this.repo) : super(GetAllTaxesInitial());

  static GetAllTaxesCubit get(context) => BlocProvider.of(context);

  final TaxesRepo repo;

  List<TaxesModel> taxes = [];
  ScrollController scrollController = ScrollController();

  bool canLoading() => repo.getTaxesModel?.nextPageUrl != null;
  bool isFirstTimeGetData() => repo.getTaxesModel == null;

  void init() {
    if (isFirstTimeGetData()) {
      getTaxes();
    }

    scrollController.addListener(
      () {
        if (scrollController.position.maxScrollExtent ==
            scrollController.offset) {
          if (canLoading()) {
            getPaginationTaxes();
          }
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
            log("getPaginationPermissions");
            // ignore: use_build_context_synchronously
            getPaginationTaxes();
          });
        }
      });
    }
  }

  void getTaxes() async {
    emit(GetAllTaxesLoading());
    var response = await repo.getTaxes(
      isRefresh: true,
    );

    response
        .fold((errMessage) => emit(GetAllTaxesFailing(errMessage: errMessage)),
            (taxes) {
      this.taxes = taxes;
      ifNotFillScreen();
      emit(GetAllTaxesSuccess());
    });
  }

  void getPaginationTaxes() async {
    var response = await repo.getTaxes();

    response.fold(
        (errMessage) =>
            emit(GetAllTaxesPaginationFailing(errMessage: errMessage)),
        (taxes) {
      this.taxes.addAll(taxes);
      ifNotFillScreen();
      emit(GetAllTaxesSuccess());
    });
  }

  void deleteTaxes({required int id}) {
    taxes.removeWhere((element) => element.id == id);
    emit(GetAllTaxesSuccess());
  }

  void addTaxes({required TaxesModel taxes}) {
    if (!canLoading()) {
      this.taxes.add(taxes);
      emit(GetAllTaxesSuccess());
    }
  }

  void updateTaxes({required TaxesModel taxes}) {
    this.taxes[this.taxes.indexWhere((element) => element.id == taxes.id)] =
        taxes;
    emit(GetAllTaxesSuccess());
  }

  void reset() {
    taxes = [];
    repo.reset();
  }

  @override
  void emit(GetAllTaxesState state) {
    if (!isClosed) {
      super.emit(state);
    }
  }

  @override
  Future<void> close() {
    scrollController.dispose();
    return super.close();
  }
}
