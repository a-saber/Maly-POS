import 'package:pos_app/core/api/api_keys.dart';
import 'package:pos_app/features/discounts/data/model/discount_model.dart';

class AddOrUpdateDiscountResponse {
  final bool? success;
  final String? message;
  final DiscountModel? discount;

  AddOrUpdateDiscountResponse(
      {required this.success, required this.message, required this.discount});

  factory AddOrUpdateDiscountResponse.fromJson(Map<String, dynamic> json) {
    return AddOrUpdateDiscountResponse(
      success: json[ApiKeys.success],
      message: json[ApiKeys.message],
      discount: json[ApiKeys.discount] != null
          ? DiscountModel.fromJson(json[ApiKeys.discount])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data[ApiKeys.success] = success;
    data[ApiKeys.message] = message;
    data[ApiKeys.discount] = discount;
    return data;
  }
}
