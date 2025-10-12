import 'package:pos_app/core/api/api_keys.dart';
import 'package:pos_app/features/expense_categories/data/model/expense_categories_model.dart';

class AddOrUpdateExpenseCategoriesModel {
  final bool? success;
  final String? message;
  final ExpenseCategoriesModel? expenseCategory;

  AddOrUpdateExpenseCategoriesModel(
      {this.success, this.message, this.expenseCategory});

  factory AddOrUpdateExpenseCategoriesModel.fromJson(
      Map<String, dynamic> json) {
    return AddOrUpdateExpenseCategoriesModel(
      success: json[ApiKeys.success],
      message: json[ApiKeys.message],
      expenseCategory: json[ApiKeys.expenseCategory] != null
          ? ExpenseCategoriesModel.fromJson(json[ApiKeys.expenseCategory])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data[ApiKeys.success] = success;
    data[ApiKeys.message] = message;
    data[ApiKeys.expenseCategory] = expenseCategory;
    return data;
  }
}
