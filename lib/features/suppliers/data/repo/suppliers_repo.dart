import 'package:flutter/material.dart';
import 'package:pos_app/core/api/api_helper.dart';
import 'package:pos_app/core/api/api_keys.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/features/suppliers/data/models/add_or_update_supplier_model.dart';
import 'package:pos_app/features/suppliers/data/models/get_supplier_model.dart';

import '../models/supplier_model.dart';
import 'package:dartz/dartz.dart';

class SuppliersRepo {
  final ApiHelper api;
  SuppliersRepo({required this.api});
  GetSuppliersModel? getSuppliersModel;
  Future<Either<ApiResponse, List<SupplierModel>>> getSuppliers(
      {isRefresh = false}) async {
    try {
      String url = '';
      if (getSuppliersModel == null || isRefresh) {
        url = await ApiEndPoints.getSuppliers();
      } else {
        if (getSuppliersModel!.nextPageUrl == null) {
          return Right([]);
        } else {
          url = getSuppliersModel!.nextPageUrl!;
        }
      }

      // ignore: use_build_context_synchronously
      var response = await api.get(
        url: url,
      );
      if (response.status) {
        getSuppliersModel = GetSuppliersModel.fromJson(response.data);
        return Right(getSuppliersModel!.data!);
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

  Future<Either<ApiResponse, SupplierModel>> addSupplier({
    required SupplierModel supplier,
  }) async {
    try {
      String url = await ApiEndPoints.getSuppliers();
      var response = await api.post(
        url: url,
        data: supplier.toJsonWithoutId(),
      );
      if (response.status) {
        AddOrUpdateSupplierModel addOrUpdateSupplierModel =
            AddOrUpdateSupplierModel.fromJson(response.data!);
        if (addOrUpdateSupplierModel.status ?? false) {
          return Right(addOrUpdateSupplierModel.supplier!);
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

  Future<Either<ApiResponse, SupplierModel>> editSupplier({
    required SupplierModel supplier,
  }) async {
    try {
      String url = await ApiEndPoints.getSuppliers();
      var response = await api.post(
        url: "$url/${supplier.id}",
        data: supplier.toJsonWithoutId(),
      );
      if (response.status) {
        AddOrUpdateSupplierModel addOrUpdateSupplierModel =
            AddOrUpdateSupplierModel.fromJson(response.data!);
        if (addOrUpdateSupplierModel.status ?? false) {
          return Right(addOrUpdateSupplierModel.supplier!);
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

  Future<Either<ApiResponse, int>> deleteSupplier({
    required SupplierModel supplier,
  }) async {
    try {
      String url = await ApiEndPoints.getSuppliers();
      var response =
          // ignore: use_build_context_synchronously
          await api.delete(
        url: "$url/${supplier.id}",
      );
      if (response.status) {
        return Right(supplier.id!);
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

  void reset() {
    getSuppliersModel = null;
  }
}
