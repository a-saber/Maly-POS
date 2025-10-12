import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/core/constant/constant.dart';
import 'package:pos_app/features/discounts/data/model/discount_model.dart';
import 'package:pos_app/features/discounts/data/repo/discounts_repo.dart';

part 'get_all_discounts_state.dart';

class GetAllDiscountsCubit extends Cubit<GetAllDiscountsState> {
  GetAllDiscountsCubit(this.repo) : super(GetAllDiscountsInitial());

  static GetAllDiscountsCubit get(context) => BlocProvider.of(context);

  final DiscountsRepo repo;
  ScrollController scrollController = ScrollController();
  List<DiscountModel> discounts = [];

  bool canLoading() => repo.getDiscountModel?.nextPageUrl != null;
  bool firstTimeGetData() => repo.getDiscountModel == null;

  void init() {
    if (firstTimeGetData()) {
      getDiscounts();
    }
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        if (canLoading() && !_canPaginationLoading) {
          getPaginationDiscounts();
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
            getPaginationDiscounts();
          });
        }
      });
    }
  }

  void getDiscounts() async {
    emit(GetAllDiscountsLoading());
    // Remove wait
    // await Future.delayed(const Duration(seconds: 10));
    var response = await repo.getDiscounts(isRefresh: true);

    response.fold((error) => emit(GetAllDiscountsFailing(errMessage: error)),
        (data) {
      discounts = data;
      ifNotFillScreen();
      emit(GetAllDiscountsSuccess());
    });
  }

  bool _canPaginationLoading = false;

  void getPaginationDiscounts() async {
    if (_canPaginationLoading) {
      return;
    }
    _canPaginationLoading = true;

    var response = await repo.getDiscounts();

    response.fold(
        (error) => emit(GetAllDiscountsPaginationFailing(errMessage: error)),
        (data) {
      discounts.addAll(data);
      ifNotFillScreen();
      _canPaginationLoading = false;
      emit(GetAllDiscountsSuccess());
    });
  }

  void addDiscount(DiscountModel discount) {
    if (!canLoading()) {
      discounts.add(discount);
      emit(GetAllDiscountsSuccess());
    }
  }

  void editDiscount(DiscountModel discount) {
    discounts[discounts.indexWhere((element) => element.id == discount.id)] =
        discount;
    emit(GetAllDiscountsSuccess());
  }

  void deleteDiscount(int id) {
    discounts.removeWhere((element) => element.id == id);
    emit(GetAllDiscountsSuccess());
  }

  void reset() {
    discounts = [];
    repo.reset();
  }

  @override
  void emit(GetAllDiscountsState state) {
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
