import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:pos_app/core/api/api_helper.dart';
import 'package:pos_app/core/api/api_keys.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/features/clients/data/model/add_or_update_customer_response_model.dart';
import 'package:pos_app/features/clients/data/model/customer_model.dart';
import 'package:pos_app/features/clients/data/model/get_customer_model.dart';

class ClientsRepo {
  final ApiHelper api;

  GetCustomerModel? getCustomerModel;
  GetCustomerModel? getCustomerSearchModel;

  ClientsRepo({required this.api});

  Future<Either<ApiResponse, List<CustomerModel>>> getClients(
      {isRefresh = false}) async {
    try {
      String? url;
      if (getCustomerModel == null || isRefresh) {
        url = await ApiEndPoints.getCustomers();
      } else {
        if (getCustomerModel!.nextPageUrl == null) {
          return Right([]);
        } else {
          url = getCustomerModel!.nextPageUrl;
        }
      }

      var response =
          // ignore: use_build_context_synchronously
          await api.get(
        url: url!,
      );

      if (response.status) {
        getCustomerModel = GetCustomerModel.fromJson(response.data);
        return Right(getCustomerModel!.data!);
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

  Future<Either<ApiResponse, CustomerModel>> addClient({
    required CustomerModel client,
  }) async {
    try {
      String url = await ApiEndPoints.getCustomers();
      // ignore: use_build_context_synchronously
      var response = await api.post(
        url: url,
        data: client.toJsonWithoutId(),
      );

      if (response.status) {
        AddOrUpdateCustomerResponseModel addOrUpdateCustomerResponseModel =
            AddOrUpdateCustomerResponseModel.fromJson(response.data!);
        if (addOrUpdateCustomerResponseModel.status ?? false) {
          return Right(addOrUpdateCustomerResponseModel.customer!);
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

  Future<Either<ApiResponse, CustomerModel>> editClient({
    required CustomerModel client,
  }) async {
    try {
      var url = await ApiEndPoints.getCustomers();
      var response = await api.post(
        url: "$url/${client.id}",
        data: client.toJsonWithoutId(),
      );

      if (response.status) {
        AddOrUpdateCustomerResponseModel addOrUpdateCustomerResponseModel =
            AddOrUpdateCustomerResponseModel.fromJson(response.data!);
        if (addOrUpdateCustomerResponseModel.status ?? false) {
          return Right(addOrUpdateCustomerResponseModel.customer!);
        } else {
          return Left(response);
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

  Future<Either<ApiResponse, int>> deleteClient({
    required int id,
  }) async {
    try {
      String url = await ApiEndPoints.getCustomers();
      // ignore: use_build_context_synchronously
      var response = await api.delete(
        url: '$url/$id',
      );

      if (response.status) {
        return Right(id);
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

  Future<Either<ApiResponse, List<CustomerModel>>> searchCustomers({
    required String query,
    bool refresh = false,
  }) async {
    try {
      ApiResponse apiResponse;
      String url;
      if (getCustomerSearchModel == null || refresh) {
        url = await ApiEndPoints.getCustomers();
        apiResponse = await api.get(
          url: url,
          queryParameters: {
            ApiKeys.search: query,
          },
        );
      } else {
        if (getCustomerSearchModel?.nextPageUrl == null) {
          return Right([]);
        } else {
          url = getCustomerSearchModel!.nextPageUrl!;
          apiResponse = await api.get(
            url: url,
          );
        }
      }

      if (apiResponse.status) {
        getCustomerSearchModel = GetCustomerModel.fromJson(apiResponse.data!);
        return Right(getCustomerSearchModel!.data!);
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
    getCustomerSearchModel = null;
  }

  void resetGetCustomers() {
    getCustomerSearchModel = null;
    getCustomerModel = null;
  }
}
