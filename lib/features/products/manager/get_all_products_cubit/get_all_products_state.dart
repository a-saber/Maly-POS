part of 'get_all_products_cubit.dart';

@immutable
sealed class GetAllProductsState {}

final class GetAllProductsInitial extends GetAllProductsState {}

final class GetAllProductsLoading extends GetAllProductsState {}

final class GetAllProductsSuccess extends GetAllProductsState {}

final class GetAllProductsFailing extends GetAllProductsState {
  final ApiResponse errMessage;
  GetAllProductsFailing({required this.errMessage});
}

final class GetAllProductsPaginationFailing extends GetAllProductsState {
  final ApiResponse errMessage;
  GetAllProductsPaginationFailing({required this.errMessage});
}
