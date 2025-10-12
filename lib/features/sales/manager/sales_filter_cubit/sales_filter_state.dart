part of 'sales_filter_cubit.dart';

@immutable
sealed class SalesFilterState {}

final class SalesFilterInitial extends SalesFilterState {}

final class SalesFilterValidate extends SalesFilterState {}

final class SalesFilterUnValidate extends SalesFilterState {}

final class SalesFilterChangeBranch extends SalesFilterState {}

final class SalesFilterChangeUser extends SalesFilterState {}

final class SalesFilterChangeDiscount extends SalesFilterState {}

final class SalesFilterChangeTaxes extends SalesFilterState {}

final class SalesFilterChangeProduct extends SalesFilterState {}

final class SalesFilterChangePaymentMethod extends SalesFilterState {}

final class SalesFilterChangeFrom extends SalesFilterState {}

final class SalesFilterChangeTo extends SalesFilterState {}

final class SalesFilterChangeSortBy extends SalesFilterState {}

final class SalesFilterChangeSort extends SalesFilterState {}
