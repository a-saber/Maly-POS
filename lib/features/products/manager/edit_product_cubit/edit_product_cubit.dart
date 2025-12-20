import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pos_app/core/constant/constant.dart';
import 'package:pos_app/core/helper/calc_helper.dart';
import 'package:pos_app/core/helper/my_service_locator.dart';
import 'package:pos_app/features/auth/login/data/model/branche_model.dart';
import 'package:pos_app/features/categories/data/model/category_model.dart';
import 'package:pos_app/features/products/data/model/product_model.dart';
import 'package:pos_app/features/products/data/model/product_type.dart';
import 'package:pos_app/features/products/data/model/update_product_model.dart';
import 'package:pos_app/features/products/data/repo/products_repo.dart';
import 'package:pos_app/features/selling_point/manager/selling_point_cubit/selling_point_cubit.dart';
import 'package:pos_app/features/selling_point/manager/selling_point_product_cubit/selling_point_product_cubit.dart';
import 'package:pos_app/features/taxes/data/model/taxes_model.dart';
import 'package:pos_app/features/units/data/model/unit_model.dart';
import 'package:pos_app/features/units/data/repo/units_repo.dart';
import 'package:pos_app/features/categories/data/repo/category_repo.dart';

import '../get_all_products_cubit/get_all_products_cubit.dart';

part 'edit_product_state.dart';

class EditProductCubit extends Cubit<EditProductState> {
  EditProductCubit({
    required this.repo,
    required this.product,
    required this.unitsRepo,
    required this.categoryRepo,
  }) : super(EditProductInitial()) {
    baseUnitId = product.baseUnitId ?? product.unit?.id ?? 1;
    isavailable = product.isAvailableBool ? 1 : 0;
    _initControllers();
  }

  static EditProductCubit get(context) => BlocProvider.of(context);

  final ProductsRepo repo;
  final UnitsRepo unitsRepo;
  final CategoryRepo categoryRepo;
  final ProductModel product;

  late int baseUnitId;
  TaxesModel? taxes;
  ProductType? productType;
  CategoryModel? category;
  UnitModel? unit;
  BrancheModel? branch;
  XFile? image;
  late int isavailable;
  GlobalKey<FormState> formKey = GlobalKey();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController pricePerUnitController;
  late TextEditingController barCodeController;
  late TextEditingController brandController;
  late TextEditingController openingQuantityController;
  List<TaxesModel> taxesList = [];
  List<ProductUnits> productUnits = [];

  double baseCost = 0;
  double baseMinPriceWithoutTax = 0;
  double baseMinPriceWithTax = 0;
  double baseSalePriceWithoutTax = 0;
  double baseSalePriceWithTax = 0;

  void _initControllers() {
    nameController = TextEditingController(text: product.name);
    descriptionController = TextEditingController(text: product.description);
    pricePerUnitController = TextEditingController(text: product.price);
    barCodeController = TextEditingController(text: product.barcode);
    brandController = TextEditingController(text: product.brand);
    openingQuantityController = TextEditingController();
    emit(EditProductOnPriceChange());
  }

  void onChangeAvailability(bool value) {
    isavailable = value ? 1 : 0;
    emit(AddProductChangeAvailability());
  }

  void init({required BuildContext context}) async {
    emit(EditProductInitializing());

    if (product.taxId != null && product.taxId! > 0) {
      taxes = product.tax;
    } else {
      taxes = product.tax;
    }

    if (product.categoryId != null && product.categoryId! > 0) {
      await getCategory(context: context);
    } else {
      category = product.category;
    }

    if (product.baseUnitId != null && product.baseUnitId! > 0) {
      await getUnits(context: context);
    } else {
      unit = product.unit;
    }

    productType = AppConstant.producttype(context).firstWhere(
      (element) =>
          element.value.toLowerCase().trim() ==
          product.type?.toLowerCase().trim(),
      orElse: () => AppConstant.producttype(context).first,
    );

    if (productType?.id == 2) {
      openingQuantityController.text = '';
      branch = null;
    }

    if (product.productUnits != null) {
      for (int i = 0; i < product.productUnits!.length; i++) {
        var pUnit = product.productUnits![i];
        for (var bq in pUnit.branchQty) {
          bq.quantityController = TextEditingController(
            text: (bq.qunantity ?? 0).toString(),
          );
        }
      }
    }

    _initProductUnitsFromProduct();

    emit(EditProductInitialized());
  }

  Future<void> getUnits({required BuildContext context}) async {
    final unitIdToFetch = product.baseUnitId ?? product.unit?.id;

    if (unitIdToFetch == null) {
      return;
    }

    final result = await unitsRepo.getSpecificUnit(id: unitIdToFetch);

    result.fold((l) {}, (r) {
      unit = r;
    });
  }

  void assignBranchQty(
      {required index, required List<BranchQuantity> branchQuantities}) {
    productUnits[index].branchQty = List.from(branchQuantities);
    emit(EditProductAssignBranchQty());
  }

  Future<void> getCategory({required BuildContext context}) async {
    if (product.category != null) {
      category = product.category;
      return;
    }

    if (product.categoryId == null) {
      return;
    }

    final result = await categoryRepo.getSpecificCategory(id: product.categoryId!);

    result.fold((l) {}, (r) {
      category = r;
    });
  }

Future<void> editProduct(BuildContext context) async {
  emit(EditProductLoading());

  if (formKey.currentState?.validate() != true) {
    autovalidateMode = AutovalidateMode.always;
    emit(EditProductUnValid());
    return;
  }

  for (var u in productUnits) {
    u.costPrice = u.costPriceController?.text;
//    u.minPriceWithoutTax = u.minPriceWithoutTaxController?.text;
  //  u.minPriceWithTax = u.minPriceWithTaxController?.text;
   /* u.salePriceWithoutTax = u.salePriceWithoutTaxController?.text;
    u.salePriceWithTax = u.salePriceWithTaxController?.text;*/
    print("u.minPriceWithoutTax ${u.minPriceWithoutTax.toString()}");
    u.barcode = u.barCodeController?.text;
    isavailable = product.isavailable ?? 1;
    u.scaleBarcode = u.scaleBarcodeController?.text;
    for (var bq in u.branchQty) {
      bq.branchId = bq.branchId ?? bq.branch?.id;
      bq.qunantity = int.tryParse(bq.quantityController.text) ?? 0;
    }
  }

  UpdateProductModel updateProductModel = UpdateProductModel.createWithoutId(
    id: product.id,
    unit: unit,
    productUnits: productUnits,
    name: nameController.text,
    description: descriptionController.text,
    category: category,
    image: image == null ? null : File(image!.path),
    price: pricePerUnitController.text,
    brand: brandController.text,
    tax: taxes,
    type: productType?.value ?? product.type ?? 'inventory',
    isavailable: isavailable,
  );
  
  if (productUnits.isNotEmpty) {
    productUnits[0].unitId = unit?.id ?? baseUnitId;
  }
  updateProductModel.baseUnitId = unit?.id ?? baseUnitId;
  
  final response = await repo.addUpdateProduct(
      updateProduct: updateProductModel, isUpdate: true);

  response.fold(
    (error) => emit(EditProductFailing(errMessage: error.message!)),
    (productFromApi) {
      if (productFromApi != null) {
        final updatedProduct = ProductModel(
          id: productFromApi.id,
          name: productFromApi.name,
          categoryId: productFromApi.categoryId,
          category: category,
          baseUnitId: productFromApi.baseUnitId,
          unit: unit,
          description: productFromApi.description,
          imagePath: productFromApi.imagePath,
          barcode: productFromApi.barcode,
          brand: productFromApi.brand,
          price: productFromApi.price,
          createdAt: productFromApi.createdAt,
          updatedAt: productFromApi.updatedAt,
          imageUrl: productFromApi.imageUrl,
          tax: taxes,
          isavailable: productFromApi.isavailable,
          taxId: productFromApi.taxId,
          priceAfterTax: productFromApi.priceAfterTax,
          type: productFromApi.type,
          quantity: productFromApi.quantity,
          productUnits: productFromApi.productUnits,
        );

        emit(EditProductSuccess(product: updatedProduct));


        GetAllProductsCubit.get(context).updateProduct(updatedProduct);

        try {
          final sellingPointCubit = MyServiceLocator.getSingleton<SellingPointProductCubit>();
          final sellingPointCubitproduct = MyServiceLocator.getSingleton<SellingPointCubit>();

          if (updatedProduct.isavailable == 0) {
            sellingPointCubit.deleteProduct(updatedProduct);

            sellingPointCubit.emit(SellingPointProductDeleteProduct());
            debugPrint(' Removed unavailable product from selling point');
          } else {

            sellingPointCubit.updateProduct(updatedProduct);
            sellingPointCubitproduct.updateProducts( updatedProduct);

            sellingPointCubit.emit(SellingPointProductUpdateProduct());
            debugPrint(' Updated available product in selling point');
          }
        } catch (e) {
          debugPrint(' Selling point not active: $e');
        }

      } else {
        emit(EditProductFailing(errMessage: "فشل تحديث المنتج"));
      }
    },
  );
}

  void addProductUnits() {
    final newUnit = ProductUnits.empty();
    newUnit.id = null;
    productUnits.add(newUnit);

    if (productUnits.length == 1) {
      productUnits[0].factoryController!.text = '1';
    } else {
      int currentIndex = productUnits.length - 1;
      productUnits[currentIndex].factoryController!.text = '1';

      if (productUnits.isNotEmpty) {
        baseCost =
            double.tryParse(productUnits[0].costPriceController?.text ?? '0') ??
                0;
        baseMinPriceWithoutTax = double.tryParse(productUnits[0].minPriceWithoutTaxController?.text ?? '0') ??
            0;
        baseSalePriceWithoutTax = double.tryParse(
                productUnits[0].salePriceWithoutTaxController?.text ?? '0') ??
            0;

        productUnits[0].minPriceWithoutTax =
            baseMinPriceWithoutTax.toString();
        productUnits[0].salePriceWithoutTax =
            baseSalePriceWithoutTax.toString();
      }

      updateUnitPrices(currentIndex);
    }

    emit(EditProductAddUnit());
    emit(EditProductUnitsUpdated());
  }

  void removeNewUnit(int index) {
    if (productUnits[index].id == null) {
      productUnits.removeAt(index);
      emit(EditProductUnitsUpdated());
    }
  }

  void onChangeCost(int index) {
    if (productUnits.isEmpty) return;

  if (index == 0) {
    baseCost = double.tryParse(productUnits[0].costPriceController?.text ?? '0') ?? 0;
    baseMinPriceWithoutTax = double.tryParse(productUnits[0].minPriceWithoutTaxController?.text ?? '') ?? baseCost;
    baseMinPriceWithTax = double.tryParse(productUnits[0].minPriceWithTaxController?.text ?? '') ?? baseMinPriceWithoutTax;
    baseSalePriceWithoutTax = double.tryParse(productUnits[0].salePriceWithoutTaxController?.text ?? '0') ?? 0;
    baseSalePriceWithTax = double.tryParse(productUnits[0].salePriceWithTaxController?.text ?? '0') ??0;
    productUnits[0].salePriceWithoutTax = baseSalePriceWithoutTax.toString();
     productUnits[0].minPriceWithoutTax = baseMinPriceWithoutTax.toString();
    print("minPriceWithoutTax ${baseMinPriceWithoutTax.toString()}");
      for (int i = 1; i < productUnits.length; i++) {
        updateUnitPrices(i);
      }
    } else {
      emit(UpdateProductUnitsCostWarning(
        index: index,
        factory:
            int.tryParse(productUnits[index].factoryController?.text ?? '0') ??
                0,
        myCost: double.tryParse(
                productUnits[index].costPriceController?.text ?? '0') ??
            0,
      ));
    }

    emit(UpdateProductUnitsCost());
  }

  void onUnitChangedd({required UnitModel unitModel, required int index}) {
    productUnits[index].unit = unitModel;
    productUnits[index].unitId = unitModel.id;

    if (index != 0) {
      updateUnitPrices(index);
    }

    emit(EditProductChangeUnit());
  }

  void updateUnitPrices(int index) {
    int factor =
        int.tryParse(productUnits[index].factoryController?.text ?? '1') ?? 1;
    if (factor == 0) factor = 1;
    double newCost = baseCost * factor;
    double newMinWithoutTax = (double.tryParse(productUnits.first.minPriceWithoutTax ?? '0') ?? 0) * factor;
    double newSaleWithoutTax = (double.tryParse(productUnits.first.salePriceWithoutTax ?? '0') ?? 0) * factor;

    double newMinWithTax = newMinWithoutTax;
    double newSaleWithTax = newSaleWithoutTax;

    if (taxes != null) {
      double percentage = double.tryParse(taxes!.percentage ?? '') ?? 0;

      if (percentage > 0) {
        newMinWithTax =
            newMinWithoutTax + (newMinWithoutTax * percentage / 100);
        newSaleWithTax =
            newSaleWithoutTax + (newSaleWithoutTax * percentage / 100);
      }
    }
    productUnits[index].costPriceController?.text = newCost.toStringAsFixed(2);
    productUnits[index].minPriceWithoutTaxController?.text = newMinWithoutTax.toStringAsFixed(2);
    productUnits[index].minPriceWithTaxController?.text = newMinWithTax.toStringAsFixed(2);
    productUnits[index].salePriceWithoutTaxController?.text = newSaleWithoutTax.toStringAsFixed(2);
    productUnits[index].salePriceWithTaxController?.text = newSaleWithTax.toStringAsFixed(2);

    productUnits[index].minPriceWithoutTax = newMinWithoutTax.toString();
    productUnits[index].salePriceWithoutTax = newSaleWithoutTax.toString();


    emit(EditProductChangeUnit());
  }

  void _initProductUnitsFromProduct() {
    productUnits.clear();
    if (product.productUnits != null && product.productUnits!.isNotEmpty) {
      for (var apiUnit in product.productUnits!) {
        final productUnit = ProductUnits.empty();
        productUnit.id = apiUnit.id;
        productUnit.unit = apiUnit.unit;
        productUnit.unitId = apiUnit.unitId;

        double factor = double.tryParse(apiUnit.conversionFactor ?? "1") ?? 1;
        productUnit.factoryController?.text =
            factor % 1 == 0 ? factor.toStringAsFixed(0) : factor.toString();

        double costPrice = double.tryParse(apiUnit.costPrice ?? '0') ?? 0;
        double minPriceWithoutTax =
            double.tryParse(apiUnit.minPriceWithoutTax ?? '0') ?? 0;
        double minPriceWithTax =
            double.tryParse(apiUnit.minPriceWithTax ?? '0') ?? 0;
        double salePriceWithoutTax =
            double.tryParse(apiUnit.salePriceWithoutTax ?? '0') ?? 0;
        double salePriceWithTax =
            double.tryParse(apiUnit.salePriceWithTax ?? '0') ?? 0;

        productUnit.costPriceController?.text = costPrice.toStringAsFixed(1);
        productUnit.minPriceWithoutTaxController?.text = minPriceWithoutTax.toStringAsFixed(1);
        productUnit.minPriceWithTaxController?.text =
            minPriceWithTax.toStringAsFixed(1);
        productUnit.salePriceWithoutTaxController?.text =
            salePriceWithoutTax.toStringAsFixed(1);
        productUnit.salePriceWithTaxController?.text =
            salePriceWithTax.toStringAsFixed(1);
        productUnit.minPriceWithoutTax = apiUnit.minPriceWithoutTax;
        productUnit.minPriceWithTax = apiUnit.minPriceWithTax ?? '0';
        productUnit.salePriceWithoutTax = apiUnit.salePriceWithoutTax ?? '0';
        productUnit.salePriceWithTax = apiUnit.salePriceWithTax ?? '0';
        productUnit.costPrice = apiUnit.costPrice ?? '0';
        productUnit.conversionFactor = apiUnit.conversionFactor ?? '1';

        productUnit.barCodeController?.text = apiUnit.barcode ?? "";
        productUnit.scaleBarcodeController?.text = apiUnit.scaleBarcode ?? "";

        if (apiUnit.branchQty.isNotEmpty) {
          productUnit.branchQty = apiUnit.branchQty.map((bq) {
            return BranchQuantity(
              branch: bq.branch,
              branchId: bq.branchId,
              qunantity: bq.qunantity,
              quantityController: TextEditingController(
                text: (bq.qunantity ?? 0).toString(),
              ),
            );
          }).toList();
        }

        productUnits.add(productUnit);
      }

      if (productUnits.isNotEmpty) {
        baseCost =
            double.tryParse(productUnits[0].costPriceController?.text ?? '0') ??
                0;
        baseMinPriceWithoutTax = double.tryParse(
                productUnits[0].minPriceWithoutTaxController?.text ?? '0') ??
            0;
        baseMinPriceWithTax = double.tryParse(
                productUnits[0].minPriceWithTaxController?.text ?? '0') ??
            0;
        baseSalePriceWithoutTax = double.tryParse(
                productUnits[0].salePriceWithoutTaxController?.text ?? '0') ??
            0;
        baseSalePriceWithTax = double.tryParse(
                productUnits[0].salePriceWithTaxController?.text ?? '0') ??
            0;
      }
    } else {
      final baseUnit = ProductUnits.empty();
      baseUnit.unitId = unit?.id ?? product.baseUnitId;
      baseUnit.unit = unit;
      baseUnit.unitId = unit?.id ?? product.baseUnitId;
      baseUnit.conversionFactor = "1";
      baseUnit.factoryController?.text = "1";

      double basePrice = double.tryParse(product.price ?? "0") ?? 0;

      baseUnit.costPriceController?.text = basePrice.toStringAsFixed(2);
      baseUnit.minPriceWithoutTaxController?.text = basePrice.toStringAsFixed(2);

      double priceWithTax = basePrice;
      if (product.tax != null) {
        double taxPercent =
            double.tryParse(product.tax!.percentage ?? "0") ?? 0;
        priceWithTax = basePrice + (basePrice * taxPercent / 100);
      }

      baseUnit.minPriceWithTaxController?.text = priceWithTax.toStringAsFixed(2);
      baseUnit.salePriceWithoutTaxController?.text = basePrice.toStringAsFixed(2);
      baseUnit.salePriceWithTaxController?.text = priceWithTax.toStringAsFixed(2);

      baseUnit.barCodeController?.text = product.barcode ?? "";
      baseUnit.scaleBarcodeController?.text = "";

      productUnits.add(baseUnit);

      baseCost = basePrice;
      baseMinPriceWithoutTax = basePrice;
      baseSalePriceWithoutTax = basePrice;
      baseMinPriceWithTax = priceWithTax;
      baseSalePriceWithTax = priceWithTax;
    }

    for (int i = 0; i < productUnits.length; i++) {
      onChangeMinPriceWithoutTax(
        index: i,
        newValue: productUnits[i].minPriceWithoutTaxController!.text,
      );
      double value =
          double.tryParse(productUnits[i].minPriceWithTaxController!.text) ?? 0;
      productUnits[i].minPriceWithTaxController!.text =
          value.toStringAsFixed(2);
    }
  }

  void onChangeMinPriceWithoutTax(
      {required int index, required String newValue}) {
    if (newValue.isEmpty) {
      productUnits[index].minPriceWithTaxController?.text = "0";
      emit(EditProductOnPriceChange());
      return;
    }

    try {
      productUnits[index].minPriceWithoutTax = newValue;
      Decimal newValueDecimal = Decimal.parse(newValue);
      String percentageStr = taxes?.percentage ?? "0";
      Decimal percentageDecimal = Decimal.parse(percentageStr);
      Decimal percentFraction = DecimalHelper.divide(percentageDecimal.toString(), "100");
      Decimal onePlusFraction = DecimalHelper.add("1", percentFraction.toString());
      Decimal afterTax = DecimalHelper.multiply(newValueDecimal.toString(), onePlusFraction.toString());
      productUnits[index].minPriceWithTaxController?.text = decimalToStringForUI(afterTax);
      productUnits[index].minPriceWithTax = double.tryParse(afterTax.toString())?.toString() ?? "0";
    } catch (_) {
      productUnits[index].minPriceWithTaxController?.text = "0";
    }

    emit(EditProductOnPriceChange());
  }

  void onChangeMinPriceWithTax({required int index, required String newValue}) {
    if (newValue.isEmpty) {
      productUnits[index].minPriceWithoutTaxController?.text = "0";
      emit(EditProductOnPriceChange());
      return;
    }

    try {
      productUnits[index].minPriceWithTax = newValue;
      Decimal valueWithTax = Decimal.parse(newValue);
      String percentageStr = taxes?.percentage ?? "0";
      Decimal percentageDecimal = Decimal.parse(percentageStr);

      Decimal percentFraction =
          DecimalHelper.divide(percentageDecimal.toString(), "100");
      Decimal onePlusFraction = DecimalHelper.add("1", percentFraction.toString());

      Decimal beforeTax = DecimalHelper.divide(valueWithTax.toString(), onePlusFraction.toString());

      productUnits[index].minPriceWithoutTaxController?.text = decimalToStringForUI(beforeTax);
      productUnits[index].minPriceWithoutTax = double.tryParse(beforeTax.toString())?.toString() ?? "0";
    } catch (_) {
      productUnits[index].minPriceWithoutTaxController?.text = "0";
    }

    emit(EditProductOnPriceChange());
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
      for (int i = 0; i < productUnits.length; i++) {
        onChangeMinPriceWithoutTax(
            index: i,
            newValue: productUnits[i].minPriceWithoutTaxController!.text);
      }
      emit(EditChangeTaxes());
    }
  }

  void onChangeProductType(ProductType? newProductType) {
    if (productType?.id != newProductType?.id) {
      if (newProductType?.id == 2) {
        openingQuantityController.text = '';
        branch = null;
      }
      productType = newProductType;
      emit(EditChangeProductType());
    }
  }

  void onChangeSalePrice(int index) {
    if (taxes != null) {
      double value = (double.tryParse(productUnits[index].salePriceWithoutTaxController?.text ?? '') ?? 0);
      productUnits[index].salePriceWithoutTax= productUnits[index].salePriceWithoutTaxController?.text;

      if (value != 0) {
        double taxesPercentage =
            (double.tryParse(taxes!.percentage ?? '') ?? 0);
        if (taxesPercentage != 0) {
          double taxesValue = value * (taxesPercentage / 100);
          productUnits[index].salePriceWithTaxController?.text = (value + taxesValue).toStringAsFixed(2);
          productUnits[index].salePriceWithTax = (value + taxesValue).toString();
        }
      }
    } else {
      productUnits[index].salePriceWithTaxController?.text = productUnits[index].salePriceWithoutTaxController?.text ?? '';
      productUnits[index].salePriceWithTax=productUnits[index].salePriceWithoutTaxController?.text ?? '';
    }
    emit(EditProductOnPriceChange());
  }

  void changeSalePriceWithTax(int index) {
    if (taxes != null) {
      double value = (double.tryParse(productUnits[index].salePriceWithTaxController?.text ?? '') ??0);
      if (value != 0) {
        double taxesPercentage = (double.tryParse(taxes!.percentage ?? '') ?? 0);
        if (taxesPercentage != 0) {
          double valueWithoutTax = (value / (1 + (taxesPercentage / 100)));
          productUnits[index].salePriceWithoutTaxController?.text = valueWithoutTax.toStringAsFixed(2);
          productUnits[index].salePriceWithoutTax = valueWithoutTax.toString();
        }
      }
    } else {
      productUnits[index].salePriceWithoutTaxController?.text =
          productUnits[index].salePriceWithTaxController?.text ?? '';
    }
    emit(EditProductOnPriceChange());
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