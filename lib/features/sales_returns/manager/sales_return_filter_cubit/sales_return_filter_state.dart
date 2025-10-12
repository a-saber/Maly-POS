part of 'sales_return_filter_cubit.dart';

@immutable
sealed class SalesReturnFilterState {}

final class SalesReturnFilterInitial extends SalesReturnFilterState {}

final class SalesReturnFilterChangeBranch extends SalesReturnFilterState {}

final class SalesReturnFilterChangeUser extends SalesReturnFilterState {}

final class SalesReturnFilterChangeDiscount extends SalesReturnFilterState {}

final class SalesReturnFilterChangeTaxes extends SalesReturnFilterState {}

final class SalesReturnFilterChangeProduct extends SalesReturnFilterState {}

final class SalesReturnFilterChangePaymentMethod
    extends SalesReturnFilterState {}

final class SalesReturnFilterChangeFrom extends SalesReturnFilterState {}

final class SalesReturnFilterChangeTo extends SalesReturnFilterState {}

final class SalesReturnFilterChangeSortBy extends SalesReturnFilterState {}

final class SalesReturnFilterChangeSort extends SalesReturnFilterState {}

final class SalesReturnFilterChangeOrderType extends SalesReturnFilterState {}
