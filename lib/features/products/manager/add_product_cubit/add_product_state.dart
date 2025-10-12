part of 'add_product_cubit.dart';

@immutable
sealed class AddProductState {}

final class AddProductInitial extends AddProductState {}

final class AddProductLoading extends AddProductState {}

final class AddProductSuccess extends AddProductState {
  final ProductModel product;
  AddProductSuccess({required this.product});
}

final class AddProductFailing extends AddProductState {
  final ApiResponse errMessage;
  AddProductFailing({required this.errMessage});
}

final class AddProductUnValidate extends AddProductState {}

final class AddProductAddInitialQunantity extends AddProductState {}

final class AddChangeCategory extends AddProductState {}

final class AddChangeUnit extends AddProductState {}

final class AddChangeBranch extends AddProductState {}

final class AddChangeTaxes extends AddProductState {}

final class AddChangProductType extends AddProductState {}
