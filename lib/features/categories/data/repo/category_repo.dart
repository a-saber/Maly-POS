import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:pos_app/core/api/api_helper.dart';
import 'package:pos_app/core/api/api_keys.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/features/categories/data/model/add_or_update_category.dart';
import 'package:pos_app/features/categories/data/model/category_model.dart';
import 'package:pos_app/features/categories/data/model/get_category_model.dart';

class CategoryRepo {
  final ApiHelper api;
  GetCategoryModel? getCategory;
  GetCategoryModel? getCategorySearch;

  CategoryRepo({required this.api});
  Future<Either<ApiResponse, CategoryModel>> addCategory({
    required CategoryModel category,
  }) async {
    try {
      String url = await ApiEndPoints.getCategories();
      var data = await category.toJsonWithoutId();
      var response = await api.post(
        url: url,
        data: data,
      );
      if (response.status) {
        AddOrUpdateCategory addOrUpdateCategory =
            AddOrUpdateCategory.fromJson(response.data);
        if (addOrUpdateCategory.success ?? false) {
          return Right(addOrUpdateCategory.category!);
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

  Future<Either<ApiResponse, List<CategoryModel>>> getCategories({
    bool isRefresh = false,
  }) async {
    try {
      String url;
      if (getCategory == null || isRefresh) {
        url = await ApiEndPoints.getCategories();
      } else {
        if (getCategory!.nextPageUrl == null) {
          return Right([]);
        } else {
          url = getCategory!.nextPageUrl!;
        }
      }
      var response = await api.get(
        url: url,
      );
      if (response.status) {
        getCategory = GetCategoryModel.fromJson(response.data);
        return Right(getCategory!.data!);
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

  Future<Either<ApiResponse, CategoryModel>> updateCategory({
    required CategoryModel category,
  }) async {
    try {
      String url = await ApiEndPoints.getCategories();
      var data = await category.toJsonWithoutId();
      var response = await api.post(
        url: "$url/${category.id}",
        data: data,
      );
      if (response.status) {
        AddOrUpdateCategory addOrUpdateCategory =
            AddOrUpdateCategory.fromJson(response.data);
        if (addOrUpdateCategory.success ?? false) {
          return Right(addOrUpdateCategory.category!);
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

  Future<Either<ApiResponse, int>> deleteCategory({
    required CategoryModel category,
  }) async {
    try {
      String url = await ApiEndPoints.getCategories();
      var response = await api.delete(
        url: "$url/${category.id}",
      );
      if (response.status) {
        return Right(category.id!);
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

  Future<Either<ApiResponse, CategoryModel>> getSpecificCategory({
    required int id,
  }) async {
    try {
      String url = await ApiEndPoints.getCategories();

      var response = await api.get(
        url: "$url/$id",
      );
      if (response.status) {
        AddOrUpdateCategory addOrUpdateCategory =
            AddOrUpdateCategory.fromJson(response.data);
        if (addOrUpdateCategory.success ?? false) {
          return Right(addOrUpdateCategory.category!);
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

  Future<Either<ApiResponse, List<CategoryModel>>> searchCategory(
      {required String? search, bool isNewSearch = false}) async {
    try {
      String url = await ApiEndPoints.getCategories();
      ApiResponse response;
      if (getCategorySearch == null || isNewSearch) {
        if (search == null || search.isEmpty) {
          response = await api.get(
            url: url,
          );
        } else {
          response = await api.get(
            url: url,
            queryParameters: {
              ApiKeys.search: search,
            },
          );
        }
      } else {
        if (getCategorySearch!.nextPageUrl == null) {
          return Right([]);
        } else {
          url = getCategorySearch!.nextPageUrl!;

          response = await api.get(
            url: url,
          );
        }
      }

      if (response.status) {
        getCategorySearch = GetCategoryModel.fromJson(response.data);
        return Right(getCategorySearch!.data!);
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

  void resetSearch() {
    getCategorySearch = null;
  }

  void resetCategories() {
    getCategorySearch = null;
    getCategory = null;
  }
}
