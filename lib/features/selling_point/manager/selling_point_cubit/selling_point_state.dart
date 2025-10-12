part of 'selling_point_cubit.dart';

@immutable
sealed class SellingPointState {}

final class SellingPointInitial extends SellingPointState {}

final class SellingPointInitialChangeCategoryId extends SellingPointState {}

final class SellingPointInitialGetProductLoading extends SellingPointState {}

final class SellingPointInitialGetProductSuccess extends SellingPointState {}

class SellingPointPaginationGetProductSuccess extends SellingPointState {}

final class SellingPointInitialGetProductFailing extends SellingPointState {
  final ApiResponse errMessage;
  SellingPointInitialGetProductFailing({required this.errMessage});
}

final class SellingPointPaginationGetProductFailing extends SellingPointState {
  final ApiResponse errMessage;
  SellingPointPaginationGetProductFailing({required this.errMessage});
}

final class SellingPointIsGotToPayment extends SellingPointState {}

final class SellingPointProductsUpdate extends SellingPointState {}
