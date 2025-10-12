import 'package:pos_app/core/api/api_keys.dart';
import 'package:pos_app/features/shop_setting/data/model/shop_setting_model.dart';

class GetShopSettingModel {
  final bool? status;
  final String? message;
  final ShopSettingModel? data;

  const GetShopSettingModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory GetShopSettingModel.fromJson(Map<String, dynamic> json) {
    return GetShopSettingModel(
      status: json[ApiKeys.status],
      message: json[ApiKeys.message],
      data: json[ApiKeys.data] == null
          ? null
          : ShopSettingModel.fromJson(json[ApiKeys.data]),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data[ApiKeys.status] = status;
    data[ApiKeys.message] = message;
    data[ApiKeys.data] = data;
    return data;
  }
}
