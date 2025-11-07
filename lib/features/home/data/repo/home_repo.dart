import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:pos_app/core/api/api_helper.dart';
import 'package:pos_app/core/api/api_keys.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/core/cache/custom_user_hive_box.dart';
import 'package:pos_app/core/helper/my_service_locator.dart';
import 'package:pos_app/features/auth/login/data/model/user_model.dart';
import 'package:pos_app/features/home/data/model/get_single_user_model.dart';
import 'package:pos_app/features/home/data/model/getshift.dart';
import 'package:pos_app/features/home/data/model/shifts_model.dart';

class HomeRepo {
  final ApiHelper api;

  HomeRepo({required this.api});

  Future<Either<ApiResponse, void>> getUsers() async {
    try {
      ApiResponse? response;
      String url = await ApiEndPoints.getUsers();
      int userId = CustomUserHiveBox.getUser().id!;
      url = "$url/$userId";
      // ignore: use_build_context_synchronously
      response = await api.get(
        url: url,
      );
      if (response.status) {
        GetSingleUserModel getUserModel =
            GetSingleUserModel.fromJson(response.data);
        await saveUser(user: getUserModel.user!);
        return Right(null);
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

  Future<Either<ApiResponse, void>> startShift({required int branchId, required double cash}) async {
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
        return Right(unit);
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

  Future<void> saveUser({required UserModel user}) async {
    await CustomUserHiveBox.setUser(user);
  }

  Future<Either<ApiResponse, void>> endShift({required int branchId}) async {
    try {
      ApiResponse? response;
      String url = await ApiEndPoints.endShift();
      response = await api.post(
        url: url,
        data: {
        "branch_id": branchId,
        }
      );
      if (response.status) {
        return Right(unit);
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

Future<Either<ApiResponse, List<ShiftData>>> getShifts({bool isFresh = false}) async {
  try {
    String url;

    int userId = CustomUserHiveBox.getUser().id!;
    if (shiftsModel == null || isFresh) {
      url = await ApiEndPoints.getShifts(userId: userId);
      shiftsModel = null;
    } 
    else {
      if (shiftsModel!.data!.nextPageUrl == null) {
        return const Right([]); 
      }
      url = shiftsModel!.data!.nextPageUrl!;
    }

    final response = await api.get(url: url);

    if (response.status) {
      final newModel = ShiftsModel.fromJson(response.data);

      if (shiftsModel == null || isFresh) {
        shiftsModel = newModel;
      } else {
        shiftsModel!.data!.data!.addAll(newModel.data!.data!);
        shiftsModel!.data!.nextPageUrl = newModel.data!.nextPageUrl;
      }

      return Right(shiftsModel!.data!.data ?? []);
    } else {
      return Left(response);
    }
  } catch (e) {
    debugPrint(e.toString());
    return Left(ApiResponse.unKnownError());
  }
}
Future<Either<ApiResponse, GetShift>> getShiftDetails(int shiftId) async {
  try {
    String url = await ApiEndPoints.getShiftDetails(shiftId: shiftId,);

    final response = await api.get(url: url);

    if (response.status) {
      final model = GetShift.fromJson(response.data);
      return Right(model);
    } else {
      return Left(response);
    }
  } catch (e) {
    debugPrint(e.toString());
    return Left(ApiResponse.unKnownError());
  }
}



}
