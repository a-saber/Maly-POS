import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/core/helper/calc_helper.dart';
import 'package:pos_app/features/auth/login/data/model/branche_model.dart';
import 'package:pos_app/features/categories/data/model/category_model.dart';
import 'package:pos_app/features/products/data/model/product_model.dart';
import 'package:pos_app/features/products/data/model/product_type.dart';
import 'package:pos_app/features/products/data/model/update_product_model.dart';
import 'package:pos_app/features/products/data/repo/products_repo.dart';
import 'package:pos_app/features/taxes/data/model/taxes_model.dart';
import 'package:pos_app/features/units/data/model/unit_model.dart';

part 'add_product_state.dart';

class AddProductCubit extends Cubit<AddProductState> {
  AddProductCubit(this.repo) : super(AddProductInitial()) {
    addProductUnits();
  }
  static AddProductCubit get(context) => BlocProvider.of(context);
  final ProductsRepo repo;
  GlobalKey<FormState> formKey = GlobalKey();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController pricePerUnitController = TextEditingController();
double baseCost = 0;
double baseMinPriceWithoutTax = 0;
double baseMinPriceWithTax = 0;
double baseSalePriceWithoutTax = 0;
double baseSalePriceWithTax = 0;

  XFile? image;
  CategoryModel? category;
  UnitModel? unit;
  BrancheModel? branch;
  TaxesModel? taxes;
  ProductType? productType;

  final TextEditingController barCodeController = TextEditingController();
  final TextEditingController brandController = TextEditingController();
  final TextEditingController openingQuantityController =
      TextEditingController();

  List<ProductUnits> productUnits = [];
  Future<void> addProduct() async {
    emit(AddProductLoading());

    if (formKey.currentState?.validate() == true) {
      UpdateProductModel updateProductModel =
          UpdateProductModel.createWithoutId(
        unit: null,
        productUnits: productUnits,
        name: nameController.text,
        description: descriptionController.text,
        category: category,
        image: image == null ? null : File(image!.path),
        price: pricePerUnitController.text,
        brand: brandController.text,
        tax: taxes,
        type: productType?.value,
      );
      var response = await repo.addUpdateProduct(
        updateProduct: updateProductModel,
      );
      response.fold(
        (error) => emit(AddProductFailing(errMessage: error)),
        (r) => emit(AddProductSuccess(
          product: r,
        )),
      );
      // TODO : Add Product
      var reponse = await repo.addProduct(
        unit: unit!,
        openingquantity: openingQuantityController.text.trim(),
        branch: branch,
        product: ProductModel.createWithoutId(
          name: nameController.text,
          description: descriptionController.text,
          category: category,
          unit: unit,
          image: image == null ? null : File(image!.path),
          price: pricePerUnitController.text,
          barcode: barCodeController.text,
          brand: brandController.text,
          tax: taxes,
          type: productType?.value,
        ),
      );
      reponse.fold(
        (error) => emit(AddProductFailing(errMessage: error)),
        (r) => emit(AddProductSuccess(
          product: r,
        )),
      );
    } else {
      autovalidateMode = AutovalidateMode.always;
      emit(AddProductUnValidate());
    }
  }

  void onChangeCategory(CategoryModel? newCategory) {
    if (category?.id != newCategory?.id) {
      category = newCategory;
      emit(AddChangeCategory());
    }
  }

  void onChangeProductType(ProductType? newProductType) {
    if (productType?.id != newProductType?.id) {
      productType = newProductType;
      emit(AddChangProductType());
    }
  }

  void onChangeTaxes(TaxesModel? newTaxes) {
    if (taxes?.id != newTaxes?.id) {
      taxes = newTaxes;

      emit(AddChangeTaxes());
    }
  }

  void addProductUnits() {
    productUnits.add(
      ProductUnits.empty(),
    );

    if (productUnits.length == 1) {
      productUnits[0].factoryController!.text = '1';
    }

    emit(AddProductAddUnit());
  }

  void removeProductUnit({required int index}) {
    if (index != 0) {
      productUnits.removeAt(index);
      emit(AddProductRemoveUnit());
    }
  }

  onUnitChanged({required UnitModel unitModel, required int index}) {
    productUnits[index].unit = unitModel;
    emit(AddProductChangeUnit());
  }

  void assignBranchQty(
      {required index, required List<BranchQuantity> branchQuantities}) {
    // if(productType?.name == 'المخزون') { // TODO
    productUnits[index].branchQty = List.from(branchQuantities);
    emit(AddProductAssignBranchQty());
    // }
  }



  String decimalToStringForUI(Decimal value, {int fraction = 2}) {
    final str = value.toString();
    if (!str.contains('.')) {
      return '$str.${'0' * fraction}';
    }
    final parts = str.split('.');
    final decimals = parts[1].padRight(fraction, '0');
    return '${parts[0]}.$decimals'.substring(0, parts[0].length + 1 + fraction);
  }

  void onChangeMinPriceWithoutTax(
      {required int index, required String newValue}) {
    if (newValue.isEmpty) {
      productUnits[index].minPriceWithTaxController?.text = "0";
      emit(AddProductOnPriceChange());
      return;
    }

    try {
      Decimal newValueDecimal = Decimal.parse(newValue);
      String percentageStr = taxes?.percentage ?? "0";
      Decimal percentageDecimal = Decimal.parse(percentageStr);
      Decimal percentFraction =
          DecimalHelper.divide(percentageDecimal.toString(), "100");
      Decimal onePlusFraction =
          DecimalHelper.add("1", percentFraction.toString());
      Decimal afterTax = DecimalHelper.multiply(
          newValueDecimal.toString(), onePlusFraction.toString());
      productUnits[index].minPriceWithTaxController?.text =
          decimalToStringForUI(afterTax);
    } catch (_) {
      productUnits[index].minPriceWithTaxController?.text = "0";
    }

    emit(AddProductOnPriceChange());
  }

  void onChangeMinPriceWithTax({required int index, required String newValue}) {
    if (newValue.isEmpty) {
      productUnits[index].minPriceWithoutTaxController?.text = "0";
      emit(AddProductOnPriceChange());
      return;
    }

    try {
      Decimal valueWithTax = Decimal.parse(newValue);
      String percentageStr = taxes?.percentage ?? "0";
      Decimal percentageDecimal = Decimal.parse(percentageStr);

      Decimal percentFraction =
          DecimalHelper.divide(percentageDecimal.toString(), "100");

      Decimal onePlusFraction =
          DecimalHelper.add("1", percentFraction.toString());

      Decimal beforeTax = DecimalHelper.divide(
          valueWithTax.toString(), onePlusFraction.toString());

      productUnits[index].minPriceWithTaxController?.text =
          decimalToStringForUI(beforeTax);
    } catch (_) {
      productUnits[index].minPriceWithoutTaxController?.text = "0";
    }

    emit(AddProductOnPriceChange());
  }

  void onUnitChangedd({required UnitModel unitModel, required int index}) {
  productUnits[index].unit = unitModel;

  if (index != 0) {
    updateUnitPrices(index);
  }

  emit(AddProductChangeUnit());
}

void onChangeCost(int index) {
  if (productUnits.isEmpty) return;

  if (index == 0) {
   
    baseCost = double.tryParse(productUnits[0].costPriceController?.text ?? '0') ?? 0;
    baseMinPriceWithoutTax = double.tryParse(productUnits[0].minPriceWithoutTaxController?.text ?? '') ?? baseCost;
    baseMinPriceWithTax = double.tryParse(productUnits[0].minPriceWithTaxController?.text ?? '') ?? baseMinPriceWithoutTax;
    baseSalePriceWithoutTax =
    double.tryParse(productUnits[0].salePriceWithoutTaxController?.text ?? '0') ?? 0;

baseSalePriceWithTax =
    double.tryParse(productUnits[0].salePriceWithTaxController?.text ?? '0') ?? 0;


   
    for (int i = 1; i < productUnits.length; i++) {
      updateUnitPrices(i);
    }
  } else {
    emit(UpdateProductUnitsCostWarning(
      index: index,
      factory: int.tryParse(productUnits[index].factoryController?.text ?? '0') ?? 0,
      myCost: double.tryParse(productUnits[index].costPriceController?.text ?? '0') ?? 0,
    ));
  }

  emit(UpdateProductUnitsCost());
}



void updateUnitPrices(int index) {
  int factor = int.tryParse(productUnits[index].factoryController?.text ?? '1') ?? 1;

  double newCost = baseCost * factor;
  double newMinWithoutTax = baseMinPriceWithoutTax * factor;
  double newSaleWithoutTax = baseSalePriceWithoutTax * factor;
  double newMinWithTax = newMinWithoutTax*factor;
  double newSaleWithTax = newSaleWithoutTax*factor;

  if (taxes != null) {
    double percentage = double.tryParse(taxes!.percentage ?? '') ?? 0;

    if (percentage > 0) {
      newMinWithTax = newMinWithoutTax + (newMinWithoutTax * percentage / 100);
      newSaleWithTax = newSaleWithoutTax + (newSaleWithoutTax * percentage / 100);
    }
  }


  productUnits[index].costPriceController?.text = newCost.toStringAsFixed(2);
  productUnits[index].minPriceWithoutTaxController?.text = newMinWithoutTax.toStringAsFixed(2);
  productUnits[index].minPriceWithTaxController?.text = newMinWithTax.toStringAsFixed(2);
  productUnits[index].salePriceWithoutTaxController?.text = newSaleWithoutTax.toStringAsFixed(2);
  productUnits[index].salePriceWithTaxController?.text = newSaleWithTax.toStringAsFixed(2);

  emit(AddProductChangeUnit());
}


  void _changeMinAndCostWithTaxes() {
    for (int i = 0; i < productUnits.length; i++) {
      changeMinPriceWithoutTaxes(productUnits[i]);
      changeSalePriceWithoutTax(productUnits[i]);
    }
  }

  String formatForUI(String value) {
    try {
      return double.parse(value).toStringAsFixed(2);
    } catch (_) {
      return value;
    }
  }

  void changeMinPriceWithoutTaxes(
    ProductUnits productUnits,
  ) {
    if (taxes != null) {
      double value = (double.tryParse(
              productUnits.minPriceWithoutTaxController?.text ?? '') ??
          0);
      if (value != 0) {
        double taxesPercentage =
            (double.tryParse(taxes!.percentage ?? '') ?? 0);
        if (taxesPercentage != 0) {
          double taxesValue = value * (taxesPercentage / 100);
          productUnits.minPriceWithTaxController?.text =
              (value + taxesValue).toString();
          debugPrint(" \n ******* taxesValue : $taxesValue *************** \n");
          debugPrint(
              " \n ******* minPriceWithTax : ${productUnits.minPriceWithTaxController?.text} *************** \n");
        }
      }
    } else {
      productUnits.minPriceWithTaxController?.text =
          productUnits.minPriceWithoutTaxController?.text ?? '';
    }
    emit(UpdateProductUnitsMinPrice());
  }

  void changeMinPriceWithTaxes(
    ProductUnits productUnits,
  ) {
    if (taxes != null) {
      double value = (double.tryParse(
              productUnits.minPriceWithTaxController?.text ?? '') ??
          0);
      if (value != 0) {
        double taxesPercentage =
            (double.tryParse(taxes!.percentage ?? '') ?? 0);
        if (taxesPercentage != 0) {
          double valueWithoutTax = (value / (1 + (taxesPercentage / 100)));
          productUnits.minPriceWithoutTaxController?.text =
              valueWithoutTax.toString();
          // debugPrint(" \n ******* taxesValue : $taxesValue *************** \n");
          debugPrint(
              " \n ******* minPriceWithoutTaxController : ${productUnits.minPriceWithoutTaxController?.text} *************** \n");
        }
      }
    } else {
      productUnits.minPriceWithoutTaxController?.text =
          productUnits.minPriceWithTaxController?.text ?? '';
    }
    emit(UpdateProductUnitsMinPrice());
  }

  void changeSalePriceWithoutTax(
    ProductUnits productUnits,
  ) {
    if (taxes != null) {
      double value = (double.tryParse(
              productUnits.salePriceWithoutTaxController?.text ?? '') ??
          0);
      if (value != 0) {
        double taxesPercentage =
            (double.tryParse(taxes!.percentage ?? '') ?? 0);
        if (taxesPercentage != 0) {
          double taxesValue = value * (taxesPercentage / 100);
          productUnits.salePriceWithTaxController?.text =
              (value + taxesValue).toStringAsFixed(2);
        }
      }
    } else {
      productUnits.salePriceWithTaxController?.text =
          productUnits.salePriceWithoutTaxController?.text ?? '';
    }
    emit(UpdateProductUnitsSalesPrice());
  }

  void changeSalePriceWithTax(
    ProductUnits productUnits,
  ) {
    if (taxes != null) {
      double value = (double.tryParse(
              productUnits.salePriceWithTaxController?.text ?? '') ??
          0);
      if (value != 0) {
        double taxesPercentage =
            (double.tryParse(taxes!.percentage ?? '') ?? 0);
        if (taxesPercentage != 0) {
          double valueWithoutTax = (value / (1 + (taxesPercentage / 100)));
          productUnits.salePriceWithoutTaxController?.text =
              valueWithoutTax.toStringAsFixed(2);
        }
      }
    } else {
      productUnits.salePriceWithoutTaxController?.text =
          productUnits.salePriceWithTaxController?.text ?? '';
    }
    emit(UpdateProductUnitsSalesPrice());
  }

  @override
  Future<void> close() {
    nameController.dispose();
    descriptionController.dispose();
    // pricePerUnitController.dispose();
    brandController.dispose();
    return super.close();
  }
}
