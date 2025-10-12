import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:pos_app/core/api/api_helper.dart';
import 'package:pos_app/core/api/api_keys.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/features/taxes/data/model/add_or_update_taxes_response_model.dart';
import 'package:pos_app/features/taxes/data/model/get_taxes_model.dart';
import 'package:pos_app/features/taxes/data/model/taxes_model.dart';

class TaxesRepo {
  final ApiHelper api;
  GetTaxesModel? getTaxesModel;
  GetTaxesModel? getTaxesSearchModel;

  TaxesRepo({required this.api});

  Future<Either<ApiResponse, List<TaxesModel>>> getTaxes({
    bool isRefresh = false,
  }) async {
    try {
      String url;
      if (getTaxesModel == null || isRefresh) {
        url = await ApiEndPoints.getTaxes();
      } else {
        if (getTaxesModel!.nextPageUrl == null) {
          return Right([]);
        } else {
          url = getTaxesModel!.nextPageUrl!;
        }
      }
      // ignore: use_build_context_synchronously
      var response = await api.get(
        url: url,
      );
      if (response.status) {
        getTaxesModel = GetTaxesModel.fromJson(response.data);
        return Right(getTaxesModel!.data!);
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

  Future<Either<ApiResponse, TaxesModel>> addTax({
    required TaxesModel tax,
  }) async {
    try {
      String url = await ApiEndPoints.getTaxes();
      var response = await api.post(
        url: url,
        data: tax.toJsonWithoutId(),
      );
      if (response.status) {
        AddOrUpdateTaxesResponseModel addOrUpdateTaxesResponseModel =
            AddOrUpdateTaxesResponseModel.fromJson(response.data!);
        if (addOrUpdateTaxesResponseModel.success ?? false) {
          return Right(addOrUpdateTaxesResponseModel.tax!);
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

  Future<Either<ApiResponse, TaxesModel>> editTax({
    required TaxesModel tax,
  }) async {
    try {
      String url = await ApiEndPoints.getTaxes();
      var response = await api.post(
        url: "$url/${tax.id}",
        data: tax.toJsonWithoutId(),
      );
      if (response.status) {
        AddOrUpdateTaxesResponseModel addOrUpdateTaxesResponseModel =
            AddOrUpdateTaxesResponseModel.fromJson(response.data!);
        if (addOrUpdateTaxesResponseModel.success ?? false) {
          return Right(addOrUpdateTaxesResponseModel.tax!);
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

  Future<Either<ApiResponse, int>> deleteTax({
    required TaxesModel tax,
  }) async {
    try {
      String url = await ApiEndPoints.getTaxes();
      var response = await api.delete(
        url: "$url/${tax.id}",
      );
      return response.status
          ? Right(tax.id!)
          : Left(
              response,
            );
    } catch (e) {
      debugPrint(e.toString());
      // ignore: use_build_context_synchronously
      return Left(ApiResponse.unKnownError());
    }
  }

  Future<Either<ApiResponse, List<TaxesModel>>> getSearchTaxes(
      {required String search, bool isRefresh = false}) async {
    try {
      ApiResponse apiResponse;
      String url;
      if (getTaxesSearchModel == null || isRefresh) {
        url = await ApiEndPoints.getTaxes();
        apiResponse = await api.get(
          url: url,
          queryParameters: {
            ApiKeys.search: search,
          },
        );
      } else {
        if (getTaxesSearchModel?.nextPageUrl == null) {
          return Right([]);
        } else {
          url = getTaxesSearchModel!.nextPageUrl!;
          apiResponse = await api.get(
            url: url,
          );
        }
      }
      if (apiResponse.status) {
        getTaxesSearchModel = GetTaxesModel.fromJson(apiResponse.data!);
        return Right(getTaxesSearchModel!.data!);
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

  void resetSearch() {
    getTaxesSearchModel = null;
  }

  void reset() {
    getTaxesSearchModel = null;
    getTaxesModel = null;
  }
}
