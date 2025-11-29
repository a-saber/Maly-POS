part of 'csid_generation_setting_cubit.dart';

@immutable
sealed class ScidGenerationState {}

final class ScidGenerationInitial extends ScidGenerationState {}
final class ScidGenerationSelectUserName extends ScidGenerationState {}
final class ScidGenerationSelectInvoiceType extends ScidGenerationState {}
final class ScidGenerationSelectCsidType extends ScidGenerationState {}


