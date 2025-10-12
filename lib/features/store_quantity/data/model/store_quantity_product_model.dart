import 'package:pos_app/core/api/api_keys.dart';
import 'package:pos_app/features/auth/login/data/model/branche_model.dart';
import 'package:pos_app/features/products/data/model/product_model.dart';

class StoreQuantityProductModel {
  final int? id;
  final int? productId;
  final int? branchId;
  final int? quantity;
  final String? createdAt;
  final String? updatedAt;
  final ProductModel? product;
  final BrancheModel? branch;

  StoreQuantityProductModel(
      {required this.id,
      required this.productId,
      required this.branchId,
      required this.quantity,
      required this.createdAt,
      required this.updatedAt,
      required this.product,
      required this.branch});

  factory StoreQuantityProductModel.fromJson(Map<String, dynamic> json) {
    return StoreQuantityProductModel(
      id: json[ApiKeys.id],
      productId: json[ApiKeys.productid],
      branchId: json[ApiKeys.branchid],
      quantity: json[ApiKeys.quantity],
      createdAt: json[ApiKeys.createdat],
      updatedAt: json[ApiKeys.updatedat],
      product: json[ApiKeys.product] != null
          ? ProductModel.fromJson(json[ApiKeys.product])
          : null,
      branch: json[ApiKeys.branch] != null
          ? BrancheModel.fromJson(json[ApiKeys.branch])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data[ApiKeys.id] = id;
    data[ApiKeys.productid] = productId;
    data[ApiKeys.branchid] = branchId;
    data[ApiKeys.quantity] = quantity;
    data[ApiKeys.createdat] = createdAt;
    data[ApiKeys.updatedat] = updatedAt;
    data[ApiKeys.product] = product;
    data[ApiKeys.branch] = branch;

    return data;
  }
}
