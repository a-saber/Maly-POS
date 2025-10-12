import 'package:pos_app/core/api/api_keys.dart';
import 'package:pos_app/features/auth/login/data/model/branche_model.dart';
import 'package:pos_app/features/auth/login/data/model/user_model.dart';
import 'package:pos_app/features/products/data/model/product_model.dart';
import 'package:pos_app/features/store_move/data/model/reference_model.dart';

class StoreMovementData {
  final int? id;
  final int? branchId;
  final int? productId;
  final int? userId;
  final String? movementType;
  final int? quantity;
  final String? referenceType;
  final int? referenceId;
  final String? createdAt;
  final String? updatedAt;
  final ProductModel? product;
  final BrancheModel? branch;
  final UserModel? user;
  final ReferenceModel? reference;

  StoreMovementData(
      {required this.id,
      required this.branchId,
      required this.productId,
      required this.userId,
      required this.movementType,
      required this.quantity,
      required this.referenceType,
      required this.referenceId,
      required this.createdAt,
      required this.updatedAt,
      required this.product,
      required this.branch,
      required this.user,
      required this.reference});

  factory StoreMovementData.fromJson(Map<String, dynamic> json) {
    return StoreMovementData(
      id: json[ApiKeys.id],
      branchId: json[ApiKeys.branchid],
      productId: json[ApiKeys.productid],
      userId: json[ApiKeys.userid],
      movementType: json[ApiKeys.movementtype],
      quantity: json[ApiKeys.quantity],
      referenceType: json[ApiKeys.referencetype],
      referenceId: json[ApiKeys.referenceid],
      createdAt: json[ApiKeys.createdat],
      updatedAt: json[ApiKeys.updatedat],
      product: json[ApiKeys.product] == null
          ? null
          : ProductModel.fromJson(json[ApiKeys.product]),
      branch: json[ApiKeys.branch] == null
          ? null
          : BrancheModel.fromJson(json[ApiKeys.branch]),
      user: json[ApiKeys.user] == null
          ? null
          : UserModel.fromJson(json[ApiKeys.user]),
      reference: json[ApiKeys.reference] == null
          ? null
          : ReferenceModel.fromJson(json[ApiKeys.reference]),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data[ApiKeys.id] = id;
    data[ApiKeys.branchid] = branchId;
    data[ApiKeys.productid] = productId;
    data[ApiKeys.userid] = userId;
    data[ApiKeys.movementtype] = movementType;
    data[ApiKeys.quantity] = quantity;
    data[ApiKeys.referencetype] = referenceType;
    data[ApiKeys.referenceid] = referenceId;
    data[ApiKeys.createdat] = createdAt;
    data[ApiKeys.updatedat] = updatedAt;
    data[ApiKeys.product] = product;
    data[ApiKeys.branch] = branch;
    data[ApiKeys.user] = user;
    data[ApiKeys.reference] = reference;
    return data;
  }
}
