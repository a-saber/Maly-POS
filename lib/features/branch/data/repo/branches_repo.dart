import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:pos_app/core/api/api_helper.dart';
import 'package:pos_app/core/api/api_keys.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/features/auth/login/data/model/branche_model.dart';
import 'package:pos_app/features/branch/data/model/add_and_update_branch_response_model.dart';
import 'package:pos_app/features/branch/data/model/get_branches_model.dart';

class BranchesRepo {
  final ApiHelper api;
  GetBranchesModel? getBranchesModel;
  GetBranchesModel? getBranchesSearchModel;

  BranchesRepo({required this.api});

  Future<Either<ApiResponse, List<BrancheModel>>> getBranches({
    bool isRefresh = false,
  }) async {
    try {
      ApiResponse? response;
      if (getBranchesModel == null || isRefresh) {
        String url = await ApiEndPoints.getBranches();
        // ignore: use_build_context_synchronously
        response = await api.get(
          url: url,
        );
      } else {
        if (getBranchesModel!.nextPageUrl == null) {
          return Right([]);
        } else {
          String url = getBranchesModel!.nextPageUrl!;
          // ignore: use_build_context_synchronously
          response = await api.get(
            url: url,
          );
        }
      }

      if (response.status) {
        getBranchesModel = GetBranchesModel.fromJson(response.data);
        return Right(getBranchesModel!.data!);
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

  Future<Either<ApiResponse, BrancheModel>> addBranch({
    required BrancheModel branch,
  }) async {
    try {
      String url = await ApiEndPoints.getBranches();
      var response = await api.post(
        url: url,
        data: branch.toJsonWithoutId(),
        // ignore: use_build_context_synchronously
      );

      if (response.status) {
        AddAndUpdateBranchResponseModel addAndUpdateBranchResponseModel =
            AddAndUpdateBranchResponseModel.fromJson(response.data);

        if (addAndUpdateBranchResponseModel.status ?? false) {
          return Right(addAndUpdateBranchResponseModel.branch!);
        } else {
          return Left(
            response,
          );
        }
      } else {
        return Left(response);
      }
    } catch (e) {
      debugPrint(e.toString());
      // ignore: use_build_context_synchronously
      return Left(ApiResponse.unKnownError());
    }
  }

  Future<Either<ApiResponse, int>> deleteBranch({
    required BrancheModel branch,
  }) async {
    try {
      String url = await ApiEndPoints.getBranches();
      var response =
          // ignore: use_build_context_synchronously
          await api.delete(
        url: "$url/${branch.id}",
      );

      if (response.status) {
        return Right(branch.id!);
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

  Future<Either<ApiResponse, BrancheModel>> editBranch(
      {required BrancheModel branch, required int id}) async {
    try {
      String url = await ApiEndPoints.getBranches();
      var response = await api.post(
        url: "$url/$id",
        data: branch.toJsonWithoutId(),
      );

      if (response.status) {
        AddAndUpdateBranchResponseModel addAndUpdateBranchResponseModel =
            AddAndUpdateBranchResponseModel.fromJson(response.data);
        if (addAndUpdateBranchResponseModel.status ?? false) {
          return Right(addAndUpdateBranchResponseModel.branch!);
        } else {
          return Left(
            response,
          );
        }
      } else {
        return Left(response);
      }
    } catch (e) {
      return Left(ApiResponse.unKnownError());
    }
  }

  Future<Either<ApiResponse, List<BrancheModel>>> getSearchBranches({
    bool isFirstTime = false,
    required String query,
  }) async {
    try {
      ApiResponse? response;
      if (getBranchesSearchModel == null || isFirstTime) {
        String url = await ApiEndPoints.getBranches();
        // ignore: use_build_context_synchronously
        response = await api.get(
          url: url,
          queryParameters: query.isEmpty
              ? null
              : {
                  ApiKeys.search: query,
                },
        );
      } else {
        if (getBranchesSearchModel!.nextPageUrl == null) {
          return Right([]);
        } else {
          String url = getBranchesSearchModel!.nextPageUrl!;
          // ignore: use_build_context_synchronously
          response = await api.get(
            url: url,
          );
        }
      }

      if (response.status) {
        getBranchesSearchModel = GetBranchesModel.fromJson(response.data);
        return Right(getBranchesSearchModel!.data!);
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

  void resetSearch() {
    getBranchesSearchModel = null;
  }

  void resetGetBranches() {
    getBranchesSearchModel = null;
    getBranchesModel = null;
  }
}
