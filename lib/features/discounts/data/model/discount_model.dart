import 'package:pos_app/core/api/api_keys.dart';
import 'package:pos_app/features/discounts/data/model/discount_type.dart';

// class DiscountTestModel {
//   final int id;
//   final String title;
//   final String? description;
//   final double valueAsPercentage;

//   DiscountTestModel(
//       {required this.id,
//       required this.title,
//       this.description,
//       required this.valueAsPercentage});
// }

class DiscountModel {
  final int? id;
  final String? title;
  final DiscountType? type;
  final String? value;
  final String? createdAt;
  final String? updatedAt;

  DiscountModel(
      {required this.id,
      required this.title,
      required this.type,
      required this.value,
      required this.createdAt,
      required this.updatedAt});

  factory DiscountModel.fromJson(Map<String, dynamic> json) {
    return DiscountModel(
      id: json[ApiKeys.id],
      title: json[ApiKeys.title],
      type: DiscountType.values.firstWhere(
        (e) => e.name == json[ApiKeys.type],
      ),
      value: json[ApiKeys.value],
      createdAt: json[ApiKeys.createdat],
      updatedAt: json[ApiKeys.updatedat],
    );
  }

  factory DiscountModel.fromJsonWithoutId(
      {required String title,
      required DiscountType type,
      required String value,
      int? id,
      String? createdAt,
      String? updatedAt}) {
    return DiscountModel(
        id: id,
        title: title,
        type: type,
        value: value,
        createdAt: createdAt,
        updatedAt: updatedAt);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data[ApiKeys.id] = id;
    data[ApiKeys.title] = title;
    data[ApiKeys.type] = type?.name;
    data[ApiKeys.value] = value;
    data[ApiKeys.createdat] = createdAt;
    data[ApiKeys.updatedat] = updatedAt;
    return data;
  }

  Map<String, dynamic> toJsonWithoutId() {
    final Map<String, dynamic> data = {};

    data[ApiKeys.title] = title;
    data[ApiKeys.type] = type?.name;
    data[ApiKeys.value] = value;

    return data;
  }
}
