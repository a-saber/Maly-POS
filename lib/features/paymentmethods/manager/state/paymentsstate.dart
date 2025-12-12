

import 'package:pos_app/features/paymentmethods/data/models/paymentmethodmodel.dart';

abstract class PaymentMethodsState {}

class PaymentMethodsInitial extends PaymentMethodsState {}

class PaymentMethodsLoading extends PaymentMethodsState {}

class PaymentMethodsSuccess extends PaymentMethodsState {
  final List<PaymentMethodsModel> paymentMethods;
  PaymentMethodsSuccess(this.paymentMethods);
}

class PaymentMethodsFailure extends PaymentMethodsState {
  final String errMessage;
  PaymentMethodsFailure(this.errMessage);
}

class AddPaymentMethodSuccess extends PaymentMethodsState {}

class UpdatePaymentMethodSuccess extends PaymentMethodsState {}

class DeletePaymentMethodSuccess extends PaymentMethodsState {}
class PaymentMethodsLoadingMore extends PaymentMethodsState {}
