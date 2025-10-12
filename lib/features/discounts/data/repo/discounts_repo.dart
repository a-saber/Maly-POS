import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:pos_app/core/api/api_helper.dart';
import 'package:pos_app/core/api/api_keys.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/features/discounts/data/model/add_or_update_discount_model.dart';
import 'package:pos_app/features/discounts/data/model/discount_model.dart';
import 'package:pos_app/features/discounts/data/model/get_discount_model.dart';

class DiscountsRepo {
  final ApiHelper api;
  GetDiscountModel? getDiscountModel;
  GetDiscountModel? getDiscountSearchModel;
  DiscountsRepo({required this.api});

  Future<Either<ApiResponse, List<DiscountModel>>> getDiscounts(
      {bool isRefresh = false}) async {
    try {
      String? url;
      if (getDiscountModel == null || isRefresh) {
        url = await ApiEndPoints.getDiscounts();
      } else {
        if (getDiscountModel!.nextPageUrl == null) {
          return Right([]);
        } else {
          url = getDiscountModel!.nextPageUrl;
        }
      }

      // ignore: use_build_context_synchronously
      var response = await api.get(
        url: url!,
      );
      if (response.status) {
        getDiscountModel = GetDiscountModel.fromJson(response.data);
        return Right(getDiscountModel!.data!);
      } else {
        return Left(
          response,
        );
      }
    } catch (e) {
      debugPrint(e.toString());
      // ignore: use_build_context_synchronously
      return Left(ApiResponse.unKnownError());
    }
  }

  Future<Either<ApiResponse, DiscountModel>> addDiscount({
    required DiscountModel discount,
  }) async {
    try {
      String url = await ApiEndPoints.getDiscounts();
      var response = await api.post(
        url: url,
        data: discount.toJsonWithoutId(),
      );
      if (response.status) {
        AddOrUpdateDiscountResponse addOrUpdateDiscountResponse =
            AddOrUpdateDiscountResponse.fromJson(response.data);
        if (addOrUpdateDiscountResponse.success ?? false) {
          return Right(addOrUpdateDiscountResponse.discount!);
        } else {
          return Left(
            response,
          );
        }
      } else {
        return Left(
          response,
        );
      }
    } catch (e) {
      debugPrint(e.toString());
      // ignore: use_build_context_synchronously
      return Left(ApiResponse.unKnownError());
    }
  }

  Future<Either<ApiResponse, DiscountModel>> editDiscount({
    required DiscountModel discount,
  }) async {
    try {
      String url = await ApiEndPoints.getDiscounts();
      var response = await api.post(
        url: "$url/${discount.id}",
        data: discount.toJsonWithoutId(),
      );
      if (response.status) {
        AddOrUpdateDiscountResponse addOrUpdateDiscountResponse =
            AddOrUpdateDiscountResponse.fromJson(response.data);
        if (addOrUpdateDiscountResponse.success ?? false) {
          return Right(addOrUpdateDiscountResponse.discount!);
        } else {
          return Left(
            response,
          );
        }
      } else {
        return Left(
          response,
        );
      }
    } catch (e) {
      debugPrint(e.toString());
      // ignore: use_build_context_synchronously
      return Left(ApiResponse.unKnownError());
    }
  }

  Future<Either<ApiResponse, int>> deleteDiscount({
    required DiscountModel discount,
  }) async {
    try {
      String url = await ApiEndPoints.getDiscounts();
      var response = await api.delete(
        url: "$url/${discount.id}",
      );

      if (response.status) {
        return Right(discount.id!);
      } else {
        return Left(
          response,
        );
      }
    } catch (e) {
      return Left(ApiResponse.unKnownError());
    }
  }

  Future<Either<ApiResponse, List<DiscountModel>>> searchDiscounts({
    required String search,
    bool isRefresh = false,
  }) async {
    try {
      ApiResponse apiResponse;
      String url;
      if (getDiscountSearchModel == null || isRefresh) {
        url = await ApiEndPoints.getDiscounts();
        apiResponse = await api.get(
          url: url,
          queryParameters: {
            ApiKeys.search: search,
          },
        );
      } else {
        if (getDiscountSearchModel?.nextPageUrl == null) {
          return Right([]);
        } else {
          url = getDiscountSearchModel!.nextPageUrl!;
          apiResponse = await api.get(
            url: url,
          );
        }
      }

      if (apiResponse.status) {
        getDiscountSearchModel = GetDiscountModel.fromJson(apiResponse.data!);
        return Right(getDiscountSearchModel!.data!);
      } else {
        return Left(
          apiResponse,
        );
      }
    } catch (e) {
      debugPrint(e.toString());
      // ignore: use_build_context_synchronously
      return Left(ApiResponse.unKnownError());
    }
  }

  void resetSearch() {
    getDiscountSearchModel = null;
  }

  void reset() {
    getDiscountSearchModel = null;
    getDiscountModel = null;
  }
}
