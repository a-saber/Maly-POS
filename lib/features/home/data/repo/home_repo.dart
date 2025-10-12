import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:pos_app/core/api/api_helper.dart';
import 'package:pos_app/core/api/api_keys.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/core/cache/custom_user_hive_box.dart';
import 'package:pos_app/features/auth/login/data/model/user_model.dart';
import 'package:pos_app/features/home/data/model/get_single_user_model.dart';

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
}

Future<void> saveUser({required UserModel user}) async {
  await CustomUserHiveBox.setUser(user);
}
