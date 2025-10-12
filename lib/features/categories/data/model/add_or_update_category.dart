import 'package:pos_app/core/api/api_keys.dart';
import 'package:pos_app/features/categories/data/model/category_model.dart';

class AddOrUpdateCategory {
  final bool? success;
  final String? message;
  final CategoryModel? category;

  AddOrUpdateCategory(
      {required this.success, required this.message, required this.category});

  factory AddOrUpdateCategory.fromJson(Map<String, dynamic> json) {
    return AddOrUpdateCategory(
      success: json[ApiKeys.success],
      message: json[ApiKeys.message],
      category: json[ApiKeys.category] == null
          ? null
          : CategoryModel.fromJson(json[ApiKeys.category]),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data[ApiKeys.success] = success;
    data[ApiKeys.message] = message;
    data[ApiKeys.category] = category;
    return data;
  }
}
