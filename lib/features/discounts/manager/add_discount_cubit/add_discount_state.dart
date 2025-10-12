part of 'add_discount_cubit.dart';

@immutable
sealed class AddDiscountState {}

final class AddDiscountInitial extends AddDiscountState {}

final class AddDiscountTypeChanged extends AddDiscountState {}

final class AddDiscountLoading extends AddDiscountState {}

final class AddDiscountSuccess extends AddDiscountState {
  final DiscountModel discount;
  AddDiscountSuccess({required this.discount});
}

final class AddDiscountFailing extends AddDiscountState {
  final ApiResponse errMessage;
  AddDiscountFailing({required this.errMessage});
}

final class AddDiscountUnValid extends AddDiscountState {}
