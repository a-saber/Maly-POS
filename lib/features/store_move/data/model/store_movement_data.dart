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
  final int? unitId;
  final String? quantityInBaseUnit;
  final String? quantity;
  final String? movementType;
  final String? referenceType;
  final int? referenceId;
  final String? createdAt;
  final String? updatedAt;
  final ProductModel? product;
  final BrancheModel? branch;
  final UserModel? user;
  final ReferenceModel? reference;

  StoreMovementData({
    this.id,
    this.branchId,
    this.productId,
    this.userId,
    this.unitId,
    this.quantityInBaseUnit,
    this.quantity,
    this.movementType,
    this.referenceType,
    this.referenceId,
    this.createdAt,
    this.updatedAt,
    this.product,
    this.branch,
    this.user,
    this.reference,
  });

  factory StoreMovementData.fromJson(Map<String, dynamic> json) {
    return StoreMovementData(
      id: json[ApiKeys.id] is int ? json[ApiKeys.id] : int.tryParse(json[ApiKeys.id]?.toString() ?? '0'),
      branchId: json[ApiKeys.branchid] is int ? json[ApiKeys.branchid] : int.tryParse(json[ApiKeys.branchid]?.toString() ?? '0'),
      productId: json[ApiKeys.productid] is int ? json[ApiKeys.productid] : int.tryParse(json[ApiKeys.productid]?.toString() ?? '0'),
      userId: json[ApiKeys.userid] is int ? json[ApiKeys.userid] : int.tryParse(json[ApiKeys.userid]?.toString() ?? '0'),
      unitId: json[ApiKeys.unitId] is int ? json[ApiKeys.unitId] : int.tryParse(json[ApiKeys.unitId]?.toString() ?? '0'),
      quantityInBaseUnit: json['quantity_in_base_unit']?.toString(),
      quantity: json[ApiKeys.quantity]?.toString(),
      movementType: json[ApiKeys.movementtype]?.toString(),
      referenceType: json[ApiKeys.referencetype]?.toString(),
      referenceId: json[ApiKeys.referenceid] is int ? json[ApiKeys.referenceid] : int.tryParse(json[ApiKeys.referenceid]?.toString() ?? '0'),
      createdAt: json[ApiKeys.createdat]?.toString(),
      updatedAt: json[ApiKeys.updatedat]?.toString(),
      product: json[ApiKeys.product] == null ? null : ProductModel.fromJson(json[ApiKeys.product]),
      branch: json[ApiKeys.branch] == null ? null : BrancheModel.fromJson(json[ApiKeys.branch]),
      user: json[ApiKeys.user] == null ? null : UserModel.fromJson(json[ApiKeys.user]),
      reference: json[ApiKeys.reference] == null ? null : ReferenceModel.fromJson(json[ApiKeys.reference]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ApiKeys.id: id,
      ApiKeys.branchid: branchId,
      ApiKeys.productid: productId,
      ApiKeys.userid: userId,
      ApiKeys.unitId: unitId,
      'quantity_in_base_unit': quantityInBaseUnit,
      ApiKeys.quantity: quantity,
      ApiKeys.movementtype: movementType,
      ApiKeys.referencetype: referenceType,
      ApiKeys.referenceid: referenceId,
      ApiKeys.createdat: createdAt,
      ApiKeys.updatedat: updatedAt,
      ApiKeys.product: product?.toJson(),
      ApiKeys.branch: branch?.toJson(),
      ApiKeys.user: user?.toJson(),
      ApiKeys.reference: reference?.toJson(),
    };
  }
}