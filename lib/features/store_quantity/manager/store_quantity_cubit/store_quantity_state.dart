part of 'store_quantity_cubit.dart';

@immutable
sealed class StoreQuantityState {}

final class StoreQunatityInitial extends StoreQuantityState {}

final class StoreQunatityLoading extends StoreQuantityState {}

final class StoreQunatitySuccess extends StoreQuantityState {
  // final List<ProductModelTest> products;
  // StoreQunatitySuccess({required this.products});
}

final class StoreQunatityFailing extends StoreQuantityState {
  final ApiResponse errMessage;
  // final BrancheModel branch;
  StoreQunatityFailing({
    required this.errMessage,
  });
}

final class StoreQunatityPaginationFailing extends StoreQuantityState {
  final ApiResponse errMessage;
  // final BrancheModel branch;
  StoreQunatityPaginationFailing({
    required this.errMessage,
  });
}
