import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/core/constant/constant.dart';
import 'package:pos_app/features/auth/login/data/model/branche_model.dart';
import 'package:pos_app/features/categories/data/model/category_model.dart';
import 'package:pos_app/features/categories/data/repo/category_repo.dart';
import 'package:pos_app/features/products/data/model/product_model.dart';
import 'package:pos_app/features/products/data/model/product_type.dart';
import 'package:pos_app/features/products/data/repo/products_repo.dart';
import 'package:pos_app/features/taxes/data/model/taxes_model.dart';
import 'package:pos_app/features/units/data/model/unit_model.dart';
import 'package:pos_app/features/units/data/repo/units_repo.dart';

part 'edit_product_state.dart';

class EditProductCubit extends Cubit<EditProductState> {
  EditProductCubit({
    required this.repo,
    required this.product,
    // required BuildContext context,
    required this.unitsRepo,
    required this.categoryRepo,
  }) : super(EditProductInitial()) {
    nameController = TextEditingController(text: product.name);
    descriptionController = TextEditingController(text: product.description);
    pricePerUnitController = TextEditingController(text: product.price);
    barCodeController = TextEditingController(text: product.barcode);
    brandController = TextEditingController(text: product.brand);
    openingQuantityController = TextEditingController(text: '');

    taxes = product.tax;
  }

  void init({required BuildContext context}) {
    if (product.unit == null) {
      getUnits(context: context);
    } else {
      unit = product.unit;
    }
    productType = AppConstant.producttype(context).firstWhere((element) {
      return element.value.toLowerCase().trim() ==
          product.type?.toLowerCase().trim();
    });
    getCategory(context: context);
    getTaxesType(context: context);
  }

  void getTaxesType({
    required BuildContext context,
  }) async {
    if (product.tax != null) {
      productType = AppConstant.producttype(context).firstWhere((element) {
        return element.value.toLowerCase().trim() ==
            product.type?.toLowerCase().trim();
      });
      if (productType != null) {
        emit(GetTaxesTypeSuccess());
      }
    }
  }

  void getCategory({
    required BuildContext context,
  }) async {
    if (product.categoryId == null) return;

    var result =
        await categoryRepo.getSpecificCategory(id: product.categoryId!);

    result.fold((l) => null, (r) {
      category = r;
      emit(GetCategorySuccess());
    });
  }

  void getUnits({
    required BuildContext context,
  }) async {
    if (product.unitId == null) return;
    var result = await unitsRepo.getSpecificUnit(
      id: product.unitId!,
    );
    result.fold((l) => null, (r) {
      unit = r;
      emit(GetUnitsSuccess());
    });
  }

  static EditProductCubit get(context) => BlocProvider.of(context);

  final ProductsRepo repo;
  final UnitsRepo unitsRepo;
  final CategoryRepo categoryRepo;
  final ProductModel product;
  TaxesModel? taxes;
  ProductType? productType;

  GlobalKey<FormState> formKey = GlobalKey();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController pricePerUnitController;
  late TextEditingController barCodeController;
  late TextEditingController brandController;
  late TextEditingController openingQuantityController;
  XFile? image;

  CategoryModel? category;

  UnitModel? unit;

  BrancheModel? branch;

  Future<void> editProduct() async {
    emit(EditProductLoading());
    if (formKey.currentState!.validate()) {
      var reponse = await repo.editProduct(
        unit: unit!,
        openingquantity: openingQuantityController.text,
        branch: branch,
        product: ProductModel.createWithoutId(
          id: product.id,
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
        (error) => emit(EditProductFailing(errMessage: error)),
        (r) => emit(EditProductSuccess(
          product: r,
        )),
      );
    } else {
      autovalidateMode = AutovalidateMode.always;
      emit(EditProductUnValid());
    }
  }

  void onSubmitInitalQunatity(String? value) {
    if (value == null || value.isEmpty) {
      branch = null;
    }
    emit(EditProductAddInitialQunantity());
  }

  void onChangeCategory(CategoryModel? newCategory) {
    if (category?.id != newCategory?.id) {
      category = newCategory;
      emit(EditChangeCategory());
    }
  }

  void onChangeUnit(UnitModel? newUnit) {
    if (unit?.id != newUnit?.id) {
      unit = newUnit;
      emit(EditChangeUnit());
    }
  }

  void onChangeBranch(BrancheModel? newBranch) {
    if (branch?.id != newBranch?.id) {
      branch = newBranch;
      emit(EditChangeBranch());
    }
  }

  void onChangeTaxes(TaxesModel? newTaxes) {
    if (taxes?.id != newTaxes?.id) {
      taxes = newTaxes;
      emit(EditChangeTaxes());
    }
  }

  void onChangeProductType(ProductType? newProductType) {
    if (productType?.id != newProductType?.id) {
      if (newProductType?.id == 2) {
        openingQuantityController.text = "";
        branch = null;
      }
      newProductType = newProductType;
      productType = newProductType;
      emit(EditChangeProductType());
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
