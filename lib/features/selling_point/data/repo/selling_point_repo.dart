import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:pos_app/core/api/api_helper.dart';
import 'package:pos_app/core/api/api_keys.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/core/helper/payment_helper.dart';
import 'package:pos_app/features/auth/login/data/model/branche_model.dart';
import 'package:pos_app/features/clients/data/model/customer_model.dart';
import 'package:pos_app/features/discounts/data/model/discount_model.dart';
import 'package:pos_app/features/products/data/model/get_products_model.dart';
import 'package:pos_app/features/products/data/model/product_model.dart';
import 'package:pos_app/features/selling_point/data/model/category_saving_data_model.dart';
import 'package:pos_app/features/selling_point/data/model/payment_method_model.dart';
import 'package:pos_app/features/selling_point/data/model/print_model.dart';
import 'package:pos_app/features/selling_point/data/model/product_selling_model.dart';
import 'package:pos_app/features/selling_point/data/model/type_of_take_order_model.dart';

class SellingPointRepo {
  final ApiHelper api;

  BrancheModel? branch;

  SellingPointRepo({required this.api});
Future<Either<ApiResponse, PrintModel>> newSales({
  required double subtotal,
  required double discounttotal,
  required double totalafterdiscount,
  required double taxtotal,
  required double totalaftertax,
  required PaymentMethodModel? paymentType,
  required TypeOfTakeOrderModel? typeOfTakeOrder,
  required DiscountModel? discount,
  required CustomerModel? customer,
  required List<ProductSellingModel> products,
  required double paid,
  required double online,
  required double madaAmount,
  required double onlineAmount,
 
  Map<int, double>? paymentAmounts,
  Map<int, String>? paymentReferences,
}) async {
  String? payResponseId;
  try {
    String url = await ApiEndPoints.getSales();

 
    double rest = 0.0;
    if (paymentAmounts != null && paymentAmounts.length == 1) {

      double totalPaid = paymentAmounts.values.first;
      if (totalPaid > totalaftertax) {
        rest = totalPaid - totalaftertax;
      }
    }

   
    List<Map<String, dynamic>> paymentsArray = [];
    if (paymentAmounts != null && paymentAmounts.isNotEmpty) {
      for (var entry in paymentAmounts.entries) {
        Map<String, dynamic> paymentItem = {
          'payment_method_id': entry.key,
          'amount': entry.value,
        };
        
    
        if (paymentReferences != null && paymentReferences.containsKey(entry.key)) {
          paymentItem['reference'] = paymentReferences[entry.key];
        }
        
        paymentsArray.add(paymentItem);
      }
    }

    Map<String, dynamic> data = {
      ApiKeys.subtotal: subtotal,
      ApiKeys.discounttotal: discounttotal,
      ApiKeys.totalafterdiscount: totalafterdiscount,
      ApiKeys.taxtotal: taxtotal,
      ApiKeys.totalaftertax: totalaftertax,
      
 
      'paid': paid,
      'rest': rest,
      'payments': paymentsArray,
      
      ApiKeys.paymentmethod: paymentType?.apiKey,
      ApiKeys.branchid: branch?.id,
      ApiKeys.ordertype: typeOfTakeOrder?.apiKey,
      ApiKeys.products: products.map((e) => e.toJson()).toList(),
    };
    
    if (discount != null) {
      data[ApiKeys.discountid] = discount.id;
    }
    if (customer != null) {
      data[ApiKeys.customerid] = customer.id;
    }
    
    Uint8List? madaReceipt;
    if (paymentType?.apiKey == ApiKeys.mada) {
      print('MADA 01 ****** ');
      var madaResponse = await PaymentHelper.addTransaction(amount: totalaftertax);
      print('MADA 02 ****** success');
      madaResponse.fold((error) {
        print('NearPayException Error 666: $error');
        throw NearPayException(error);
      }, (madaResponse) async {
        print('MADA 03 ****** success');
        payResponseId = madaResponse.transaction_uuid;
        data["nearpay_transaction_uuid"] = madaResponse.transaction_uuid;
        madaReceipt = await PaymentHelper.toImage(receipt: madaResponse);
      });
    }
    
    var response = await api.post(
      url: url,
      data: data,
      isFormData: false,
    );
    
    if (response.status) {
      return Right(PrintModel(
        apiResponse: response,
        branchName: branch?.name ?? 'مش معروف',
        paid: paid,
        madaReceipt: madaReceipt
      ));
    } else {
      if (payResponseId != null) {
        await PaymentHelper.reverseTransaction(
          originalTransactionUUID: payResponseId!
        );
      }
      return Left(response);
    }
  } on NearPayException catch (e) {
    print('MADA 04 ****** NearPayException');
    return Left(ApiResponse.fromErrorMSG(e.message));
  } catch (e) {
    if (payResponseId != null) {
      await PaymentHelper.reverseTransaction(
        originalTransactionUUID: payResponseId!
      );
    }
    debugPrint(e.toString());
    return Left(ApiResponse.unKnownError());
  }
}
  List<CategorySavingDataModel> categorySavingDataModels = [];
  int currentIndex({
    required int? categoryId,
  }) =>
      categorySavingDataModels.indexWhere(
        (element) => element.id == categoryId,
      );

  Future<Either<ApiResponse, List<CategorySavingDataModel>>> getData(
      {required int categortyId,
      bool refreshAllData = false,
      String search = '',
      bool refreshCurrentCategory = false,
      int perpage = 10,
      bool fromHome = false}) async {
    try {
      if (refreshAllData) {
        categorySavingDataModels.clear();
      }
      int index = currentIndex(categoryId: categortyId);

      if (index == -1) {
        String url = await ApiEndPoints.getProducts();
        final response = await api.get(
          url: url,
          queryParameters: {
            ApiKeys.search: search,
            if (categortyId > 0) ApiKeys.categoryId: categortyId,
            ApiKeys.branchid: branch?.id,
            ApiKeys.perPage: perpage,
          },
        );

        if (response.status) {
          GetProductsModel getProductsModel =
              GetProductsModel.fromJson(response.data);
          if (search.isEmpty) {
            categorySavingDataModels.add(
              CategorySavingDataModel(
                id: categortyId,
                getProductsModel: getProductsModel,
                products: getProductsModel.data?.data,
              ),
            );
          } else {
            categorySavingDataModels.add(
              CategorySavingDataModel(
                id: categortyId,
                getProductsSearchModel: getProductsModel,
                searchProduct: getProductsModel.data?.data,
                query: search,
              ),
            );
          }
          return Right(categorySavingDataModels);
        } else {
          return Left(response);
        }
      } else {
        if (search.isEmpty) {
          if (categorySavingDataModels[index].getProductsModel == null ||
              refreshCurrentCategory) {
            String url = await ApiEndPoints.getProducts();
            final response = await api.get(
              url: url,
              queryParameters: {
                ApiKeys.search: search,
                if (categortyId > 0) ApiKeys.categoryId: categortyId,
                ApiKeys.branchid: branch?.id,
                ApiKeys.perPage: perpage,
              },
            );
            if (response.status) {
              GetProductsModel getProductsModel =
                  GetProductsModel.fromJson(response.data);
              categorySavingDataModels[index].products =
                  List.from(getProductsModel.data?.data ?? []);
              categorySavingDataModels[index].getProductsModel =
                  getProductsModel;
              return Right(categorySavingDataModels);
            } else {
              return Left(response);
            }
          }
          if (categorySavingDataModels[index]
                  .getProductsModel
                  ?.data
                  ?.nextPageUrl ==
              null) {
            return Right(categorySavingDataModels);
          } else {
            var response = await api.get(
                url: categorySavingDataModels[index]
                        .getProductsModel
                        ?.data
                        ?.nextPageUrl ??
                    '');
            if (response.status) {
              GetProductsModel getProductsModel =
                  GetProductsModel.fromJson(response.data);

              categorySavingDataModels[index]
                  .products
                  ?.addAll(getProductsModel.data?.data ?? []);
              categorySavingDataModels[index].getProductsModel =
                  getProductsModel;
              return Right(categorySavingDataModels);
            } else {
              return Left(response);
            }
          }
        } else {
          if (search != categorySavingDataModels[index].query ||
              categorySavingDataModels[index].getProductsSearchModel == null) {
            String url = await ApiEndPoints.getProducts();
            final response = await api.get(
              url: url,
              queryParameters: {
                ApiKeys.search: search,
                if (categortyId != -1) ApiKeys.categoryId: categortyId,
                ApiKeys.branchid: branch?.id,
                ApiKeys.perPage: perpage,
              },
            );
            if (response.status) {
              GetProductsModel getProductsModel =
                  GetProductsModel.fromJson(response.data);
              categorySavingDataModels[index].query = search;
              categorySavingDataModels[index].searchProduct =
                  List.from(getProductsModel.data?.data ?? []);

              categorySavingDataModels[index].getProductsSearchModel =
                  getProductsModel;
              return Right(categorySavingDataModels);
            } else {
              return Left(response);
            }
          }
          if (categorySavingDataModels[index]
                  .getProductsSearchModel
                  ?.data
                  ?.nextPageUrl ==
              null) {
            return Right(categorySavingDataModels);
          } else {
            var response = await api.get(
                url: categorySavingDataModels[index]
                        .getProductsSearchModel
                        ?.data
                        ?.nextPageUrl ??
                    '');
            if (response.status) {
              GetProductsModel getProductsModel =
                  GetProductsModel.fromJson(response.data);

              categorySavingDataModels[index]
                  .searchProduct
                  ?.addAll(getProductsModel.data?.data ?? []);
              categorySavingDataModels[index].getProductsSearchModel =
                  getProductsModel;
              return Right(categorySavingDataModels);
            } else {
              return Left(response);
            }
          }
        }
      }
    } catch (e) {
      debugPrint(e.toString());
      return Left(ApiResponse.unKnownError());
    }
  }

  bool addProductToAllAndSpecificCategory({
    required ProductModel product,
  }) {
    bool add = false;
    int index = currentIndex(categoryId: product.categoryId);
    if (index != -1) {
      if (categorySavingDataModels[index].getProductsModel?.data?.nextPageUrl ==
          null) {
        categorySavingDataModels[index].products?.add(product);
        add = true;
      }
    }
    index = currentIndex(categoryId: -1);
    if (index != -1) {
      if (categorySavingDataModels[index].getProductsModel?.data?.nextPageUrl ==
          null) {
        categorySavingDataModels[index].products?.add(product);
        add = true;
      }
    }
    return add;
  }

  bool updateProductToAllAndSpecificCategory({
    required ProductModel product,
    required int? oldCayegoryId,
  }) {
    bool update = false;
    int index = currentIndex(categoryId: oldCayegoryId);
    if (index != -1 && oldCayegoryId != product.categoryId) {
      categorySavingDataModels[index]
          .products
          ?.removeWhere((element) => element.id == product.id);
    }

    index = currentIndex(categoryId: product.categoryId);
    if (index != -1) {
      int i = categorySavingDataModels[index]
              .products
              ?.indexWhere((element) => element.id == product.id) ??
          -1;
      if (i != -1) {
        categorySavingDataModels[index].products?[i] = product;
      }
      update = true;
    }

    index = currentIndex(categoryId: -1);
    if (index != -1) {
      int i = categorySavingDataModels[index]
              .products
              ?.indexWhere((element) => element.id == product.id) ??
          -1;
      if (i != -1) {
        categorySavingDataModels[index].products?[i] = product;
      }
      update = true;
    }
    return update;
  }

  bool deleteProductToAllAndSpecificCategory({
    required ProductModel product,
  }) {
    int index = currentIndex(categoryId: product.categoryId);
    if (index != -1) {
      categorySavingDataModels[index]
          .products
          ?.removeWhere((element) => element.id == product.id);
    }
    index = currentIndex(categoryId: -1);
    if (index != -1) {
      categorySavingDataModels[index]
          .products
          ?.removeWhere((element) => element.id == product.id);
    }
    return true;
  }

  void resetModel() {
    categorySavingDataModels = [];
    branch = null;
  }
}
