part of 'get_sales_return_cubit.dart';

@immutable
sealed class GetSalesReturnState {}

final class GetSalesReturnInitial extends GetSalesReturnState {}

final class GetSalesReturnLoading extends GetSalesReturnState {}

final class GetSalesReturnSuccess extends GetSalesReturnState {}

final class GetSalesReturnFailing extends GetSalesReturnState {
  final ApiResponse errMessage;

  GetSalesReturnFailing({required this.errMessage});
}

final class GetSalesReturnPaginationFailing extends GetSalesReturnState {
  final ApiResponse errMessage;

  GetSalesReturnPaginationFailing({required this.errMessage});
}
