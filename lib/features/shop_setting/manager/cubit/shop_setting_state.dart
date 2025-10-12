part of 'shop_setting_cubit.dart';

@immutable
sealed class ShopSettingState {}

final class ShopSettingInitial extends ShopSettingState {}

final class ShopSettingUpdateUnValid extends ShopSettingState {}

final class ShopSettingGetSuccess extends ShopSettingState {}

final class ShopSettingUpdateSuccess extends ShopSettingState {}

final class ShopSettingUpdateLoading extends ShopSettingState {}

final class ShopSettingUpdateFailing extends ShopSettingState {
  final ApiResponse errMessage;
  ShopSettingUpdateFailing({required this.errMessage});
}
