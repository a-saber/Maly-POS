import 'package:pos_app/core/api/api_keys.dart';

// class TaxesTestModel {
//   final int id;
//   final String title;
//   final String? description;
//   final TaxesValueType taxesValueType;
//   final double value;

//   TaxesTestModel(
//       {required this.id,
//       required this.title,
//       this.description,
//       required this.taxesValueType,
//       required this.value});
// }

// enum TaxesValueType { value, percentage }

class TaxesModel {
  final int? id;
  final String? title;
  final String? percentage;
  final String? createdAt;
  final String? updatedAt;

  TaxesModel(
      {required this.id,
      required this.title,
      required this.percentage,
      required this.createdAt,
      required this.updatedAt});

  factory TaxesModel.fromJson(Map<String, dynamic> json) {
    return TaxesModel(
      id: json[ApiKeys.id],
      title: json[ApiKeys.title],
      percentage: json[ApiKeys.percentage],
      createdAt: json[ApiKeys.createdat],
      updatedAt: json[ApiKeys.updatedat],
    );
  }
  factory TaxesModel.createWithoutId({
    required String? title,
    required String? percentage,
    int? id,
    String? createdAt,
    String? updatedAt,
  }) {
    return TaxesModel(
      id: id,
      title: title,
      percentage: percentage,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data[ApiKeys.id] = id;
    data[ApiKeys.title] = title;
    data[ApiKeys.percentage] = percentage;
    data[ApiKeys.createdat] = createdAt;
    data[ApiKeys.updatedat] = updatedAt;
    return data;
  }

  Map<String, dynamic> toJsonWithoutId() {
    final Map<String, dynamic> data = {};

    data[ApiKeys.title] = title;
    data[ApiKeys.percentage] = percentage;

    return data;
  }
}
