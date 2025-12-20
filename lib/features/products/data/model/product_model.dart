import 'dart:io';

import 'package:pos_app/core/api/api_keys.dart';
import 'package:pos_app/core/helper/upload_image_to_api.dart';
import 'package:pos_app/features/auth/login/data/model/branche_model.dart';
import 'package:pos_app/features/categories/data/model/category_model.dart';
import 'package:pos_app/features/products/data/model/product_unit_model.dart';
import 'package:pos_app/features/products/data/model/update_product_model.dart';
import 'package:pos_app/features/taxes/data/model/taxes_model.dart';
import 'package:pos_app/features/units/data/model/unit_model.dart';
import 'package:collection/collection.dart';

class ProductModel {
  final int? id;
  final String? name;

  final int? categoryId;
  final String? type;
  final int? baseUnitId;
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
  final List<ProductUnit>? productUnits;
  final CategoryModel? category;
  final int? isavailable;

  ProductModel(   {
    this.productUnits,
    required this.category,
    required this.id,
    required this.name,
    required this.categoryId,
    required this.baseUnitId,
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
    this.isavailable,
    required this.quantity,
  });
   bool get isAvailableBool => isavailable == 1;
  double? get salePriceWithTaxForBaseUnit => double.tryParse((productUnits?.firstWhereOrNull((unit)=>unit.unitId==baseUnitId)?.salePriceWithTax?? "").toString());


  factory ProductModel.empty() {
    return ProductModel(
      id: 0,
      name: '',
      categoryId: 0,
      baseUnitId: 0,
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
      productUnits: null,
     category: null,
      isavailable: 1

    );
  }
  ProductModel copyWith({
    int? id,
    String? name,
    int? categoryId,
    String? type,
    int? baseUnitId,
    String? description,
    String? imagePath,
    String? barcode,
    String? brand,
    String? price,
    int? taxId,
    String? createdAt,
    String? updatedAt,
    String? imageUrl,
    num? priceAfterTax,
    UnitModel? unit,
    TaxesModel? tax,
    int? quantity,
    List<ProductUnit>? productUnits,
    CategoryModel? category,
    int? isavailable,

  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      categoryId: categoryId ?? this.categoryId,
      type: type ?? this.type,
      baseUnitId: baseUnitId ?? this.baseUnitId,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
      barcode: barcode ?? this.barcode,
      brand: brand ?? this.brand,
      price: price ?? this.price,
      taxId: taxId ?? this.taxId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      imageUrl: imageUrl ?? this.imageUrl,
      priceAfterTax: priceAfterTax ?? this.priceAfterTax,
      unit: unit ?? this.unit,
      tax: tax ?? this.tax,
      quantity: quantity ?? this.quantity,
      productUnits: productUnits ?? this.productUnits,
      category: category ?? this.category,
      isavailable: isavailable ?? this.isavailable
    );
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json[ApiKeys.id],
      name: json[ApiKeys.name],
      categoryId: json[ApiKeys.categoryId],
      baseUnitId: json[ApiKeys.baseUnitId],
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
      productUnits:json[ApiKeys.productUnits] != null
          ? (json[ApiKeys.productUnits] as List)
          .map((item) => ProductUnit.fromJson(item as Map<String, dynamic>))
          .toList()
          : null ,

         category: json[ApiKeys.category] != null
        ? CategoryModel.fromJson(json[ApiKeys.category])
        : null,

      isavailable: 
      int.tryParse((json['switch']??'1').toString())
    );

  }
  factory ProductModel.copyWith(UnitModel? unit, ProductModel product) {
    return ProductModel(
      id: product.id,
      name: product.name,
      categoryId: product.categoryId,
      baseUnitId: unit?.id,
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
       category: product.category,
      productUnits: product.productUnits,
      isavailable: product.isavailable
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
     bool isavailable=true,

  }) {
    return ProductModel(
      id: id,
      name: name,
      categoryId: category?.id,
      baseUnitId: unit?.id,
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
      category: category,
       isavailable: isavailable ? 1 : 0,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data[ApiKeys.id] = id;
    data[ApiKeys.name] = name;
    data[ApiKeys.categoryId] = categoryId;
    data['base_unit_id'] = unit?.id;
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
    data[ApiKeys.productUnits]=productUnits;
     data['switch'] = isavailable;

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
    data['base_unit_id'] = unit?.id;
    data[ApiKeys.description] = description;
    if (imagePath != null) {
      data[ApiKeys.image] = await uploadImageToApi(image: File(imagePath!));
    }
    data[ApiKeys.barcode] = barcode;
    data[ApiKeys.brand] = brand;
    data[ApiKeys.price] = price;
    data[ApiKeys.unit] = unit;
    data['switch'] = isavailable;

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
