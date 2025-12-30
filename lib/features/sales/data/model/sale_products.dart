import 'package:pos_app/features/products/data/model/product_model.dart';
import 'package:pos_app/features/units/data/model/unit_model.dart';

int? _parseToInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is String) return int.tryParse(value);
  return null;
}

class SaleProducts {
  final int? id;
  final int? saleId;
  final int? productId;
  final int? unitId;
  final String? quantity;
  final int? taxId;
  final String? price;
  final String? unitPriceAfterDiscount;
  final String? lineTotalBeforeDiscount;
  final String? lineTotalAfterDiscount;
  final String? taxAmount;
  final String? lineTotalAfterTax;
  final String? taxPercentage;
  final String? conversionFactor;
  final String? quantityInBaseUnit;
  final String? baseUnitCost;
  final String? unitCost;
  final String? lineTotalCost;
  final String? lineNetProfit;
  final String? createdAt;
  final String? updatedAt;
  final ProductModel? product;
  final UnitModel? unit;

  SaleProducts({
    this.id,
    this.saleId,
    this.productId,
    this.unitId,
    this.quantity,
    this.taxId,
    this.price,
    this.unitPriceAfterDiscount,
    this.lineTotalBeforeDiscount,
    this.lineTotalAfterDiscount,
    this.taxAmount,
    this.lineTotalAfterTax,
    this.taxPercentage,
    this.conversionFactor,
    this.quantityInBaseUnit,
    this.baseUnitCost,
    this.unitCost,
    this.lineTotalCost,
    this.lineNetProfit,
    this.createdAt,
    this.updatedAt,
    this.product,
    this.unit,
  });

  factory SaleProducts.fromJson(Map<String, dynamic> json) {
    return SaleProducts(
      id: _parseToInt(json['id']),
      saleId: _parseToInt(json['sale_id']),
      productId: _parseToInt(json['product_id']),
      unitId: _parseToInt(json['unit_id']),
      quantity: json['quantity']?.toString(),
      taxId: _parseToInt(json['tax_id']),
      price: json['price']?.toString(),
      unitPriceAfterDiscount: json['unit_price_after_discount']?.toString(),
      lineTotalBeforeDiscount: json['line_total_before_discount']?.toString(),
      lineTotalAfterDiscount: json['line_total_after_discount']?.toString(),
      taxAmount: json['tax_amount']?.toString(),
      lineTotalAfterTax: json['line_total_after_tax']?.toString(),
      taxPercentage: json['tax_percentage']?.toString(),
      conversionFactor: json['conversion_factor']?.toString(),
      quantityInBaseUnit: json['quantity_in_base_unit']?.toString(),
      baseUnitCost: json['base_unit_cost']?.toString(),
      unitCost: json['unit_cost']?.toString(),
      lineTotalCost: json['line_total_cost']?.toString(),
      lineNetProfit: json['line_net_profit']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      product: json['product'] != null 
          ? ProductModel.fromJson(json['product']) 
          : null,
      unit: json['unit'] != null 
          ? UnitModel.fromJson(json['unit']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sale_id': saleId,
      'product_id': productId,
      'unit_id': unitId,
      'quantity': quantity,
      'tax_id': taxId,
      'price': price,
      'unit_price_after_discount': unitPriceAfterDiscount,
      'line_total_before_discount': lineTotalBeforeDiscount,
      'line_total_after_discount': lineTotalAfterDiscount,
      'tax_amount': taxAmount,
      'line_total_after_tax': lineTotalAfterTax,
      'tax_percentage': taxPercentage,
      'conversion_factor': conversionFactor,
      'quantity_in_base_unit': quantityInBaseUnit,
      'base_unit_cost': baseUnitCost,
      'unit_cost': unitCost,
      'line_total_cost': lineTotalCost,
      'line_net_profit': lineNetProfit,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'product': product?.toJson(),
      'unit': unit?.toJson(),
    };
  }
}