import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:pos_app/core/api/api_helper.dart';
import 'package:pos_app/core/api/api_keys.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/features/units/data/model/add_or_update_unit_response_model.dart';
import 'package:pos_app/features/units/data/model/get_unit_model.dart';
import 'package:pos_app/features/units/data/model/unit_model.dart';

class UnitsRepo {
  final ApiHelper api;
  GetUnitModel? getUnitModel;
  GetUnitModel? getUnitSearchModel;

  UnitsRepo({required this.api});

  Future<Either<ApiResponse, List<UnitModel>>> getUnits({
    bool isRefresh = false,
  }) async {
    try {
      String url;
      if (getUnitModel == null || isRefresh) {
        url = await ApiEndPoints.getUnits();
      } else {
        if (getUnitModel!.nextPageUrl == null) {
          return Right([]);
        } else {
          url = getUnitModel!.nextPageUrl!;
        }
      }
      // ignore: use_build_context_synchronously
      var response = await api.get(
        url: url,
      );
      if (response.status) {
        getUnitModel = GetUnitModel.fromJson(response.data);
        return Right(getUnitModel!.data!);
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

  Future<Either<ApiResponse, UnitModel>> addUnit({
    required UnitModel unit,
  }) async {
    try {
      String url = await ApiEndPoints.getUnits();
      var response = await api.post(
        url: url,
        data: unit.toJsonWithoutId(),
      );
      if (response.status) {
        AddOrUpdateUnitResponseModel addOrUpdateUnitResponseModel =
            AddOrUpdateUnitResponseModel.fromJson(response.data!);
        if (addOrUpdateUnitResponseModel.success ?? false) {
          return Right(addOrUpdateUnitResponseModel.unit!);
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

  Future<Either<ApiResponse, UnitModel>> editUnit({
    required UnitModel newUnit,
  }) async {
    try {
      String url = await ApiEndPoints.getUnits();
      var response = await api.post(
        url: "$url/${newUnit.id}",
        data: newUnit.toJsonWithoutId(),
      );
      if (response.status) {
        AddOrUpdateUnitResponseModel addOrUpdateUnitResponseModel =
            AddOrUpdateUnitResponseModel.fromJson(response.data!);
        if (addOrUpdateUnitResponseModel.success ?? false) {
          return Right(addOrUpdateUnitResponseModel.unit!);
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
      return Left(ApiResponse.unKnownError());
    }
  }

  Future<Either<ApiResponse, int>> deleteUnit({
    required UnitModel unit,
  }) async {
    try {
      String url = await ApiEndPoints.getUnits();
      // ignore: use_build_context_synchronously
      var response = await api.delete(
        url: "$url/${unit.id}",
      );
      if (response.status) {
        return Right(unit.id!);
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

  Future<Either<ApiResponse, UnitModel>> getSpecificUnit({
    required int id,
  }) async {
    try {
      String url = await ApiEndPoints.getUnits();
      var response = await api.get(
        url: "$url/$id",
      );
      if (response.status) {
        AddOrUpdateUnitResponseModel addOrUpdateUnitResponseModel =
            AddOrUpdateUnitResponseModel.fromJson(response.data!);
        if (addOrUpdateUnitResponseModel.success ?? false) {
          return Right(addOrUpdateUnitResponseModel.unit!);
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

  Future<Either<ApiResponse, List<UnitModel>>> searchUnit(
      {required String query, bool isNew = false}) async {
    try {
      ApiResponse response;
      String url;
      if (getUnitSearchModel == null || isNew) {
        url = await ApiEndPoints.getUnits();
        if (query.isEmpty) {
          response = await api.get(
            url: url,
          );
        } else {
          response = await api.get(
            url: url,
            queryParameters: {
              ApiKeys.search: query,
            },
          );
        }
      } else {
        if (getUnitSearchModel!.nextPageUrl == null) {
          return Right([]);
        } else {
          url = getUnitSearchModel!.nextPageUrl!;
          response = await api.get(
            url: url,
          );
        }
      }
      if (response.status) {
        getUnitSearchModel = GetUnitModel.fromJson(response.data);
        return Right(getUnitSearchModel!.data!);
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

  void resetSearch() => getUnitSearchModel = null;

  void reset() {
    getUnitSearchModel = null;
    getUnitModel = null;
  }
}
