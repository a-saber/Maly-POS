import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:pos_app/core/api/api_helper.dart';
import 'package:pos_app/core/api/api_keys.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/features/auth/login/data/model/branche_model.dart';
import 'package:pos_app/features/categories/data/model/category_model.dart';
import 'package:pos_app/features/products/data/model/product_model.dart';
import 'package:pos_app/features/store_quantity/data/model/store_quanitiy_model.dart';
import 'package:pos_app/features/store_quantity/data/model/store_quantity_product_model.dart';
import 'package:pos_app/features/units/data/model/unit_model.dart';

class StoreQuantityRepo {
  final ApiHelper api;
  StoreQuantityModel? getStoreQuantityModel;

  StoreQuantityRepo({required this.api});

  Future<Either<ApiResponse, List<StoreQuantityProductModel>>> getProducts({
    BrancheModel? branch,
    CategoryModel? category,
    UnitModel? unit,
    String? search,
    double? minPrice,
    double? maxPrice,
    int? minQuantity,
    int? maxQuantity,
    ProductModel? product,
    bool isfresh = false,
  }) async {
    try {
      var queryParameters = _getProductQueryParameter(
        branch: branch,
        category: category,
        unit: unit,
        minPrice: minPrice,
        maxPrice: maxPrice,
        minQuantity: minQuantity,
        maxQuantity: maxQuantity,
        product: product,
        search: search,
      );
      String url;
      ApiResponse apiResponse;

      if (getStoreQuantityModel == null || isfresh) {
        url = await ApiEndPoints.getStoreQuantity();
        apiResponse = await api.get(
          url: url,
          queryParameters: queryParameters,
        );
      } else {
        if (getStoreQuantityModel?.data?.nextPageUrl == null) {
          return Right([]);
        } else {
          url = getStoreQuantityModel!.data!.nextPageUrl!;
          apiResponse = await api.get(
            url: url,

            // queryParameters: queryParameters,
          );
        }
      }
      if (apiResponse.status) {
        getStoreQuantityModel = StoreQuantityModel.fromJson(apiResponse.data);
        return Right(getStoreQuantityModel!.data!.data!);
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
    double? minPrice,
    double? maxPrice,
    int? minQuantity,
    int? maxQuantity,
    String? search,
    ProductModel? product,
  }) {
    Map<String, dynamic> map = {};
    if (search != null && search.isNotEmpty) {
      map[ApiKeys.search] = search;
    }
    if (branch != null) {
      map[ApiKeys.branchid] = branch.id;
    }
    if (product != null) {
      map[ApiKeys.productid] = product.id;
    }
    // if(category != null){
    //   map[ApiKeys.categoryId] = category.id;
    // }
    // if(unit != null){
    //   map[ApiKeys.unitId] = unit.id;
    // }
    // if(minPrice != null){
    //   map[ApiKeys.minPrice] = minPrice;
    // }
    // if(maxPrice != null){
    //   map[ApiKeys.maxPrice] = maxPrice;
    // }
    // if(minQuantity != null){
    //   map[ApiKeys.minQuantity] = minQuantity;
    // }
    // if(maxQuantity != null){
    //   map[ApiKeys.maxQuantity] = maxQuantity;
    // }
    return map;
  }

  void clear() {
    getStoreQuantityModel = null;
  }
}
