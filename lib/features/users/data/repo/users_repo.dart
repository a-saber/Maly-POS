import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:pos_app/core/api/api_helper.dart';
import 'package:pos_app/core/api/api_keys.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/features/auth/login/data/model/user_model.dart';
import 'package:pos_app/features/users/data/model/add_or_update_user_response_model.dart';
import 'package:pos_app/features/users/data/model/get_user_model.dart';

class UsersRepo {
  final ApiHelper api;
  GetUserModel? getUserModel;
  GetUserModel? getSearchUserModel;
  UsersRepo({required this.api});

  Future<Either<ApiResponse, List<UserModel>>> getUsers({
    bool isRefresh = false,
  }) async {
    try {
      ApiResponse? response;
      if (getUserModel == null || isRefresh) {
        String url = await ApiEndPoints.getUsers();
        // ignore: use_build_context_synchronously
        response = await api.get(
          url: url,
        );
      } else {
        if (getUserModel!.nextPageUrl == null) {
          return Right([]);
        } else {
          String url = getUserModel!.nextPageUrl!;
          debugPrint("url $url");
          // ignore: use_build_context_synchronously
          response = await api.get(
            url: url,
          );
        }
      }

      if (response.status) {
        getUserModel = GetUserModel.fromJson(response.data);
        return Right(getUserModel!.data!);
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

  Future<Either<ApiResponse, UserModel>> addUser({
    required UserModel userModel,
    required String password,
    required File? image,
  }) async {
    try {
      String url = await ApiEndPoints.getUsers();
      var data = await userModel.jsonWithoutId(
        password: password,
        image: image,
      );
      var response = await api.post(
        url: url,
        data: data,
      );

      if (response.status) {
        AddOrUpdateUserResponseModel addOrUpdateUserResponseModel =
            AddOrUpdateUserResponseModel.fromJson(response.data);
        if (addOrUpdateUserResponseModel.status ?? false) {
          return Right(addOrUpdateUserResponseModel.user!);
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

  Future<Either<ApiResponse, UserModel>> editUser({
    required UserModel userModel,
    required String password,
    required File? image,
    required int id,
  }) async {
    try {
      String url = await ApiEndPoints.getUsers();
      var data = await userModel.jsonWithoutId(
        password: password,
        image: image,
      );

      data.forEach((k, v) => debugPrint("$k : $v"));
      var response = await api.post(
        url: "$url/$id",
        data: data,
      );

      if (response.status) {
        AddOrUpdateUserResponseModel addOrUpdateUserResponseModel =
            AddOrUpdateUserResponseModel.fromJson(response.data);
        if (addOrUpdateUserResponseModel.status ?? false) {
          return Right(addOrUpdateUserResponseModel.user!);
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

  Future<Either<ApiResponse, int>> removeUser({required int id}) async {
    try {
      String url = await ApiEndPoints.getUsers();
      // ignore: use_build_context_synchronously
      var response = await api.delete(
        url: "$url/$id",
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

  Future<Either<ApiResponse, List<UserModel>>> searchUser(
      {required String query, bool isRefresh = false}) async {
    try {
      ApiResponse apiResponse;
      String url;
      if (getSearchUserModel == null || isRefresh) {
        url = await ApiEndPoints.getUsers();
        apiResponse = await api.get(
          url: url,
          queryParameters: {
            ApiKeys.search: query,
          },
        );
      } else {
        if (getSearchUserModel?.nextPageUrl == null) {
          return Right([]);
        } else {
          url = getSearchUserModel!.nextPageUrl!;
          apiResponse = await api.get(
            url: url,
          );
        }
      }
      if (apiResponse.status) {
        getSearchUserModel = GetUserModel.fromJson(apiResponse.data!);
        return Right(getSearchUserModel!.data!);
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
    getSearchUserModel = null;
  }

  void reset() {
    getUserModel = null;
    getSearchUserModel = null;
  }
}
