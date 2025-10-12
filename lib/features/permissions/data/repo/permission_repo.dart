import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:pos_app/core/api/api_helper.dart';
import 'package:pos_app/core/api/api_keys.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/features/auth/login/data/model/role_model.dart';
import 'package:pos_app/features/permissions/data/model/add_permission_response_model.dart';
import 'package:pos_app/features/permissions/data/model/get_role_mode.dart';

class PermissionsRepo {
  final ApiHelper api;
  GetRoleModel? getRoleModel;
  GetRoleModel? getRoleSearchModel;

  PermissionsRepo({required this.api});

  Future<Either<ApiResponse, RoleModel>> addPermission({
    required RoleModel permission,
  }) async {
    try {
      debugPrint(permission.toJsonWithoutId().toString());
      String url = await ApiEndPoints.getRoles();
      // ignore: use_build_context_synchronously
      var response = await api.post(
        // ignore: use_build_context_synchronously
        url: url,
        data: permission.toJsonWithoutId(),
      );
      if (response.status) {
        AddAndUpdatePermissionResponseModel addPermissionResponseModel =
            AddAndUpdatePermissionResponseModel.fromJson(response.data);
        if (addPermissionResponseModel.status ?? false) {
          return Right(addPermissionResponseModel.role!);
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
      return Left(ApiResponse.unKnownError());
    }
  }

  Future<Either<ApiResponse, RoleModel>> editPermission(
      {required RoleModel newPermission, required int id}) async {
    try {
      // reassign permission
      String url = await ApiEndPoints.getRoles();
      var response = await api.post(
        url: "$url/$id",
        data: newPermission.toJsonWithoutId(),
      );
      if (response.status) {
        // ignore: use_build_context_synchronously
        AddAndUpdatePermissionResponseModel addPermissionResponseModel =
            AddAndUpdatePermissionResponseModel.fromJson(response.data);
        if (addPermissionResponseModel.status ?? false) {
          return Right(addPermissionResponseModel.role!);
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
      return Left(ApiResponse.unKnownError());
    }
  }

  Future<Either<ApiResponse, RoleModel>> deletePermission({
    required RoleModel permission,
  }) async {
    try {
      String url = await ApiEndPoints.getRoles();
      // ignore: use_build_context_synchronously
      var response =
          // ignore: use_build_context_synchronously
          await api.delete(
        url: "$url/${permission.id}",
      );

      if (response.status) {
        // ignore: use_build_context_synchronously
        return Right(permission);
      } else {
        return Left(
          response,
        );
      }
    } catch (e) {
      return Left(ApiResponse.unKnownError());
    }
  }

  Future<Either<ApiResponse, List<RoleModel>>> getRoles(
      {bool isRefresh = false}) async {
    String? url;
    try {
      if (getRoleModel != null && !isRefresh) {
        if (getRoleModel!.nextPageUrl == null) return Right([]);
        url = getRoleModel!.nextPageUrl;
      }

      url ??= await ApiEndPoints.getRoles();

      var response = await api.get(
        url: url,
      );
      if (response.status) {
        getRoleModel = GetRoleModel.fromJson(response.data);
        return Right(getRoleModel?.data ?? []);
      } else {
        return Left(
          response,
        );
      }
    } catch (e) {
      return Left(ApiResponse.unKnownError());
    }
  }

  Future<Either<ApiResponse, List<RoleModel>>> getSearchRoles(
      {required String search, bool isNewSearch = false}) async {
    String? url;
    try {
      if (getRoleSearchModel != null && !isNewSearch) {
        if (getRoleSearchModel!.nextPageUrl == null) return Right([]);
        url = getRoleSearchModel!.nextPageUrl;
      }

      url ??= await ApiEndPoints.getRoles();

      var response = await api.get(
        url: url,
        queryParameters: search.isEmpty
            ? {}
            : {
                ApiKeys.search: search,
              },
      );
      if (response.status) {
        getRoleSearchModel = GetRoleModel.fromJson(response.data);
        return Right(getRoleSearchModel?.data ?? []);
      } else {
        return Left(
          response,
        );
      }
    } catch (e) {
      return Left(ApiResponse.unKnownError());
    }
  }

  void resetSearch() {
    getRoleSearchModel = null;
  }

  void reset() {
    getRoleSearchModel = null;
    getRoleModel = null;
  }
}
