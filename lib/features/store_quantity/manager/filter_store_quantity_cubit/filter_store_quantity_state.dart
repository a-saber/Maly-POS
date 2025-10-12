part of 'filter_store_quantity_cubit.dart';

@immutable
sealed class FilterStoreQuantityState {}

final class FilterStoreQuantityInitial extends FilterStoreQuantityState {}

final class FilterStoreQuantityChangeCategory
    extends FilterStoreQuantityState {}

final class FilterStoreQuantityChangeUnit extends FilterStoreQuantityState {}

final class FilterStoreQuantitySuccess extends FilterStoreQuantityState {}

final class FilterStoreQuantityUnValidate extends FilterStoreQuantityState {}
