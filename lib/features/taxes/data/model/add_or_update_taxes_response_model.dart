import 'package:pos_app/core/api/api_keys.dart';
import 'package:pos_app/features/taxes/data/model/taxes_model.dart';

class AddOrUpdateTaxesResponseModel {
  final bool? success;
  final String? message;
  final TaxesModel? tax;

  AddOrUpdateTaxesResponseModel({
    required this.success,
    required this.message,
    required this.tax,
  });

  factory AddOrUpdateTaxesResponseModel.fromJson(Map<String, dynamic> json) {
    return AddOrUpdateTaxesResponseModel(
      success: json[ApiKeys.success],
      message: json[ApiKeys.message],
      tax: json[ApiKeys.tax] == null
          ? null
          : TaxesModel.fromJson(json[ApiKeys.tax]),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data[ApiKeys.success] = success;
    data[ApiKeys.message] = message;
    data[ApiKeys.tax] = tax;
    return data;
  }
}
