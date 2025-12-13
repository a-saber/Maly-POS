import 'package:pos_app/features/paymentmethods/data/models/paymentmethodmodel.dart';

class PaymentMethodSalesModel {
  int? id;
  String? name;
  int? isActive;
  int? requiresReference;
  int? isNearpay;
  dynamic deletedAt;
  String? createdAt;
  String? updatedAt;

  PaymentMethodSalesModel({
    this.id,
    this.name,
    this.isActive,
    this.requiresReference,
    this.isNearpay,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });
  factory PaymentMethodSalesModel.fromData(PaymentMethodData data) {
    return PaymentMethodSalesModel(
      id: data.id,
      name: data.name,
      isActive: data.isActive,
      requiresReference: data.requiresReference,
      isNearpay: data.isNearpay,
      deletedAt: data.deletedAt,
      createdAt: data.createdAt,
      updatedAt: data.updatedAt,
    );
  }
}