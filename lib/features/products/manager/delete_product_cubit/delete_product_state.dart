part of 'delete_product_cubit.dart';

@immutable
sealed class DeleteProductState {}

final class DeleteProductInitial extends DeleteProductState {}

final class DeleteProductLoading extends DeleteProductState {}

final class DeleteProductSuccess extends DeleteProductState {
  final int id;

  DeleteProductSuccess({required this.id});
}

final class DeleteProductFailing extends DeleteProductState {
  final ApiResponse errMessage;
  DeleteProductFailing({required this.errMessage});
}
