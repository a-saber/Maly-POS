part of 'get_all_discounts_cubit.dart';

@immutable
sealed class GetAllDiscountsState {}

final class GetAllDiscountsInitial extends GetAllDiscountsState {}

final class GetAllDiscountsLoading extends GetAllDiscountsState {}

final class GetAllDiscountsSuccess extends GetAllDiscountsState {}

final class GetAllDiscountsFailing extends GetAllDiscountsState {
  final ApiResponse errMessage;
  GetAllDiscountsFailing({required this.errMessage});
}

final class GetAllDiscountsPaginationFailing extends GetAllDiscountsState {
  final ApiResponse errMessage;
  GetAllDiscountsPaginationFailing({required this.errMessage});
}
