import 'package:pos_app/core/api/api_keys.dart';
import 'package:pos_app/features/taxes/data/model/taxes_model.dart';

class ReferenceModel {
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
  final String? name;
  final int? categoryId;
  final int? baseUnitId;
  final String? type;
  final String? description;
  final String? imagePath;
  final String? brand;
  final String? imageUrl;
  final TaxesModel? tax;

  ReferenceModel({
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
    this.name,
    this.categoryId,
    this.baseUnitId,
    this.type,
    this.description,
    this.imagePath,
    this.brand,
    this.imageUrl,
    this.tax,
  });

  factory ReferenceModel.fromJson(Map<String, dynamic> json) {
    return ReferenceModel(
      id: json[ApiKeys.id] is int ? json[ApiKeys.id] : int.tryParse(json[ApiKeys.id]?.toString() ?? '0'),
      saleId: json[ApiKeys.saleid] is int ? json[ApiKeys.saleid] : int.tryParse(json[ApiKeys.saleid]?.toString() ?? '0'),
      productId: json[ApiKeys.productid] is int ? json[ApiKeys.productid] : int.tryParse(json[ApiKeys.productid]?.toString() ?? '0'),
      unitId: json[ApiKeys.unitId] is int ? json[ApiKeys.unitId] : int.tryParse(json[ApiKeys.unitId]?.toString() ?? '0'),
      quantity: json[ApiKeys.quantity]?.toString(),
      taxId: json[ApiKeys.taxid] is int ? json[ApiKeys.taxid] : int.tryParse(json[ApiKeys.taxid]?.toString() ?? '0'),
      price: json[ApiKeys.price]?.toString(),
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
      createdAt: json[ApiKeys.createdat]?.toString(),
      updatedAt: json[ApiKeys.updatedat]?.toString(),
      name: json[ApiKeys.name]?.toString(),
      categoryId: json[ApiKeys.categoryId] is int ? json[ApiKeys.categoryId] : int.tryParse(json[ApiKeys.categoryId]?.toString() ?? '0'),
      baseUnitId: json['base_unit_id'] is int ? json['base_unit_id'] : int.tryParse(json['base_unit_id']?.toString() ?? '0'),
      type: json[ApiKeys.type]?.toString(),
      description: json[ApiKeys.description]?.toString(),
      imagePath: json[ApiKeys.imagepath]?.toString(),
      brand: json[ApiKeys.brand]?.toString(),
      imageUrl: json[ApiKeys.imageurl]?.toString(),
      tax: json[ApiKeys.tax] == null ? null : TaxesModel.fromJson(json[ApiKeys.tax]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ApiKeys.id: id,
      ApiKeys.saleid: saleId,
      ApiKeys.productid: productId,
      ApiKeys.unitId: unitId,
      ApiKeys.quantity: quantity,
      ApiKeys.taxid: taxId,
      ApiKeys.price: price,
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
      ApiKeys.createdat: createdAt,
      ApiKeys.updatedat: updatedAt,
      ApiKeys.name: name,
      ApiKeys.categoryId: categoryId,
      'base_unit_id': baseUnitId,
      ApiKeys.type: type,
      ApiKeys.description: description,
      ApiKeys.imagepath: imagePath,
      ApiKeys.brand: brand,
      ApiKeys.imageurl: imageUrl,
      ApiKeys.tax: tax?.toJson(),
    };
  }
}