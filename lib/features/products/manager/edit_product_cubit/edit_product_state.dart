part of 'edit_product_cubit.dart';

@immutable
abstract class EditProductState {}

class EditProductInitial extends EditProductState {}

class EditProductLoading extends EditProductState {}

class EditProductSuccess extends EditProductState {
  final ProductModel product;
  EditProductSuccess({required this.product});
}

class EditProductFailing extends EditProductState {
  final String errMessage;
  EditProductFailing({required this.errMessage});
}

class EditProductUnValid extends EditProductState {}

class GetCategorySuccess extends EditProductState {}

class GetUnitsSuccess extends EditProductState {}

// ===== UNIT LOGIC =====
class EditProductAddUnit extends EditProductState {}

class EditProductRemoveUnit extends EditProductState {}

class EditProductChangeUnit extends EditProductState {}

class UpdateProductUnitsCost extends EditProductState {}

class UpdateProductUnitsCostWarning extends EditProductState {
  final int index;
  final int factory;
  final double myCost;

  UpdateProductUnitsCostWarning({
    required this.index,
    required this.factory,
    required this.myCost,
  });
}

class EditProductOnPriceChange extends EditProductState {}

// ===== CATEGORY / UNIT / TAXES / PRODUCT TYPE CHANGES =====
class EditChangeCategory extends EditProductState {}

class EditChangeUnit extends EditProductState {}

class EditChangeBranch extends EditProductState {}

class EditChangeTaxes extends EditProductState {}

class EditChangeProductType extends EditProductState {}
class EditProductInitializing extends EditProductState {}
class EditProductInitialized extends EditProductState {}
class EditProductAssignBranchQty extends EditProductState {}