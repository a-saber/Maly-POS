import 'package:pos_app/core/api/api_keys.dart';

class ExpenseCategoriesModel {
  final int? id;
  final String? name;
  final String? description;
  final String? createdAt;
  final String? updatedAt;

  ExpenseCategoriesModel(
      {required this.id,
      required this.name,
      required this.description,
      required this.createdAt,
      required this.updatedAt});

  factory ExpenseCategoriesModel.fromJson(Map<String, dynamic> json) {
    return ExpenseCategoriesModel(
      id: json[ApiKeys.id],
      name: json[ApiKeys.name],
      description: json[ApiKeys.description],
      createdAt: json[ApiKeys.createdat],
      updatedAt: json[ApiKeys.updatedat],
    );
  }
  factory ExpenseCategoriesModel.createWithoutId({
    required String? name,
    required String? description,
    int? id,
  }) {
    return ExpenseCategoriesModel(
      id: id,
      name: name,
      description: description,
      createdAt: null,
      updatedAt: null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data[ApiKeys.id] = id;
    data[ApiKeys.name] = name;
    data[ApiKeys.description] = description;
    data[ApiKeys.createdat] = createdAt;
    data[ApiKeys.updatedat] = updatedAt;
    return data;
  }

  Map<String, dynamic> toJsonWithoutId() {
    final Map<String, dynamic> data = {};

    data[ApiKeys.name] = name;
    data[ApiKeys.description] = description;

    return data;
  }
}
