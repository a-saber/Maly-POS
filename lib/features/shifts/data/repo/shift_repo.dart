import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:pos_app/core/api/api_helper.dart';
import 'package:pos_app/core/api/api_keys.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/features/shifts/data/model/end_shift_model.dart';
import 'package:pos_app/features/shifts/data/model/getshift.dart';
import 'package:pos_app/features/shifts/data/model/shifts_model.dart';

class ShiftRepo {
  ShiftRepo({required this.api});
  final ApiHelper api;

  Future<Either<ApiResponse, void>> startShift(
      {required int branchId, required double cash}) async {
    try {
      ApiResponse? response;
      String url = await ApiEndPoints.startShift();
      response = await api.post(
        url: url,
        data: {
          "branch_id": branchId,
          "opening_quantity": cash,
        },
      );
      if (response.status) {
        return Right(null);
      } else {
        return Left(
          response,
        );
      }
    } catch (e) {
      debugPrint(e.toString());
      return Left(ApiResponse.unKnownError());
    }
  }

  Future<Either<ApiResponse, EndShiftModel>> endShift(
      {required int branchId}) async {
    try {
      ApiResponse? response;
      String url = await ApiEndPoints.endShift();
      response = await api.post(url: url, data: {
        "branch_id": branchId,
      });
      if (response.status) {
        return Right(EndShiftModel.fromJson(response.data));
      } else {
        return Left(
          response,
        );
      }
    } catch (e) {
      debugPrint(e.toString());
      return Left(ApiResponse.unKnownError());
    }
  }

  ShiftsModel? shiftsModel;

  Future<Either<ApiResponse, List<ShiftData>>> getShifts(
      {bool isFresh = false}) async {
    try {
      String url;

      if (shiftsModel == null || isFresh) {
        url = await ApiEndPoints.getShifts(
            // userId: CustomUserHiveBox.getUser().id!,
            );
        shiftsModel = null;
      } else {
        if (shiftsModel!.data!.nextPageUrl == null) {
          return const Right([]);
        }
        url = shiftsModel!.data!.nextPageUrl!;
      }

      final response = await api.get(url: url);

      if (response.status) {
        print("***-* Shift Response Data: ${response.data}");
        final newModel = ShiftsModel.fromJson(response.data);

        if (shiftsModel == null || isFresh) {
          print("***-* Shift Model Data: ${newModel.data!.data}");
          shiftsModel = newModel;
          return Right(shiftsModel!.data!.data!);
        } else {
          print("***-* Shift Model Data: ${newModel.data!.data}");
          shiftsModel!.data!.data!.addAll(newModel.data!.data!);
          shiftsModel!.data!.nextPageUrl = newModel.data!.nextPageUrl;
          return Right(shiftsModel!.data!.data!);
        }
      }

      return Left(response);
    } catch (_) {
      print("***-*-*- Error Shift Repo: $_");
      return Left(ApiResponse.unKnownError());
    }
  }

  GetShift? getShift;

  Future<Either<ApiResponse, GetShift>> getShiftDetails(int shiftId,
      {bool isFresh = false}) async {
    try {
      String url;
      String urlGetShift = await ApiEndPoints.getShifts();
      url = "$urlGetShift/$shiftId";

      var response = await api.get(url: url);
      if (response.status) {
        return Right(GetShift.fromJson(response.data));
      } else {
        return Left(response);
      }

      // if (getShift == null || isFresh) {
      //   url = await ApiEndPoints.getShiftDetails(shiftId: shiftId);
      //   getShift = null;
      // } else {
      //   if (getShift?.data?.nextPageUrl == null) {
      //     return Right(getShift!);
      //   }
      //   url = getShift!.data!.nextPageUrl!.toString();
      // }

      // final response = await api.get(url: url);

      // if (response.status) {
      //   final model = GetShift.fromJson(response.data);

      //   if (isFresh || getShift == null) {
      //     getShift = model;
      //   } else {
      //     final existingOrders = getShift!.data?.data ?? [];
      //     final newOrders = model.data?.data ?? [];
      //     getShift!.data?.data = [...existingOrders, ...newOrders];
      //     getShift!.data?.nextPageUrl = model.data?.nextPageUrl;
      //   }

      //   return Right(getShift!);
      // } else {
      //   return Left(response);
      // }
    } catch (e) {
      debugPrint(e.toString());
      return Left(ApiResponse.unKnownError());
    }
  }

  Future<Either<ApiResponse, Dataforshift>> getOrderPagination({
    required String url,
  }) async {
    try {
      var response = await api.get(url: url);
      GetShift model = GetShift.fromJson(response.data);
      if (response.status) {
        return Right(model.data!);
      } else {
        return Left(response);
      }
    } catch (e) {
      debugPrint(e.toString());
      return Left(ApiResponse.unKnownError());
    }
  }
}
