import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pos_app/core/api/api_keys.dart';
import 'package:pos_app/core/helper/upload_image_to_api.dart';
import 'package:pos_app/features/auth/login/data/model/branche_model.dart';
import 'package:pos_app/features/categories/data/model/category_model.dart';
import 'package:pos_app/features/taxes/data/model/taxes_model.dart';
import 'package:pos_app/features/units/data/model/unit_model.dart';

class UpdateProductModel {
  final int? id;
  final String? name;
  final int? categoryId;
  final String? type;
  final int? baseUnitId;
  final String? description;
  final String? imagePath;
  final String? brand;
  final int? taxId;
  final String? createdAt;
  final String? updatedAt;
  final String? imageUrl;
  List<ProductUnits>? productUnits;
  final UnitModel? baseUnit;
  final TaxesModel? tax;

  UpdateProductModel({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.type,
    required this.baseUnitId,
    required this.description,
    required this.imagePath,
    required this.brand,
    required this.taxId,
    required this.createdAt,
    required this.updatedAt,
    required this.imageUrl,
    required this.baseUnit,
    required this.productUnits,
    required this.tax,
  });

  factory UpdateProductModel.empty() {
    return UpdateProductModel(
      id: 0,
      name: '',
      categoryId: 0,
      description: '',
      imagePath: '',
      brand: '',
      createdAt: '',
      updatedAt: '',
      imageUrl: '',
      tax: null,
      taxId: 0,
      type: '',
      baseUnitId: null,
      baseUnit: null,
      productUnits: [],
    );
  }

  factory UpdateProductModel.fromJson(Map<String, dynamic> json) {
    List<ProductUnits> myProductUnits = <ProductUnits>[];
    if (json[ApiKeys.productUnits] != null) {
      json[ApiKeys.productUnits].forEach((v) {
        myProductUnits.add(ProductUnits.fromJson(v));
      });
    }
    return UpdateProductModel(
      id: json[ApiKeys.id],
      name: json[ApiKeys.name],
      categoryId: json[ApiKeys.categoryId],
      description: json[ApiKeys.description],
      imagePath: json[ApiKeys.imagepath],
      brand: json[ApiKeys.brand],
      createdAt: json[ApiKeys.createdat],
      updatedAt: json[ApiKeys.updatedat],
      imageUrl: json[ApiKeys.imageurl],
      baseUnit: json[ApiKeys.baseUnit] != null
          ? UnitModel.fromJson(json[ApiKeys.baseUnit])
          : null,
      tax: json[ApiKeys.tax] != null
          ? TaxesModel.fromJson(json[ApiKeys.tax])
          : null,
      taxId: json[ApiKeys.taxid],
      type: json[ApiKeys.type],
      baseUnitId: json[ApiKeys.baseUnitId],
      productUnits: myProductUnits,
    );
  }
  factory UpdateProductModel.copyWith(UpdateProductModel product) {
    return UpdateProductModel(
      id: product.id,
      name: product.name,
      categoryId: product.categoryId,
      baseUnitId: product.baseUnitId,
      description: product.description,
      imagePath: product.imagePath,
      productUnits: product.productUnits,
      brand: product.brand,
      createdAt: product.createdAt,
      updatedAt: product.updatedAt,
      imageUrl: product.imageUrl,
      baseUnit: product.baseUnit,
      tax: product.tax,
      taxId: product.taxId,
      type: product.type,
    );
  }

  factory UpdateProductModel.createWithoutId({
    required String? name,
    required String? description,
    required File? image,
    required UnitModel? unit,
    required CategoryModel? category,
    required String? price,
    required String? brand,
    required TaxesModel? tax,
    required String? type,
    required List<ProductUnits>? productUnits,
    int? id,
  }) {
    return UpdateProductModel(
      id: id,
      name: name,
      categoryId: category?.id,
      baseUnitId: unit?.id,
      description: description,
      imagePath: image?.path,
      brand: brand,
      createdAt: '',
      updatedAt: '',
      imageUrl: null,
      baseUnit: unit,
      tax: tax,
      productUnits: productUnits,
      taxId: tax?.id,
      type: type,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data[ApiKeys.id] = id;
    data[ApiKeys.name] = name;
    data[ApiKeys.categoryId] = categoryId;
    if (productUnits?.isNotEmpty ?? false) {
      data[ApiKeys.baseUnitId] = productUnits![0].unitId;
    }

    data[ApiKeys.description] = description;
    data[ApiKeys.imagepath] = imagePath;

    data[ApiKeys.brand] = brand;

    data[ApiKeys.createdat] = createdAt;
    data[ApiKeys.updatedat] = updatedAt;
    data[ApiKeys.imageurl] = imageUrl;
    // data[ApiKeys.unit] = unit;
    data[ApiKeys.taxid] = tax?.id;
    // data[ApiKeys.priceAfterTax] = priceAfterTax;
    data[ApiKeys.type] = type;
    // data[ApiKeys.quantity] = quantity;

    if (productUnits != null) {
      for (int i = 0; i < productUnits!.length; i++) {
        if (productUnits![i].branchQty.isNotEmpty) {
          data.addAll(productUnits![i].toJson(
            index: i,
            branches: productUnits![i].branchQty,
          ));
        } else {
          data.addAll(productUnits![i].toJson(
            index: i,
            branches: [],
          ));
        }
      }
    }

    // if (productUnits != null) {
    //   for (int i = 0; i < productUnits!.length; i++) {
    //     if (i < productUnits![i].branchQty.length) {
    //       data.addAll(productUnits![i].toJson(
    //         index: i,
    //          branches: productUnits![i].branchQty,
    //       ));
    //     } else {
    //       data.addAll(productUnits![i].toJson(
    //         index: i,
    //         branches: [],
    //       ));
    //     }
    //   }
    // }

    return data;
  }

  Future<Map<String, dynamic>> toJsonWithoutId(
      // {
      // required String? openingquantity,
      // required BrancheModel? branch,
      // required String? typeOfTax,
      // }
      {required List<List<BranchQuantity>> branchQuantities}) async {
    final Map<String, dynamic> data = <String, dynamic>{};

    data[ApiKeys.name] = name;
    data[ApiKeys.description] = description;
    if (imagePath != null) {
      data[ApiKeys.image] = await uploadImageToApi(image: File(imagePath!));
    }
    data[ApiKeys.baseUnitId] = baseUnitId;
    data[ApiKeys.taxid] = tax?.id;
    data[ApiKeys.categoryId] = categoryId;
    data[ApiKeys.brand] = brand;
    if (type != null && type!.isNotEmpty) {
      data[ApiKeys.type] = type;
    }

    if (productUnits != null) {
      for (int i = 0; i < productUnits!.length; i++) {
        if (productUnits![i].branchQty.isNotEmpty) {
          data.addAll(productUnits![i].toJson(
            index: i,
            branches: productUnits![i].branchQty,
          ));
        } else {
          data.addAll(productUnits![i].toJson(
            index: i,
            branches: [],
          ));
        }
      }
    }
    // if (productUnits != null) {
    //   for (int i = 0; i < productUnits!.length; i++) {
    //     if (i < branchQuantities.length) {
    //       data.addAll(productUnits![i].toJson(
    //         index: i,
    //         branches: branchQuantities[i],
    //       ));
    //     } else {
    //       data.addAll(productUnits![i].toJson(
    //         index: i,
    //         branches: [],
    //       ));
    //     }
    //   }
    // }

    return data;
  }
}

class ProductUnits {
  int? id;
  int? productId;
  int? unitId;
  String? conversionFactor;
  TextEditingController? factoryController;
  String? costPrice;
  TextEditingController? costPriceController;
  String? salePriceWithoutTax;
  TextEditingController? salePriceWithoutTaxController;
  String? barcode;
  TextEditingController? barCodeController;
  String? scaleBarcode;
  TextEditingController? scaleBarcodeController;
  String? createdAt;
  String? updatedAt;
  String? minPriceWithoutTax;
  TextEditingController? minPriceWithoutTaxController;
  TextEditingController? minPriceWithTaxController;
  String? salePriceWithTax;
  TextEditingController? salePriceWithTaxController;
  UnitModel? unit;
  List<BranchQuantity> branchQty = [];
  TextEditingController? minPriceWithoutTaxValue;
  String? minPriceWithTax;

  ProductUnits({
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
    this.unit,
    this.factoryController,
    this.costPriceController,
    this.barCodeController,
    this.scaleBarcodeController,
    this.minPriceWithoutTaxController,
    this.salePriceWithoutTaxController,
    this.salePriceWithTaxController,
    this.minPriceWithTax,
    this.minPriceWithTaxController,
  });

  factory ProductUnits.empty() {
    return ProductUnits(
      factoryController: TextEditingController(),
      costPriceController: TextEditingController(),
      barCodeController: TextEditingController(),
      scaleBarcodeController: TextEditingController(),
      minPriceWithoutTaxController: TextEditingController(),
      salePriceWithoutTaxController: TextEditingController(),
      salePriceWithTaxController: TextEditingController(),
      minPriceWithTaxController: TextEditingController(),
    );
  }

  factory ProductUnits.copyWith({
    required ProductUnits productUnits,
  }) {
    return ProductUnits(
      id: productUnits.id,
      productId: productUnits.productId,
      unitId: productUnits.unitId,
      conversionFactor: productUnits.conversionFactor,
      costPrice: productUnits.costPrice,
      salePriceWithoutTax: productUnits.salePriceWithoutTax,
      barcode: productUnits.barcode,
      scaleBarcode: productUnits.scaleBarcode,
      createdAt: productUnits.createdAt,
      updatedAt: productUnits.updatedAt,
      minPriceWithoutTax: productUnits.minPriceWithoutTax,
      salePriceWithTax: productUnits.salePriceWithTax,
      unit: productUnits.unit,
      factoryController: TextEditingController(
        text: productUnits.factoryController?.text,
      ),
      costPriceController: TextEditingController(
        text: productUnits.costPriceController?.text,
      ),
      barCodeController: TextEditingController(
        text: productUnits.barCodeController?.text,
      ),
      scaleBarcodeController: TextEditingController(
        text: productUnits.scaleBarcodeController?.text,
      ),
      minPriceWithoutTaxController: TextEditingController(
        text: productUnits.minPriceWithoutTaxController?.text,
      ),
      salePriceWithoutTaxController: TextEditingController(
        text: productUnits.salePriceWithoutTaxController?.text,
      ),
      salePriceWithTaxController: TextEditingController(
        text: productUnits.salePriceWithTaxController?.text,
      ),
      minPriceWithTaxController: TextEditingController(
        text: productUnits.minPriceWithTaxController?.text,
      ),
    );
  }

  ProductUnits.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    unitId = json['unit_id'];
    conversionFactor = json['conversion_factor'];
    costPrice = json['cost_price'];
    salePriceWithoutTax = json['sale_price_without_tax'];
    barcode = json['barcode'];
    scaleBarcode = json['scale_barcode'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    minPriceWithoutTax = json['min_price_without_tax'];
    salePriceWithTax = json['sale_price_with_tax'];
    factoryController = TextEditingController(text: conversionFactor ?? "");
    costPriceController = TextEditingController(text: costPrice ?? "");
    salePriceWithoutTaxController =
        TextEditingController(text: salePriceWithoutTax ?? "");
    minPriceWithoutTaxController =
        TextEditingController(text: minPriceWithoutTax ?? "");
    salePriceWithTaxController =
        TextEditingController(text: salePriceWithTax ?? "");
    barCodeController = TextEditingController(text: barcode ?? "");
    scaleBarcodeController = TextEditingController(text: scaleBarcode ?? "");

    unit = json['unit'] != null ? UnitModel.fromJson(json['unit']) : null;

    branchQty = [];

    if (json['opening_stocks'] != null && json['opening_stocks'] is List) {
      branchQty = (json['opening_stocks'] as List).map((stock) {
        return BranchQuantity(
          branch: stock['branch'] != null
              ? BrancheModel.fromJson(stock['branch'])
              : null,
          branchId: stock['branch_id'],
          qunantity: stock['quantity'] ?? 0,
          quantityController:
              TextEditingController(text: (stock['quantity'] ?? '').toString()),
        );
      }).toList();
    }
  }

  Map<String, dynamic> toJson(
      {required int index, required List<BranchQuantity> branches}) {
    final Map<String, dynamic> data = <String, dynamic>{};

    /// units[0][unit_id] ,
    data["units[$index][unit_id]"] = unitId;

    /// units[0][conversion_factor]
    data["units[$index][conversion_factor]"] = conversionFactor;

    /// units[0][cost_price]
    data["units[$index][cost_price]"] = costPrice;

    /// units[0][min_price_without_tax]
    data["units[$index][min_price_without_tax]"] = minPriceWithoutTax;

    /// units[0][sale_price_without_tax]
    data["units[$index][sale_price_without_tax]"] = salePriceWithoutTax;

    /// units[0][barcode]
    data["units[$index][barcode]"] = barcode;

    /// units[0][scale_barcode]
    data["units[$index][scale_barcode]"] = scaleBarcode;

    for (int i = 0; i < branches.length; i++) {
      data["units[$index][opening_stocks][$i][branch_id]"] =
          branches[i].branch?.id;
      data["units[$index][opening_stocks][$i][quantity]"] =
          branches[i].quantityController.text;
    }

    /// units[0][opening_stocks][0][branch_id]
    /// units[0][opening_stocks][0][quantity]
    /// units[0][opening_stocks][1][branch_id]
    /// units[0][opening_stocks][1][quantity]
    return data;
  }
}

class BranchQuantity {
  BrancheModel? branch;
  int? branchId;
  int? qunantity;
  TextEditingController quantityController;
  BranchQuantity(
      {required this.branch,
      required this.branchId,
      required this.qunantity,
      required this.quantityController});

  static BranchQuantity from(BranchQuantity branchQuantity) {
    return BranchQuantity(
      branch: branchQuantity.branch,
      branchId: branchQuantity.branchId,
      qunantity: branchQuantity.qunantity,
      quantityController: TextEditingController.fromValue(
          branchQuantity.quantityController.value),
    );
  }

  factory BranchQuantity.copyWith(
    BranchQuantity branchQuantity,
  ) {
    return BranchQuantity(
      branch: branchQuantity.branch,
      branchId: branchQuantity.branchId,
      qunantity: branchQuantity.qunantity,
      quantityController: TextEditingController(
        text: branchQuantity.quantityController.text.toString(),
      ),
    );
  }

  Map<String, dynamic> toJson({
    required int indexOfUnit,
    required int index,
  }) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['units[$indexOfUnit][opening_stocks][$index][branch_id]'] = branchId;
    data['units[$indexOfUnit][opening_stocks][$index][quantity]'] = qunantity;
    return data;
  }
}
