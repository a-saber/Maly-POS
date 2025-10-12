import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:pos_app/core/api/api_helper.dart';
import 'package:pos_app/core/api/api_keys.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/features/auth/login/data/model/branche_model.dart';
import 'package:pos_app/features/auth/login/data/model/user_model.dart';
import 'package:pos_app/features/categories/data/model/category_model.dart';
import 'package:pos_app/features/products/data/model/product_model.dart';
import 'package:pos_app/features/store_move/data/model/store_movement_data.dart';
import 'package:pos_app/features/store_move/data/model/store_movement_model.dart';
import 'package:pos_app/features/store_move/data/model/type_of_movement_model.dart';
import 'package:pos_app/features/units/data/model/unit_model.dart';

class StoreMoveRepo {
  final ApiHelper api;

  StoreMovementsModel? storeMovementsModel;

  StoreMoveRepo({required this.api});

  Future<Either<ApiResponse, List<StoreMovementData>>> getStoreMovementsData({
    BrancheModel? branch,
    CategoryModel? category,
    UnitModel? unit,
    UserModel? user,
    ProductModel? product,
    TypeOfMovementModel? typeOfmove,
    String? startDate,
    String? endDate,
    String? search,
    String? sortOrder,
    String? sortBy,
    String? quantityMin,
    String? quantityMax,
    bool isRefresh = false,
  }) async {
    try {
      String url;
      ApiResponse apiResponse;
      if (storeMovementsModel == null || isRefresh) {
        url = await ApiEndPoints.getStoreMovements();
        var queryParameters = _getProductQueryParameter(
          branch: branch,
          category: category,
          unit: unit,
          user: user,
          product: product,
          typeOfmove: typeOfmove,
          startDate: startDate,
          endDate: endDate,
          search: search,
          sortOrder: sortOrder,
          sortBy: sortBy,
          quantityMin: quantityMin,
          quantityMax: quantityMax,
        );
        apiResponse = await api.get(
          url: url,
          queryParameters: queryParameters,
        );
      } else {
        if (storeMovementsModel?.movements?.nextPageUrl == null) {
          return Right([]);
        } else {
          url = storeMovementsModel!.movements!.nextPageUrl!;
          apiResponse = await api.get(
            url: url,
          );
        }
      }
      if (apiResponse.status) {
        storeMovementsModel = StoreMovementsModel.fromJson(apiResponse.data);
        return Right(storeMovementsModel!.movements!.data!);
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

  Map<String, dynamic> _getProductQueryParameter({
    BrancheModel? branch,
    CategoryModel? category,
    UnitModel? unit,
    UserModel? user,
    ProductModel? product,
    TypeOfMovementModel? typeOfmove,
    String? startDate,
    String? endDate,
    String? search,
    String? sortOrder,
    String? sortBy,
    String? quantityMin,
    String? quantityMax,
  }) {
    Map<String, dynamic> map = {};
    if (search != null && search.isNotEmpty) {
      map[ApiKeys.search] = search;
    }
    if (branch != null) {
      map[ApiKeys.branchid] = branch.id;
    }
    if (category != null) {
      map[ApiKeys.categoryId] = category.id;
    }
    if (unit != null) {
      map[ApiKeys.unitId] = unit.id;
    }
    if (user != null) {
      map[ApiKeys.userid] = user.id;
    }
    if (product != null) {
      map[ApiKeys.productid] = product.id;
    }
    if (typeOfmove != null) {
      map[ApiKeys.movementtype] = typeOfmove.value;
    }
    if (startDate != null && startDate.isNotEmpty) {
      map[ApiKeys.startDate] = startDate;
    }
    if (endDate != null && endDate.isNotEmpty) {
      map[ApiKeys.endDate] = endDate;
    }
    if (sortOrder != null && sortOrder.isNotEmpty) {
      map[ApiKeys.sortOrder] = sortOrder;
    }
    if (sortBy != null && sortBy.isNotEmpty) {
      map[ApiKeys.sortBy] = sortBy;
    }
    if (quantityMin != null && quantityMin.isNotEmpty) {
      map[ApiKeys.quantityMin] = quantityMin;
    }
    if (quantityMax != null && quantityMax.isNotEmpty) {
      map[ApiKeys.quantityMax] = quantityMax;
    }

    return map;
  }

  void reset() => storeMovementsModel = null;
}
