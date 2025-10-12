import 'package:pos_app/core/api/api_keys.dart';
import 'package:pos_app/features/units/data/model/unit_model.dart';

class AddOrUpdateUnitResponseModel {
  final bool? success;
  final String? message;
  final UnitModel? unit;

  AddOrUpdateUnitResponseModel(
      {required this.success, required this.message, required this.unit});

  factory AddOrUpdateUnitResponseModel.fromJson(Map<String, dynamic> json) {
    return AddOrUpdateUnitResponseModel(
      success: json[ApiKeys.success],
      message: json[ApiKeys.message],
      unit: json[ApiKeys.unit] != null
          ? UnitModel.fromJson(json[ApiKeys.unit])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data[ApiKeys.success] = success;
    data[ApiKeys.message] = message;
    data[ApiKeys.unit] = unit;
    return data;
  }
}
