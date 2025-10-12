part of 'selling_point_product_cubit.dart';

@immutable
sealed class SellingPointProductState {}

final class SellingPointProductInitial extends SellingPointProductState {}

final class SellingPointProductUnvalidTextField
    extends SellingPointProductState {}

final class SellingPointProductChangePaid extends SellingPointProductState {}

final class SellingPointProductLoading extends SellingPointProductState {}

final class SellingPointProductSuccess extends SellingPointProductState {
  final PrintModel printModel;
  SellingPointProductSuccess({required this.printModel});
}

final class SellingPointProductFailing extends SellingPointProductState {
  final ApiResponse message;
  SellingPointProductFailing({required this.message});
}

final class SellingPointProductAddingProduct extends SellingPointProductState {}

final class SellingPointProductAddingFailingProduct
    extends SellingPointProductState {}

final class SellingPointProductIncreaseCount extends SellingPointProductState {}

final class SellingPointProductIncreaseCountFailing
    extends SellingPointProductState {}

final class SellingPointProductDecreaseCount extends SellingPointProductState {}

final class SellingPointProductRemoveProduct extends SellingPointProductState {}

// final class SellingPointProductReset extends SellingPointProductState {}

final class SellingPointProductChangePayment extends SellingPointProductState {}

final class SellingPointProductChangeUser extends SellingPointProductState {}

final class SellingPointProductChangeTaxes extends SellingPointProductState {}

final class SellingPointProductChangeBranche extends SellingPointProductState {}

final class SellingPointProductChangeDiscount
    extends SellingPointProductState {}

final class SellingPointProductChangeTypeOfTakeOrder
    extends SellingPointProductState {}

final class SellingPointProductResetProduct extends SellingPointProductState {}

final class SellingPointProductUpdateProduct extends SellingPointProductState {}

final class SellingPointProductDeleteProduct extends SellingPointProductState {}
