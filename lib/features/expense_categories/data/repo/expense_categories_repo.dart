import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:pos_app/core/api/api_helper.dart';
import 'package:pos_app/core/api/api_keys.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/features/expense_categories/data/model/add_or_update_expense_categories_model.dart';
import 'package:pos_app/features/expense_categories/data/model/expense_categories_model.dart';
import 'package:pos_app/features/expense_categories/data/model/get_expense_categories_model.dart';

class ExpenseCategoriesRepo {
  final ApiHelper api;
  GetExpenseCategoriesModel? getExpenseCategoriesModel;

  ExpenseCategoriesRepo({required this.api});

  Future<Either<ApiResponse, List<ExpenseCategoriesModel>>>
      getExpenseCategories({
    bool isRefresh = false,
  }) async {
    try {
      String url;
      if (getExpenseCategoriesModel == null || isRefresh) {
        url = await ApiEndPoints.getExpenseCategories();
      } else {
        if (getExpenseCategoriesModel!.nextPageUrl == null) {
          return Right([]);
        } else {
          url = getExpenseCategoriesModel!.nextPageUrl!;
        }
      }
      var response = await api.get(
        url: url,
      );
      if (response.status) {
        getExpenseCategoriesModel =
            GetExpenseCategoriesModel.fromJson(response.data);
        return Right(getExpenseCategoriesModel!.data!);
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

  Future<Either<ApiResponse, ExpenseCategoriesModel>> addExpenseCategory({
    required ExpenseCategoriesModel expenseCategoriesModel,
  }) async {
    try {
      String url = await ApiEndPoints.getExpenseCategories();
      var response = await api.post(
        url: url,
        data: expenseCategoriesModel.toJsonWithoutId(),
      );
      if (response.status) {
        AddOrUpdateExpenseCategoriesModel addOrUpdateExpenseCategoriesModel =
            AddOrUpdateExpenseCategoriesModel.fromJson(response.data);
        if (addOrUpdateExpenseCategoriesModel.success ?? false) {
          return Right(addOrUpdateExpenseCategoriesModel.expenseCategory!);
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

  Future<Either<ApiResponse, ExpenseCategoriesModel>> updateExpenseCategory({
    required ExpenseCategoriesModel expenseCategoriesModel,
  }) async {
    try {
      String url = await ApiEndPoints.getExpenseCategories();
      var response = await api.post(
        url: "$url/${expenseCategoriesModel.id}",
        data: expenseCategoriesModel.toJsonWithoutId(),
      );
      if (response.status) {
        AddOrUpdateExpenseCategoriesModel addOrUpdateExpenseCategoriesModel =
            AddOrUpdateExpenseCategoriesModel.fromJson(response.data);
        if (addOrUpdateExpenseCategoriesModel.success ?? false) {
          return Right(addOrUpdateExpenseCategoriesModel.expenseCategory!);
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

  Future<Either<ApiResponse, int>> deleteExpenseCategory({
    required int id,
  }) async {
    try {
      String url = await ApiEndPoints.getExpenseCategories();
      var response = await api.delete(
        url: "$url/$id",
      );
      if (response.status) {
        return Right(id);
      } else {
        return Left(response);
      }
    } catch (e) {
      debugPrint(e.toString());
      // ignore: use_build_context_synchronously
      return Left(ApiResponse.unKnownError());
    }
  }

  void reset() {
    getExpenseCategoriesModel = null;
  }
}
