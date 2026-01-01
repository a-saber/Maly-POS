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
  late int? baseUnitId;
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
  int? isavailable = 1;

  UpdateProductModel(
      {required this.id,
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
      this.isavailable});
  bool get isAvailableBool => isavailable == 1;
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
        isavailable: 1);
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
      isavailable: json['switch'] == null
          ? 1 
          : json['switch'] is bool
              ? (json['switch'] ? 1 : 0)
              : int.tryParse(json['switch'].toString()) ?? 1,
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
        isavailable: product.isavailable);
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
    String? type,
    required List<ProductUnits>? productUnits,
    int? id,
    int? isavailable = 1,
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
        isavailable: isavailable);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data[ApiKeys.id] = id;
    data[ApiKeys.name] = name;
    data[ApiKeys.categoryId] = categoryId;
    data[ApiKeys.description] = description;
    data[ApiKeys.brand] = brand;
    data[ApiKeys.taxid] = taxId;
    data[ApiKeys.type] = type;
    data['switch'] = isavailable;

    data[ApiKeys.baseUnitId] = baseUnitId;

    if (imagePath != null && imagePath!.isNotEmpty) {
      data[ApiKeys.image] = imagePath;
    }

    if (productUnits != null) {
      int index = 0;

      for (final unit in productUnits!) {
        data["units[$index][unit_id]"] = unit.unitId ?? unit.unit?.id;

        data["units[$index][conversion_factor]"] =
            unit.conversionFactor ?? unit.factoryController?.text ?? "1";

        if (unit.id != null) {
          data["units[$index][id]"] = unit.id;
        }

        data["units[$index][cost_price]"] = unit.costPrice ?? unit.costPriceController?.text;
        data["units[$index][sale_price_without_tax]"] = unit.salePriceWithoutTax ?? unit.salePriceWithoutTaxController?.text;
        data["units[$index][sale_price_with_tax]"] = unit.salePriceWithTax ?? unit.salePriceWithTaxController?.text;
        // data["units[$index][min_price_without_tax]"] = unit.minPriceWithoutTax ?? unit.minPriceWithoutTaxController?.text;
        print("xxxxxxxxminPriceWithoutTax ${unit.minPriceWithoutTax}");
        data["units[$index][min_price_without_tax]"] = unit.minPriceWithoutTax;
        data["units[$index][min_price_with_tax]"] = unit.minPriceWithTax ?? unit.minPriceWithTaxController?.text;
        data["units[$index][barcode]"] = unit.barcode ?? unit.barCodeController?.text;
        data["units[$index][scale_barcode]"] = unit.scaleBarcode ?? unit.scaleBarcodeController?.text;
        for (int i = 0; i < unit.branchQty.length; i++) {
          final branchQuantity = unit.branchQty[i];
          data["units[$index][opening_stocks][$i][branch_id]"] =
              branchQuantity.branch?.id ?? branchQuantity.branchId;
          data["units[$index][opening_stocks][$i][quantity]"] =
              branchQuantity.quantityController.text;
        }

        index++;
      }
    }

    return data;
  }

  Future<Map<String, dynamic>> updateProduct() async {
    final Map<String, dynamic> data = <String, dynamic>{};

    data[ApiKeys.id] = id;
    data[ApiKeys.name] = name;
    data[ApiKeys.categoryId] = categoryId;
    data[ApiKeys.description] = description;
    data[ApiKeys.brand] = brand;
    data[ApiKeys.taxid] = taxId;
    data[ApiKeys.type] = type;
    data['switch'] = isavailable;

    data[ApiKeys.baseUnitId] = baseUnitId;

    if (imagePath != null && imagePath!.isNotEmpty) {
      data[ApiKeys.image] = await uploadImageToApi(image: File(imagePath!));
    }

    if (productUnits != null) {
      int index = 0;

      for (final unit in productUnits!) {
        data["units[$index][unit_id]"] = unit.unitId ?? unit.unit?.id;

        data["units[$index][conversion_factor]"] =
            unit.conversionFactor ?? unit.factoryController?.text ?? "1";

        if (unit.id != null) {
          data["units[$index][id]"] = unit.id;
        }

        data["units[$index][cost_price]"] =
            unit.costPrice ?? unit.costPriceController?.text;
        data["units[$index][sale_price_without_tax]"] =
            unit.salePriceWithoutTax ??
                unit.salePriceWithoutTaxController?.text;
        data["units[$index][sale_price_with_tax]"] =
            unit.salePriceWithTax ?? unit.salePriceWithTaxController?.text;
        // data["units[$index][min_price_without_tax]"] = unit.minPriceWithoutTax ?? unit.minPriceWithoutTaxController?.text;
        print("xxxxxxxxminPriceWithoutTax ${unit.minPriceWithoutTax}");
        data["units[$index][min_price_without_tax]"] = unit.minPriceWithoutTax;
        data["units[$index][min_price_with_tax]"] =
            unit.minPriceWithTax ?? unit.minPriceWithTaxController?.text;
        data["units[$index][barcode]"] =
            unit.barcode ?? unit.barCodeController?.text;
        data["units[$index][scale_barcode]"] =
            unit.scaleBarcode ?? unit.scaleBarcodeController?.text;
        for (int i = 0; i < unit.branchQty.length; i++) {
          final branchQuantity = unit.branchQty[i];
          data["units[$index][opening_stocks][$i][branch_id]"] =
              branchQuantity.branch?.id ?? branchQuantity.branchId;
          data["units[$index][opening_stocks][$i][quantity]"] =
              branchQuantity.quantityController.text;
        }

        index++;
      }
    }

    return data;
  }

  Future<Map<String, dynamic>> toJsonWithoutId({
    required List<List<BranchQuantity>> branchQuantities,
  }) async {
    final Map<String, dynamic> data = <String, dynamic>{};

    data[ApiKeys.name] = name;
    data[ApiKeys.description] = description;
    if (productUnits != null && productUnits!.isNotEmpty) {
      data[ApiKeys.baseUnitId] =
          productUnits![0].unitId ?? productUnits![0].unit?.id;
    }
    if (imagePath != null) {
      data[ApiKeys.image] = await uploadImageToApi(image: File(imagePath!));
    }

    data[ApiKeys.taxid] = tax?.id;
    data[ApiKeys.categoryId] = categoryId;
    data[ApiKeys.brand] = brand;
    data['switch'] = isavailable;

    if (productUnits != null) {
      for (int i = 0; i < productUnits!.length; i++) {
        final unit = productUnits![i];
        final isExisting = unit.id != null;

        data.addAll(unit.toJson(
          index: i,
          branches: unit.branchQty,
          isUpdate: isExisting,
        ));
      }
    }

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

  factory ProductUnits.empty({UnitModel? unit}) {
    return ProductUnits(
        factoryController: TextEditingController(),
        costPriceController: TextEditingController(),
        barCodeController: TextEditingController(),
        scaleBarcodeController: TextEditingController(),
        minPriceWithoutTaxController: TextEditingController(),
        salePriceWithoutTaxController: TextEditingController(),
        salePriceWithTaxController: TextEditingController(),
        minPriceWithTaxController: TextEditingController(),
        unit: unit);
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
    minPriceWithTax = json['min_price_with_tax'];

    factoryController = TextEditingController(text: conversionFactor ?? "");
    costPriceController = TextEditingController(text: costPrice ?? "");
    salePriceWithoutTaxController =
        TextEditingController(text: salePriceWithoutTax ?? "");
    minPriceWithoutTaxController =
        TextEditingController(text: minPriceWithoutTax ?? "");
    salePriceWithTaxController =
        TextEditingController(text: salePriceWithTax ?? "");
    minPriceWithTaxController =
        TextEditingController(text: minPriceWithTax ?? "");
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

  Map<String, dynamic> toJson({
    required int index,
    required List<BranchQuantity> branches,
    bool isUpdate = false,
  }) {
    final Map<String, dynamic> data = <String, dynamic>{};

    if (isUpdate && id != null) {
      data["units[$index][id]"] = id;
    } else {
      data["units[$index][unit_id]"] = unitId;
      data["units[$index][conversion_factor]"] = conversionFactor;
    }

    data["units[$index][cost_price]"] = costPrice;
    data["units[$index][min_price_without_tax]"] = minPriceWithoutTax;
    data["units[$index][min_price_with_tax]"] = minPriceWithTax;
    data["units[$index][sale_price_without_tax]"] = salePriceWithoutTax;
    data["units[$index][sale_price_with_tax]"] = salePriceWithTax;
    data["units[$index][barcode]"] = barcode;
    data["units[$index][scale_barcode]"] = scaleBarcode;

    for (int i = 0; i < branches.length; i++) {
      data["units[$index][opening_stocks][$i][branch_id]"] =
          branches[i].branch?.id;
      data["units[$index][opening_stocks][$i][quantity]"] =
          branches[i].quantityController.text;
    }

    return data;
  }
}

class BranchQuantity {
  BrancheModel? branch;
  int? branchId;
  int? qunantity;
  late TextEditingController quantityController;

  BranchQuantity({
    required this.branch,
    required this.branchId,
    required this.qunantity,
    TextEditingController? quantityController,
  }) {
    this.quantityController = quantityController ?? 
        TextEditingController(
          text: (qunantity != null && qunantity! > 0) 
              ? qunantity.toString() 
              : '', 
        );
  }

  factory BranchQuantity.empty() {
    return BranchQuantity(
      branch: null,
      branchId: null,
      qunantity: 0,
      quantityController: TextEditingController(text: ''), 
    );
  }

  static BranchQuantity from(BranchQuantity branchQuantity) {
    return BranchQuantity(
      branch: branchQuantity.branch != null 
          ? BrancheModel.from(branchQuantity.branch!) 
          : null,
      branchId: branchQuantity.branchId,
      qunantity: branchQuantity.qunantity,
      quantityController: TextEditingController(
        text: (branchQuantity.qunantity != null && branchQuantity.qunantity! > 0)
            ? branchQuantity.qunantity.toString()
            : '',
      ),
    );
  }

  factory BranchQuantity.fromJson(Map<String, dynamic> json) {
    final quantity = json['quantity'] as int? ?? 0;
    return BranchQuantity(
      branch: json['branch'] != null 
          ? BrancheModel.fromJson(json['branch']) 
          : null,
      branchId: json['branch_id'],
      qunantity: quantity,
      quantityController: TextEditingController(
        text: quantity > 0 ? quantity.toString() : '', 
      ),
    );
  }

  Map<String, dynamic> toJson({
    required int indexOfUnit,
    required int index,
  }) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['units[$indexOfUnit][opening_stocks][$index][branch_id]'] = branchId;
    data['units[$indexOfUnit][opening_stocks][$index][quantity]'] = qunantity ?? 0;
    return data;
  }
}