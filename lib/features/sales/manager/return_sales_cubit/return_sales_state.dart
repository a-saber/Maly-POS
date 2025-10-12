part of 'return_sales_cubit.dart';

@immutable
sealed class ReturnSalesState {}

final class ReturnSalesInitial extends ReturnSalesState {}

final class ReturnSalesLoading extends ReturnSalesState {}

final class ReturnSalesSuccess extends ReturnSalesState {}

final class ReturnSalesFailing extends ReturnSalesState {
  final ApiResponse message;
  ReturnSalesFailing({required this.message});
}
