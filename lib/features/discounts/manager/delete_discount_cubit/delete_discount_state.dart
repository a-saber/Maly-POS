part of 'delete_discount_cubit.dart';

@immutable
sealed class DeleteDiscountState {}

final class DeleteDiscountInitial extends DeleteDiscountState {}

final class DeleteDiscountLoading extends DeleteDiscountState {}

final class DeleteDiscountSuccess extends DeleteDiscountState {
  final int id;
  DeleteDiscountSuccess({required this.id});
}

final class DeleteDiscountFailing extends DeleteDiscountState {
  final ApiResponse errMessage;
  DeleteDiscountFailing({required this.errMessage});
}
