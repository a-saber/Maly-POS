part of 'edit_discount_cubit.dart';

@immutable
sealed class EditDiscountState {}

final class EditDiscountInitial extends EditDiscountState {}

final class EditDiscountTypeChanged extends EditDiscountState {}

final class EditDiscountLoading extends EditDiscountState {}

final class EditDiscountSuccess extends EditDiscountState {
  final DiscountModel discount;
  EditDiscountSuccess({required this.discount});
}

final class EditDiscountFailing extends EditDiscountState {
  final ApiResponse errMessage;
  EditDiscountFailing({required this.errMessage});
}

final class EditDiscountUnValid extends EditDiscountState {}
