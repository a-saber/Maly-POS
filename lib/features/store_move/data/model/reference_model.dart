import 'package:pos_app/core/api/api_keys.dart';
import 'package:pos_app/features/taxes/data/model/taxes_model.dart';

class ReferenceModel {
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
  final String? name;
  final int? categoryId;
  final String? type;
  final String? description;
  final String? imagePath;
  final String? barcode;
  final String? brand;
  final String? imageUrl;
  final String? priceAfterTax;
  final TaxesModel? tax;

  ReferenceModel(
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
      required this.name,
      required this.categoryId,
      required this.type,
      required this.description,
      required this.imagePath,
      required this.barcode,
      required this.brand,
      required this.imageUrl,
      required this.priceAfterTax,
      required this.tax});

  factory ReferenceModel.fromJson(Map<String, dynamic> json) {
    return ReferenceModel(
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
      name: json[ApiKeys.name],
      categoryId: json[ApiKeys.categoryId],
      type: json[ApiKeys.type],
      description: json[ApiKeys.description],
      imagePath: json[ApiKeys.imagepath],
      barcode: json[ApiKeys.barcode],
      brand: json[ApiKeys.brand],
      imageUrl: json[ApiKeys.imageurl],
      priceAfterTax: json[ApiKeys.priceAfterTax].toString(),
      tax: json[ApiKeys.tax] == null
          ? null
          : TaxesModel.fromJson(json[ApiKeys.tax]),
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
    data[ApiKeys.name] = name;
    data[ApiKeys.categoryId] = categoryId;
    data[ApiKeys.type] = type;
    data[ApiKeys.description] = description;
    data[ApiKeys.imagepath] = imagePath;
    data[ApiKeys.barcode] = barcode;
    data[ApiKeys.brand] = brand;
    data[ApiKeys.imageurl] = imageUrl;
    data[ApiKeys.priceAfterTax] = priceAfterTax;
    data[ApiKeys.tax] = tax;
    return data;
  }
}
