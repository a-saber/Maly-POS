part of 'get_sales_cubit.dart';

@immutable
sealed class GetSalesState {}

final class GetSalesInitial extends GetSalesState {}

final class GetSalesLoading extends GetSalesState {}

final class GetSalesSuccess extends GetSalesState {}

final class GetSalesFailing extends GetSalesState {
  final ApiResponse errMessage;
  GetSalesFailing({required this.errMessage});
}

final class GetSalesPaginationFailing extends GetSalesState {
  final ApiResponse errMessage;
  GetSalesPaginationFailing({required this.errMessage});
}
