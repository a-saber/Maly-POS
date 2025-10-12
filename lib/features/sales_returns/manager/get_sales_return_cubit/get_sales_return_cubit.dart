import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/core/constant/constant.dart';
import 'package:pos_app/features/auth/login/data/model/branche_model.dart';
import 'package:pos_app/features/auth/login/data/model/user_model.dart';
import 'package:pos_app/features/discounts/data/model/discount_model.dart';
import 'package:pos_app/features/products/data/model/product_model.dart';
import 'package:pos_app/features/sales_returns/data/model/sales_return_model.dart';
import 'package:pos_app/features/sales_returns/data/repo/sales_return_repo.dart';
import 'package:pos_app/features/selling_point/data/model/type_of_take_order_model.dart';
import 'package:pos_app/features/taxes/data/model/taxes_model.dart';

part 'get_sales_return_state.dart';

class GetSalesReturnCubit extends Cubit<GetSalesReturnState> {
  GetSalesReturnCubit(this.repo) : super(GetSalesReturnInitial());

  static GetSalesReturnCubit get(context) => BlocProvider.of(context);
  final SalesReturnRepo repo;

  // Filter ///////////////////
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
  TypeOfTakeOrderModel? typeOfOrder;
  ////////////////////////////////
  ScrollController scrollController = ScrollController();
  List<SalesReturnModel> salesReturn = [];

  bool canLoading() => repo.getSalesReturnModel?.data?.nextPageUrl != null;
  bool firstTime() => repo.getSalesReturnModel == null;

  void init() async {
    if (firstTime()) getSalesReturn();

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          canLoading() &&
          !canPaginationLoading) {
        getSalesReturnPagination();
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
            getSalesReturnPagination();
          });
        }
      });
    }
  }

  void getSalesReturn() async {
    emit(GetSalesReturnLoading());
    //  : Remove wait
    // await Future.delayed(const Duration(seconds: 10));
    var response = await repo.getSalesReturns(
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
      typeOfTakeOrder: typeOfOrder,
      isRefresh: true,
    );

    response.fold(
        (errMessage) => emit(GetSalesReturnFailing(errMessage: errMessage)),
        (salesReturnList) {
      salesReturn = salesReturnList;
      ifNotFillScreen();
      emit(GetSalesReturnSuccess());
    });
  }

  bool canPaginationLoading = false;

  void getSalesReturnPagination() async {
    if (canPaginationLoading) return;
    canPaginationLoading = true;
    var response = await repo.getSalesReturns();
    response.fold(
        (errMessage) =>
            emit(GetSalesReturnPaginationFailing(errMessage: errMessage)),
        (salesReturnList) {
      salesReturn.addAll(salesReturnList);
      ifNotFillScreen();
      canPaginationLoading = false;
      emit(GetSalesReturnSuccess());
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
  }) async {
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
    typeOfOrder = typeOfTakeOrder;
    getSalesReturn();
  }

  void reset() {
    salesReturn = [];
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
    repo.reset();
  }

  @override
  Future<void> close() {
    scrollController.dispose();
    return super.close();
  }
}
