import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/features/auth/login/data/model/branche_model.dart';
import 'package:pos_app/features/categories/data/model/category_model.dart';
import 'package:pos_app/features/products/data/model/product_model.dart';
import 'package:pos_app/features/products/data/model/product_type.dart';
import 'package:pos_app/features/products/data/repo/products_repo.dart';
import 'package:pos_app/features/taxes/data/model/taxes_model.dart';
import 'package:pos_app/features/units/data/model/unit_model.dart';

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
  UnitModel? unit;
  BrancheModel? branch;
  TaxesModel? taxes;
  ProductType? productType;

  final TextEditingController barCodeController = TextEditingController();
  final TextEditingController brandController = TextEditingController();
  final TextEditingController openingQuantityController =
      TextEditingController();

  Future<void> addProduct() async {
    emit(AddProductLoading());
    if (formKey.currentState!.validate()) {
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

  void onSubmitInitalQunatity(String? value) {
    if (value == null || value.isEmpty) {
      branch = null;
    }
    emit(AddProductAddInitialQunantity());
  }

  void onChangeCategory(CategoryModel? newCategory) {
    if (category?.id != newCategory?.id) {
      category = newCategory;
      emit(AddChangeCategory());
    }
  }

  void onChangeUnit(UnitModel? newUnit) {
    if (unit?.id != newUnit?.id) {
      unit = newUnit;
      emit(AddChangeUnit());
    }
  }

  void onChangeBranch(BrancheModel? newBranch) {
    if (branch?.id != newBranch?.id) {
      branch = newBranch;
      emit(AddChangeBranch());
    }
  }

  void onChangeTaxes(TaxesModel? newTaxes) {
    if (taxes?.id != newTaxes?.id) {
      taxes = newTaxes;
      emit(AddChangeTaxes());
    }
  }

  void onChangeProductType(ProductType? newProductType) {
    if (productType?.id != newProductType?.id) {
      if (newProductType?.id == 2) {
        openingQuantityController.text = "";
        branch = null;
      }
      productType = newProductType;
      emit(AddChangProductType());
    }
  }

  @override
  Future<void> close() {
    nameController.dispose();
    descriptionController.dispose();
    pricePerUnitController.dispose();
    openingQuantityController.dispose();
    barCodeController.dispose();
    brandController.dispose();
    return super.close();
  }
}
