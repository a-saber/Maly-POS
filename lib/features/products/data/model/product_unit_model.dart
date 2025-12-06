import 'package:pos_app/features/products/data/model/update_product_model.dart';

import '../../../units/data/model/unit_model.dart';

class ProductUnit {
  final int? id;
  final int? productId;
  final int? unitId;
  final String? conversionFactor;
  final String? costPrice;
  final String? salePriceWithoutTax;
  final String? barcode;
  final String? scaleBarcode;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? minPriceWithoutTax;
  final String? minPriceWithTax;
  final String? salePriceWithTax;
  final UnitModel? unit;
  /// this will be add later
  final List<BranchQuantity> branchQty;

  ProductUnit({
    this.id,
    this.productId,
    this.unitId,
    this.conversionFactor,
    this.costPrice,
    this.salePriceWithoutTax,
    this.barcode,
    this.scaleBarcode,
    this.createdAt,
    this.updatedAt,
    this.minPriceWithoutTax,
    this.salePriceWithTax,
    this.minPriceWithTax,
    this.unit,
    /// this will be add later
    this.branchQty = const [],
  });

  factory ProductUnit.fromJson(Map<String, dynamic> json) {
    return ProductUnit(
      id: json['id'] as int?,
      productId: json['product_id'] as int?,
      unitId: json['unit_id'] as int?,
      conversionFactor: json['conversion_factor'] as String?,
      costPrice: json['cost_price'] as String?,
      salePriceWithoutTax: json['sale_price_without_tax'] as String?,
      barcode: json['barcode'] as String?,
      scaleBarcode: json['scale_barcode'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      minPriceWithoutTax: json['min_price_without_tax'] as String?,
      minPriceWithTax: json['min_price_with_tax'] as String?,
      salePriceWithTax: json['sale_price_with_tax'] as String?,
      unit: json['unit'] != null
          ? UnitModel.fromJson(json['unit'] as Map<String, dynamic>)
          : null,
        /// this will be add later
      branchQty: []
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'unit_id': unitId,
      'conversion_factor': conversionFactor,
      'cost_price': costPrice,
      'sale_price_without_tax': salePriceWithoutTax,
      'barcode': barcode,
      'scale_barcode': scaleBarcode,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'min_price_without_tax': minPriceWithoutTax,
      'min_price_with_tax': minPriceWithTax,
      'sale_price_with_tax': salePriceWithTax,
      'unit': unit?.toJson(),
    };
  }
}
