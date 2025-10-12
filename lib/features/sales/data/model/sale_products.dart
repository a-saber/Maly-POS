import 'package:pos_app/core/api/api_keys.dart';
import 'package:pos_app/features/products/data/model/product_model.dart';
import 'package:pos_app/features/units/data/model/unit_model.dart';

class SaleProducts {
  final int? id;
  final int? saleId;
  final int? productId;
  final int? unitId;
  final String? price;
  final String? unitPriceAfterDiscount;
  final String? lineTotalBeforeDiscount;
  final String? lineTotalAfterDiscount;
  final String? taxAmount;
  final String? lineTotalAfterTax;
  final int? quantity;
  final String? createdAt;
  final String? updatedAt;
  final int? taxId;
  final ProductModel? product;
  final UnitModel? unit;

  SaleProducts(
      {required this.id,
      required this.saleId,
      required this.productId,
      required this.unitId,
      required this.price,
      required this.unitPriceAfterDiscount,
      required this.lineTotalBeforeDiscount,
      required this.lineTotalAfterDiscount,
      required this.taxAmount,
      required this.lineTotalAfterTax,
      required this.quantity,
      required this.createdAt,
      required this.updatedAt,
      required this.taxId,
      required this.product,
      required this.unit});

  factory SaleProducts.fromJson(Map<String, dynamic> json) {
    return SaleProducts(
      id: json[ApiKeys.id],
      saleId: json[ApiKeys.saleid],
      productId: json[ApiKeys.productid],
      unitId: json[ApiKeys.unitId],
      price: json[ApiKeys.price],
      unitPriceAfterDiscount: json[ApiKeys.unitpriceafterdiscount],
      lineTotalBeforeDiscount: json[ApiKeys.linetotalbeforediscount],
      lineTotalAfterDiscount: json[ApiKeys.linetotalafterdiscount],
      taxAmount: json[ApiKeys.taxamount],
      lineTotalAfterTax: json[ApiKeys.linetotalaftertax],
      quantity: json[ApiKeys.quantity],
      createdAt: json[ApiKeys.createdat],
      updatedAt: json[ApiKeys.updatedat],
      taxId: json[ApiKeys.taxid],
      product: json[ApiKeys.product] != null
          ? ProductModel.fromJson(json[ApiKeys.product])
          : null,
      unit: json[ApiKeys.unit] != null
          ? UnitModel.fromJson(json[ApiKeys.unit])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data[ApiKeys.id] = id;
    data[ApiKeys.saleid] = saleId;
    data[ApiKeys.productid] = productId;
    data[ApiKeys.unitId] = unitId;
    data[ApiKeys.price] = price;
    data[ApiKeys.unitpriceafterdiscount] = unitPriceAfterDiscount;
    data[ApiKeys.linetotalbeforediscount] = lineTotalBeforeDiscount;
    data[ApiKeys.linetotalafterdiscount] = lineTotalAfterDiscount;
    data[ApiKeys.taxamount] = taxAmount;
    data[ApiKeys.linetotalaftertax] = lineTotalAfterTax;
    data[ApiKeys.quantity] = quantity;
    data[ApiKeys.createdat] = createdAt;
    data[ApiKeys.updatedat] = updatedAt;
    data[ApiKeys.taxid] = taxId;
    if (product != null) {
      data[ApiKeys.product] = product!.toJson();
    }
    if (unit != null) {
      data[ApiKeys.unit] = unit!.toJson();
    }

    return data;
  }
}
