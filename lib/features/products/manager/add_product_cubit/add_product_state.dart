part of 'add_product_cubit.dart';

@immutable
sealed class AddProductState {}

final class AddProductInitial extends AddProductState {}

final class AddProductLoading extends AddProductState {}

final class AddProductSuccess extends AddProductState {
  final ProductModel? product;
  AddProductSuccess({required this.product});
}
final class AddProductInitialized extends AddProductState {}
final class AddProductFailing extends AddProductState {
  final ApiResponse errMessage;
  AddProductFailing({required this.errMessage});
}

final class AddProductUnValidate extends AddProductState {}

final class AddChangeCategory extends AddProductState {}

final class AddChangeTaxes extends AddProductState {}

final class AddChangProductType extends AddProductState {}

final class AddProductAddUnit extends AddProductState {}
final class AddProductRemoveUnit extends AddProductState {}
final class AddProductChangeUnit extends AddProductState {}
final class AddProductAssignBranchQty extends AddProductState {}
final class AddProductOnPriceChange extends AddProductState {}





final class UpdateProductUnitsCost extends AddProductState {}

final class UpdateProductUnitsCostWarning extends AddProductState {
  final int factory;
  final double myCost;
  final int index;

  UpdateProductUnitsCostWarning(
      {required this.factory, required this.myCost, required this.index});
}

final class UpdateProductUnitsMinPrice extends AddProductState {}

final class UpdateProductUnitsSalesPrice extends AddProductState {}
final class GetAllUnitsSuccess extends AddProductState {}
final class GetAllUnitsFailing extends AddProductState {
  final ApiResponse errMessage;
  GetAllUnitsFailing({required this.errMessage});
}
