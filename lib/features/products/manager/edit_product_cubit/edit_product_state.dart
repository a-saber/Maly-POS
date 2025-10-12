part of 'edit_product_cubit.dart';

@immutable
sealed class EditProductState {}

final class EditProductInitial extends EditProductState {}

final class EditProductLoading extends EditProductState {}

final class EditProductSuccess extends EditProductState {
  final ProductModel product;
  EditProductSuccess({required this.product});
}

final class EditProductFailing extends EditProductState {
  final ApiResponse errMessage;
  EditProductFailing({required this.errMessage});
}

final class EditProductUnValid extends EditProductState {}

final class EditProductAddInitialQunantity extends EditProductState {}

final class GetCategorySuccess extends EditProductState {}

final class GetTaxesTypeSuccess extends EditProductState {}

final class GetUnitsSuccess extends EditProductState {}

final class EditChangeCategory extends EditProductState {}

final class EditChangeUnit extends EditProductState {}

final class EditChangeBranch extends EditProductState {}

final class EditChangeTaxes extends EditProductState {}

final class EditChangeProductType extends EditProductState {}
