import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:pos_app/core/api/api_helper.dart';
import 'package:pos_app/core/api/api_keys.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/features/auth/login/data/model/branche_model.dart';
import 'package:pos_app/features/products/data/model/add_or_update_product_model.dart';
import 'package:pos_app/features/products/data/model/get_products_model.dart';
import 'package:pos_app/features/products/data/model/product_model.dart';
import 'package:pos_app/features/products/data/model/update_product_model.dart';
import 'package:pos_app/features/units/data/model/unit_model.dart';

import '../../../units/data/model/get_unit_model.dart';
import '../model/product_saving_data_model.dart';

class ProductsRepo {
  final ApiHelper api;
  GetProductsModel? getProductsModel;
  GetProductsModel? searchProductsModel;
  GetUnitModel? getUnitModel;
  ProductSavingDataModel? productSavingDataModel;

  ProductsRepo({required this.api});

  Future<Either<ApiResponse, List<ProductModel>>> getProducts({
    bool isfresh = false,
     String query='',
    int? categoryId,

  }) async {
    try {
      String? url;
      if(query.isEmpty&&categoryId==null){
      if (getProductsModel == null || isfresh) {
        productSavingDataModel=null;

        url = await ApiEndPoints.getProducts();
      } else {
        if (getProductsModel!.data?.nextPageUrl == null ) {
          return Right([]);
        }
        else {
          url = getProductsModel!.data!.nextPageUrl!;
        }
      }
      var response = await api.get(
        url: url,
        queryParameters: {'with_category': '1'},
      );
      if (response.status) {
        getProductsModel = GetProductsModel.fromJson(response.data);
        return Right(getProductsModel!.data!.data!);
      } else {
        return Left(
          response,
        );
      }
      }
      else{

        if (productSavingDataModel?.getProductsSearchModel==null ||
            productSavingDataModel?.query!=query||
            (categoryId!=null && productSavingDataModel?.id!=categoryId)||(categoryId==null&&query.isNotEmpty)
        ) {
          url = await ApiEndPoints.getProducts();
        } else {
          if (productSavingDataModel!.getProductsSearchModel!.data?.nextPageUrl == null) {
            return Right([]);
          } else {
            url = productSavingDataModel!.getProductsSearchModel!.data!.nextPageUrl!;
          }
        }
        var response = await api.get(
          url: url,

          queryParameters: {
          if(  categoryId==null)  'with_category': '1',
           ApiKeys.search: query,
            if(categoryId!=null) 'category_id':categoryId,
          },
        );
        if (response.status) {
          productSavingDataModel =  ProductSavingDataModel(
             getProductsSearchModel:  GetProductsModel.fromJson(response.data),
            id: categoryId,
            query: query

          );
          return Right(productSavingDataModel!.getProductsSearchModel!.data!.data!);
        } else {
          return Left(
            response,
          );
        }

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
        return Right(ProductModel.copyWith(unit, addOrUpdateProduct.product!));
      }
      else {
        return Left(
          response,
        );
      }
  }
   else {
        return Left(response);
      }

    } catch (e) {
      debugPrint(e.toString());
      return Left(
        ApiResponse.unKnownError(),
      );
    }
  }

  Future<Either<ApiResponse, ProductModel?>> addUpdateProduct({
    required UpdateProductModel updateProduct,
    bool isUpdate = false,
  }) async {
    // try {

    for (int i = 0; i < updateProduct.productUnits!.length; i++) {
      updateProduct.productUnits![i].unitId =
          updateProduct.productUnits![i].unit!.id;
      updateProduct.productUnits![i].costPrice =
          updateProduct.productUnits![i].costPriceController!.text;
      updateProduct.productUnits![i].conversionFactor =
          updateProduct.productUnits![i].factoryController!.text;
      debugPrint(
          " \n ******* conversionFactor : ${updateProduct.productUnits![i].conversionFactor} *************** \n");
      debugPrint(
          " \n ******* salePriceWithoutTax $i : ${updateProduct.productUnits![i].salePriceWithoutTax} *************** \n");
      debugPrint(
          " \n ******* salePriceWithTax $i : ${updateProduct.productUnits![i].salePriceWithTax} *************** \n");
      debugPrint(
          " \n ******* minPriceWithTax $i : ${updateProduct.productUnits![i].minPriceWithTax} *************** \n");
      debugPrint(
          " \n ******* minPriceWithoutTax $i : ${updateProduct.productUnits![i].minPriceWithoutTax} *************** \n");
      updateProduct.productUnits![i].barcode =
          updateProduct.productUnits![i].barCodeController!.text;
      updateProduct.productUnits![i].scaleBarcode =
          updateProduct.productUnits![i].scaleBarcodeController!.text;
      updateProduct.productUnits![i].minPriceWithoutTax =
          updateProduct.productUnits![i].minPriceWithoutTax;
      updateProduct.productUnits![i].salePriceWithTax = updateProduct.productUnits![i].salePriceWithTax;
     // updateProduct.productUnits![i].salePriceWithoutTax = updateProduct.productUnits![i].salePriceWithoutTaxController!.text;
    }
    String url = await ApiEndPoints.getProducts();

    debugPrint(
        " 12-----------------------------------\n\n ${updateProduct.toJson()}\n\n-----------------------------------\n\n12");
    var data = await updateProduct.updateProduct();
    var response = await api.post(
       
        url:isUpdate? "$url/${updateProduct.id}":url,
        data: data,
        isFormData: true);
    if (response.status) {
      AddOrUpdateProduct addOrUpdateProduct =
          AddOrUpdateProduct.fromJson(response.data);
      if (addOrUpdateProduct.status ?? false) {
        return Right(addOrUpdateProduct.product);
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
    // }
    // catch (e) {
    //   debugPrint(e.toString());
    //   return Left(
    //     ApiResponse.unKnownError(),
    //   );
    // }
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

        print(
          "\n ****************** product data : $data ****************** ]n",
        );
      var response = await api.post(
        url: "$url/${product.id}",
        data: data,
        isFormData: true,
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
          queryParameters: {ApiKeys.search: query, 'with_category': '1'},
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
