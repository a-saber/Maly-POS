import 'dart:io';

import 'package:pos_app/core/api/api_keys.dart';
import 'package:pos_app/core/helper/upload_image_to_api.dart';
import 'package:pos_app/features/auth/login/data/model/branche_model.dart';
import 'package:pos_app/features/categories/data/model/category_model.dart';
import 'package:pos_app/features/taxes/data/model/taxes_model.dart';
import 'package:pos_app/features/units/data/model/unit_model.dart';

class ProductModel {
  final int? id;
  final String? name;
  final int? categoryId;
  final String? type;
  final int? unitId;
  final String? description;
  final String? imagePath;
  final String? barcode;
  final String? brand;
  final String? price;
  final int? taxId;
  final String? createdAt;
  final String? updatedAt;
  final String? imageUrl;
  final num? priceAfterTax;
  final UnitModel? unit;
  final TaxesModel? tax;
  final int? quantity;

  ProductModel({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.unitId,
    required this.description,
    required this.imagePath,
    required this.barcode,
    required this.brand,
    required this.price,
    required this.createdAt,
    required this.updatedAt,
    required this.imageUrl,
    required this.unit,
    required this.tax,
    required this.taxId,
    required this.priceAfterTax,
    required this.type,
    required this.quantity,
  });

  factory ProductModel.empty() {
    return ProductModel(
      id: 0,
      name: '',
      categoryId: 0,
      unitId: 0,
      description: '',
      imagePath: '',
      barcode: '',
      brand: '',
      price: '',
      createdAt: '',
      updatedAt: '',
      imageUrl: '',
      unit: null,
      tax: null,
      taxId: 0,
      priceAfterTax: 0,
      type: '',
      quantity: 0,
    );
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json[ApiKeys.id],
      name: json[ApiKeys.name],
      categoryId: json[ApiKeys.categoryId],
      unitId: json[ApiKeys.unitId],
      description: json[ApiKeys.description],
      imagePath: json[ApiKeys.imagepath],
      barcode: json[ApiKeys.barcode],
      brand: json[ApiKeys.brand],
      price: json[ApiKeys.price],
      createdAt: json[ApiKeys.createdat],
      updatedAt: json[ApiKeys.updatedat],
      imageUrl: json[ApiKeys.imageurl],
      unit: json[ApiKeys.unit] != null
          ? UnitModel.fromJson(json[ApiKeys.unit])
          : null,
      tax: json[ApiKeys.tax] != null
          ? TaxesModel.fromJson(json[ApiKeys.tax])
          : null,
      priceAfterTax: json[ApiKeys.priceAfterTax] is String
          ? double.tryParse(json[ApiKeys.priceAfterTax])
          : json[ApiKeys.priceAfterTax],
      taxId: json[ApiKeys.taxid],
      type: json[ApiKeys.type],
      quantity: json[ApiKeys.quantity],
    );
  }
  factory ProductModel.copyWith(UnitModel? unit, ProductModel product) {
    return ProductModel(
      id: product.id,
      name: product.name,
      categoryId: product.categoryId,
      unitId: unit?.id,
      description: product.description,
      imagePath: product.imagePath,
      barcode: product.barcode,
      brand: product.brand,
      price: product.price,
      createdAt: product.createdAt,
      updatedAt: product.updatedAt,
      imageUrl: product.imageUrl,
      unit: unit ?? product.unit,
      tax: product.tax,
      priceAfterTax: product.priceAfterTax,
      taxId: product.taxId,
      type: product.type,
      quantity: product.quantity,
    );
  }

  factory ProductModel.createWithoutId({
    required String? name,
    required String? description,
    required File? image,
    required UnitModel? unit,
    required CategoryModel? category,
    required String? price,
    required String? brand,
    required String? barcode,
    required TaxesModel? tax,
    required String? type,
    int? id,
  }) {
    return ProductModel(
      id: id,
      name: name,
      categoryId: category?.id,
      unitId: unit?.id,
      description: description,
      imagePath: image?.path,
      brand: brand,
      price: price,
      barcode: barcode,
      createdAt: '',
      updatedAt: '',
      imageUrl: null,
      unit: unit,
      tax: tax,
      priceAfterTax: null,
      taxId: tax?.id,
      type: type,
      quantity: null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data[ApiKeys.id] = id;
    data[ApiKeys.name] = name;
    data[ApiKeys.categoryId] = categoryId;
    data[ApiKeys.unitId] = unitId;
    data[ApiKeys.description] = description;
    data[ApiKeys.imagepath] = imagePath;
    data[ApiKeys.barcode] = barcode;
    data[ApiKeys.brand] = brand;
    data[ApiKeys.price] = price;
    data[ApiKeys.createdat] = createdAt;
    data[ApiKeys.updatedat] = updatedAt;
    data[ApiKeys.imageurl] = imageUrl;
    data[ApiKeys.unit] = unit;
    data[ApiKeys.tax] = tax;
    data[ApiKeys.priceAfterTax] = priceAfterTax;
    data[ApiKeys.type] = type;
    data[ApiKeys.quantity] = quantity;

    return data;
  }

  Future<Map<String, dynamic>> toJsonWithoutId({
    required String? openingquantity,
    required BrancheModel? branch,
    // required String? typeOfTax,
  }) async {
    final Map<String, dynamic> data = <String, dynamic>{};

    data[ApiKeys.name] = name;
    data[ApiKeys.categoryId] = categoryId;
    data[ApiKeys.unitId] = unitId;
    data[ApiKeys.description] = description;
    if (imagePath != null) {
      data[ApiKeys.image] = await uploadImageToApi(image: File(imagePath!));
    }
    data[ApiKeys.barcode] = barcode;
    data[ApiKeys.brand] = brand;
    data[ApiKeys.price] = price;
    data[ApiKeys.unit] = unit;
    if (openingquantity != null && openingquantity.isNotEmpty) {
      data[ApiKeys.openingquantity] = openingquantity;
    }

    if (branch != null) {
      data[ApiKeys.branchid] = branch.id;
    }

    data[ApiKeys.taxid] = tax?.id;

    if (type != null && type!.isNotEmpty) {
      data[ApiKeys.type] = type;
    }

    return data;
  }
}
