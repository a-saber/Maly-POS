import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:pos_app/core/api/api_helper.dart';
import 'package:pos_app/core/api/api_keys.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/features/auth/login/data/model/branche_model.dart';
import 'package:pos_app/features/products/data/model/add_or_update_product_model.dart';
import 'package:pos_app/features/products/data/model/get_products_model.dart';
import 'package:pos_app/features/products/data/model/product_model.dart';
import 'package:pos_app/features/units/data/model/unit_model.dart';

class ProductsRepo {
  final ApiHelper api;
  GetProductsModel? getProductsModel;
  GetProductsModel? searchProductsModel;

  ProductsRepo({required this.api});

  Future<Either<ApiResponse, List<ProductModel>>> getProducts({
    bool isfresh = false,
  }) async {
    try {
      String? url;
      if (getProductsModel == null || isfresh) {
        url = await ApiEndPoints.getProducts();
      } else {
        if (getProductsModel!.data?.nextPageUrl == null) {
          return Right([]);
        } else {
          url = getProductsModel!.data!.nextPageUrl!;
        }
      }
      var response = await api.get(
        url: url,
      );
      if (response.status) {
        getProductsModel = GetProductsModel.fromJson(response.data);
        return Right(getProductsModel!.data!.data!);
      } else {
        return Left(
          response,
        );
      }
    } catch (e) {
      debugPrint(e.toString());
      return Left(
        ApiResponse.unKnownError(),
      );
    }
  }

  Future<Either<ApiResponse, ProductModel>> addProduct({
    required String openingquantity,
    required BrancheModel? branch,
    required ProductModel product,
    required UnitModel unit,
  }) async {
    try {
      String url = await ApiEndPoints.getProducts();
      var data = await product.toJsonWithoutId(
        openingquantity: openingquantity,
        branch: branch,
      );
      var response = await api.post(
        url: url,
        data: data,
      );
      if (response.status) {
        AddOrUpdateProduct addOrUpdateProduct =
            AddOrUpdateProduct.fromJson(response.data);
        if (addOrUpdateProduct.status ?? false) {
          ProductModel product =
              ProductModel.copyWith(unit, addOrUpdateProduct.product!);
          return Right(product);
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
      return Left(
        ApiResponse.unKnownError(),
      );
    }
  }

  Future<Either<ApiResponse, int>> deleteProduct({
    required ProductModel product,
  }) async {
    try {
      String url = await ApiEndPoints.getProducts();
      var response = await api.delete(
        url: "$url/${product.id}",
      );
      if (response.status) {
        return Right(product.id!);
      } else {
        return Left(
          response,
        );
      }
    } catch (e) {
      debugPrint(e.toString());
      return Left(
        ApiResponse.unKnownError(),
      );
    }
  }

  Future<Either<ApiResponse, ProductModel>> editProduct({
    required String openingquantity,
    required BrancheModel? branch,
    required ProductModel product,
    required UnitModel unit,
  }) async {
    try {
      String url = await ApiEndPoints.getProducts();

      var data = await product.toJsonWithoutId(
        openingquantity: openingquantity,
        branch: branch,
      );
      // print(
      //   "\n ****************** product data : $data ****************** ]n",
      // );
      var response = await api.post(
        url: "$url/${product.id}",
        data: data,
      );
      if (response.status) {
        AddOrUpdateProduct addOrUpdateProduct =
            AddOrUpdateProduct.fromJson(response.data);
        if (addOrUpdateProduct.status ?? false) {
          ProductModel product =
              ProductModel.copyWith(unit, addOrUpdateProduct.product!);
          return Right(product);
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
      return Left(
        ApiResponse.unKnownError(),
      );
    }
  }

  Future<Either<ApiResponse, List<ProductModel>>> searchProducts({
    required String query,
    bool isfresh = false,
  }) async {
    try {
      ApiResponse apiResponse;
      String url;
      if (searchProductsModel == null || isfresh) {
        url = await ApiEndPoints.getProducts();
        apiResponse = await api.get(
          url: url,
          queryParameters: {ApiKeys.search: query},
        );
      } else {
        if (searchProductsModel?.data?.nextPageUrl == null) {
          return Right([]);
        } else {
          url = searchProductsModel!.data!.nextPageUrl!;
          apiResponse = await api.get(
            url: url,
          );
        }
      }

      if (apiResponse.status) {
        searchProductsModel = GetProductsModel.fromJson(apiResponse.data);
        return Right(searchProductsModel!.data!.data!);
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
    searchProductsModel = null;
  }

  void reset() {
    searchProductsModel = null;
    getProductsModel = null;
  }
}
