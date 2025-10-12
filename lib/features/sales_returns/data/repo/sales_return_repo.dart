import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:pos_app/core/api/api_helper.dart';
import 'package:pos_app/core/api/api_keys.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/features/auth/login/data/model/branche_model.dart';
import 'package:pos_app/features/auth/login/data/model/user_model.dart';
import 'package:pos_app/features/discounts/data/model/discount_model.dart';
import 'package:pos_app/features/products/data/model/product_model.dart';
import 'package:pos_app/features/sales_returns/data/model/get_sales_return_model.dart';
import 'package:pos_app/features/sales_returns/data/model/sales_return_model.dart';
import 'package:pos_app/features/selling_point/data/model/type_of_take_order_model.dart';
import 'package:pos_app/features/taxes/data/model/taxes_model.dart';

class SalesReturnRepo {
  final ApiHelper api;
  GetSalesReturnModel? getSalesReturnModel;

  SalesReturnRepo({required this.api});

  Future<Either<ApiResponse, List<SalesReturnModel>>> getSalesReturns({
    BrancheModel? branch,
    UserModel? user,
    DiscountModel? discount,
    TaxesModel? taxes,
    ProductModel? product,
    TypeOfTakeOrderModel? typeOfTakeOrder,
    String? paymentMethod,
    String? sort,
    String? sortBy,
    String? from,
    String? to,
    bool isRefresh = false,
  }) async {
    try {
      ApiResponse apiResponse;
      String url;
      if (getSalesReturnModel == null || isRefresh) {
        url = await ApiEndPoints.getSalesReturns();
        var queryParameters = _getSalesQueryParameter(
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
        );
        apiResponse = await api.get(
          url: url,
          queryParameters: queryParameters,
        );
      } else {
        if (getSalesReturnModel?.data?.nextPageUrl == null) {
          return Right([]);
        } else {
          url = getSalesReturnModel!.data!.nextPageUrl!;
          apiResponse = await api.get(
            url: url,
          );
        }
      }

      if (apiResponse.status) {
        getSalesReturnModel = GetSalesReturnModel.fromJson(apiResponse.data!);
        return Right(getSalesReturnModel!.data!.data!);
      } else {
        return Left(
          apiResponse,
        );
      }
    } catch (e) {
      debugPrint(e.toString());
      return Left(
        ApiResponse.unKnownError(),
      );
    }
  }

  Map<String, dynamic> _getSalesQueryParameter({
    required BrancheModel? branch,
    required UserModel? user,
    required DiscountModel? discount,
    required TaxesModel? taxes,
    required ProductModel? product,
    required String? paymentMethod,
    required TypeOfTakeOrderModel? typeOfTakeOrder,
    required String? sort,
    required String? sortBy,
    required String? from,
    required String? to,
  }) {
    Map<String, dynamic> map = {};
    if (from != null && to != null && from.isNotEmpty && to.isNotEmpty) {
      map[ApiKeys.from] = from;
      map[ApiKeys.to] = to;
    }
    if (branch != null) {
      map[ApiKeys.branchid] = branch.id;
    }
    if (typeOfTakeOrder != null) {
      map[ApiKeys.ordertype] = typeOfTakeOrder.apiKey;
    }
    if (user != null) {
      map[ApiKeys.userid] = user.id;
    }
    if (discount != null) {
      map[ApiKeys.discountid] = discount.id;
    }
    if (taxes != null) {
      map[ApiKeys.taxid] = taxes.id;
    }
    if (product != null) {
      map[ApiKeys.productid] = product.id;
    }
    if (paymentMethod != null && paymentMethod.isNotEmpty) {
      map[ApiKeys.paymentmethod] = paymentMethod;
    }
    if (sort != null &&
        sort.isNotEmpty &&
        sortBy != null &&
        sortBy.isNotEmpty) {
      map[ApiKeys.sort] = sort;
      map[ApiKeys.sortBy] = sortBy;
    }

    return map;
  }

  void reset() {
    getSalesReturnModel = null;
  }
}
