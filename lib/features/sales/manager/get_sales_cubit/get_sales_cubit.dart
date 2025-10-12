import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/core/constant/constant.dart';
import 'package:pos_app/features/auth/login/data/model/branche_model.dart';
import 'package:pos_app/features/auth/login/data/model/user_model.dart';
import 'package:pos_app/features/discounts/data/model/discount_model.dart';
import 'package:pos_app/features/products/data/model/product_model.dart';
import 'package:pos_app/features/sales/data/model/sales_model.dart';
import 'package:pos_app/features/sales/data/repo/sales_repo.dart';
import 'package:pos_app/features/selling_point/data/model/type_of_take_order_model.dart';
import 'package:pos_app/features/taxes/data/model/taxes_model.dart';

part 'get_sales_state.dart';

class GetSalesCubit extends Cubit<GetSalesState> {
  GetSalesCubit(this.repo) : super(GetSalesInitial());

  static GetSalesCubit get(context) => BlocProvider.of(context);

  final SalesRepo repo;

  ScrollController scrollController = ScrollController();

  List<SalesModel> sales = [];

  bool canLoading() => repo.getSalesModel?.data?.nextPageUrl != null;

  bool firstTime() => repo.getSalesModel == null;

  BrancheModel? branch;
  UserModel? user;
  DiscountModel? discount;
  TaxesModel? taxes;
  ProductModel? product;
  String? paymentMethod;
  String? sort;
  String? sortBy;
  String? from;
  String? to;
  TypeOfTakeOrderModel? typeOfTakeOrder;

  void init() {
    if (firstTime()) {
      getSales();
    }

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          canLoading() &&
          !canPaginationLoading) {
        getSalesPagination();
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
            getSalesPagination();
          });
        }
      });
    }
  }

  void getSales() async {
    emit(GetSalesLoading());

    var response = await repo.getSales(
      branch: branch,
      user: user,
      discount: discount,
      taxes: taxes,
      product: product,
      paymentMethod: paymentMethod,
      sort: sort,
      sortBy: sortBy,
      from: from,
      to: to,
      typeOfTakeOrder: typeOfTakeOrder,
      isRefresh: true,
    );

    response.fold((errMessage) => emit(GetSalesFailing(errMessage: errMessage)),
        (salesList) {
      sales = salesList;
      ifNotFillScreen();
      emit(GetSalesSuccess());
    });
  }

  bool canPaginationLoading = false;

  void getSalesPagination() async {
    if (canPaginationLoading) return;
    canPaginationLoading = true;
    var response = await repo.getSales();
    response.fold(
        (errMessage) => emit(GetSalesPaginationFailing(errMessage: errMessage)),
        (salesList) {
      sales.addAll(salesList);
      ifNotFillScreen();
      canPaginationLoading = false;
      emit(GetSalesSuccess());
    });
  }

  void filter({
    BrancheModel? branch,
    UserModel? user,
    DiscountModel? discount,
    TaxesModel? taxes,
    ProductModel? product,
    String? paymentMethod,
    String? sort,
    String? sortBy,
    String? from,
    String? to,
    TypeOfTakeOrderModel? typeOfTakeOrder,
    required BuildContext context,
  }) {
    this.branch = branch;
    this.user = user;
    this.discount = discount;
    this.taxes = taxes;
    this.product = product;
    this.paymentMethod = paymentMethod;
    this.sort = sort;
    this.sortBy = sortBy;
    this.from = from;
    this.to = to;
    this.typeOfTakeOrder = typeOfTakeOrder;
    getSales();
  }

  void reset() {
    sales = [];
    branch = null;
    user = null;
    discount = null;
    taxes = null;
    product = null;
    paymentMethod = null;
    sort = null;
    sortBy = null;
    from = null;
    to = null;
    typeOfTakeOrder = null;
    repo.reset();
  }

  @override
  Future<void> close() {
    scrollController.dispose();
    return super.close();
  }
}
