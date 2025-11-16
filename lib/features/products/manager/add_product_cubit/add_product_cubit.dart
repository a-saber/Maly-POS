import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/features/categories/data/model/category_model.dart';
import 'package:pos_app/features/products/data/model/product_model.dart';
import 'package:pos_app/features/products/data/model/product_type.dart';
import 'package:pos_app/features/products/data/model/update_product_model.dart';
import 'package:pos_app/features/products/data/repo/products_repo.dart';
import 'package:pos_app/features/taxes/data/model/taxes_model.dart';

part 'add_product_state.dart';

class AddProductCubit extends Cubit<AddProductState> {
  AddProductCubit(this.repo) : super(AddProductInitial());
  static AddProductCubit get(context) => BlocProvider.of(context);
  final ProductsRepo repo;
  GlobalKey<FormState> formKey = GlobalKey();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController pricePerUnitController = TextEditingController();

  XFile? image;
  CategoryModel? category;
  // UnitModel? unit;
  // BrancheModel? branch;
  TaxesModel? taxes;
  ProductType? productType;

  // final TextEditingController barCodeController = TextEditingController();
  final TextEditingController brandController = TextEditingController();
  // final TextEditingController openingQuantityController =
  //     TextEditingController();

  List<ProductUnits> productUnits = [];
  List<List<BranchQuantity>> branchQuantities = [];

  Future<void> addProduct() async {
    emit(AddProductLoading());
    for (var element in branchQuantities) {
      for (var element2 in element) {
        debugPrint("print branch quantity ${element2.quantityController.text}");
      }
    }
    if (formKey.currentState!.validate()) {
      if (productType?.id == 2) {
        branchQuantities = [];
      }
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
        branchQuantities: branchQuantities,
      );
      response.fold(
        (error) => emit(AddProductFailing(errMessage: error)),
        (r) => emit(AddProductSuccess(
          product: r,
        )),
      );
      // TODO : Add Product
      // var reponse = await repo.addProduct(
      //   unit: ,
      //   openingquantity: openingQuantityController.text.trim(),
      //   branch: branch,
      //   product: ProductModel.createWithoutId(
      //     name: nameController.text,
      //     description: descriptionController.text,
      //     category: category,
      //     unit: unit,
      //     image: image == null ? null : File(image!.path),
      //     price: pricePerUnitController.text,
      //     barcode: barCodeController.text,
      //     brand: brandController.text,
      //     tax: taxes,
      //     type: productType?.value,
      //   ),
      // );
      // reponse.fold(
      //   (error) => emit(AddProductFailing(errMessage: error)),
      //   (r) => emit(AddProductSuccess(
      //     product: r,
      //   )),
      // );
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

  void onChangeTaxes(TaxesModel? newTaxes) {
    if (taxes?.id != newTaxes?.id) {
      taxes = newTaxes;

      emit(AddChangeTaxes());
    }

    _changeMinAndCostWithTaxes();
  }

  void onChangeProductType(ProductType? newProductType) {
    if (productType?.id != newProductType?.id) {
      productType = newProductType;
      emit(AddChangProductType());
    }
  }

  void addProductUnits() {
    productUnits.add(
      ProductUnits.empty(),
    );

    if (productUnits.length == 1) {
      productUnits[0].factoryController!.text = '1';
    }

    baseCost = productUnits[0].costPriceController!.text.isNotEmpty
        ? double.tryParse(productUnits[0].costPriceController!.text) ?? 0
        : 0;

    branchQuantities.add([]);

    emit(AddProductUnits());
  }

  double baseCost = 0;

  void onChangeCost(int index, {bool changeCostToAll = false, double? cost}) {
    if ((index == 0 || changeCostToAll) && productUnits.isNotEmpty) {
      baseCost = double.tryParse(
              productUnits[index].costPriceController?.text ?? '') ??
          0;

      if (changeCostToAll && cost != null) {
        baseCost = cost;
        productUnits[0].costPriceController?.text = cost.toString();
      }

      debugPrint(" \n ******* baseCost : $baseCost *************** \n");

      for (int i = 1; i < productUnits.length; i++) {
        double value =
            (int.tryParse(productUnits[i].factoryController?.text ?? '') ?? 0) *
                (baseCost);
        productUnits[i].costPriceController?.text = value.toString();
      }

      emit(UpdateProductUnitsCost());
    } else {
      emit(UpdateProductUnitsCostWarning(
        index: index,
        factory:
            (int.tryParse(productUnits[index].factoryController?.text ?? '') ??
                0),
        myCost: (double.tryParse(
                productUnits[index].costPriceController?.text ?? '') ??
            0),
      ));
    }
  }

  void _changeMinAndCostWithTaxes() {
    for (int i = 0; i < productUnits.length; i++) {
      changeMinPriceWithoutTaxes(productUnits[i]);
      changeSalePriceWithoutTax(productUnits[i]);
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
              (value + taxesValue).toString();
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
              valueWithoutTax.toString();
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
    pricePerUnitController.dispose();
    brandController.dispose();
    return super.close();
  }
}
