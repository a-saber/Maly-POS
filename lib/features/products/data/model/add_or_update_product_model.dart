import 'package:pos_app/core/api/api_keys.dart';
import 'package:pos_app/features/products/data/model/product_model.dart';

class AddOrUpdateProduct {
  final bool? status;
  final String? message;
  final ProductModel? product;

  AddOrUpdateProduct(
      {required this.status, required this.message, required this.product});

  factory AddOrUpdateProduct.fromJson(Map<String, dynamic> json) {
    return AddOrUpdateProduct(
      status: json[ApiKeys.status],
      message: json[ApiKeys.message],
      product: json[ApiKeys.product] != null
          ? ProductModel.fromJson(json[ApiKeys.product])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data[ApiKeys.status] = status;
    data[ApiKeys.message] = message;
    data[ApiKeys.product] = product;
    return data;
  }
}
