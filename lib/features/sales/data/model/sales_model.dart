import 'package:pos_app/core/api/api_keys.dart';
import 'package:pos_app/features/auth/login/data/model/branche_model.dart';
import 'package:pos_app/features/auth/login/data/model/user_model.dart';
import 'package:pos_app/features/clients/data/model/customer_model.dart';
import 'package:pos_app/features/discounts/data/model/discount_model.dart';
import 'package:pos_app/features/sales/data/model/sale_products.dart';

// Helper function للتحويل
int? _parseToInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is String) return int.tryParse(value);
  return null;
}

// Model لطريقة الدفع
class PaymentModel {
  final int? id;
  final int? saleId;
  final int? shiftId;
  final int? paymentMethodId;
  final String? amount;
  final String? reference;
  final String? createdAt;
  final String? updatedAt;

  PaymentModel({
    this.id,
    this.saleId,
    this.shiftId,
    this.paymentMethodId,
    this.amount,
    this.reference,
    this.createdAt,
    this.updatedAt,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: _parseToInt(json['id']),
      saleId: _parseToInt(json['sale_id']),
      shiftId: _parseToInt(json['shift_id']),
      paymentMethodId: _parseToInt(json['payment_method_id']),
      amount: json['amount']?.toString(),
      reference: json['reference']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sale_id': saleId,
      'shift_id': shiftId,
      'payment_method_id': paymentMethodId,
      'amount': amount,
      'reference': reference,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class SalesModel {
  final int? id;
  final String? subtotal;
  final String? discountTotal;
  final String? totalAfterDiscount;
  final String? taxTotal;
  final String? totalAfterTax;
  final int? discountId;
  final int? userId;
  final int? branchId;
  final int? customerId;
  final String? createdAt;
  final String? updatedAt;
  final int? salesReturnId;
  final CustomerModel? customer;
  final UserModel? user;
  final BrancheModel? branch;
  final DiscountModel? discount;
  final List<SaleProducts>? saleProducts;
  final String? orderType;
  final List<PaymentModel>? payments;

  SalesModel({
    this.id,
    this.subtotal,
    this.discountTotal,
    this.totalAfterDiscount,
    this.taxTotal,
    this.totalAfterTax,
    this.discountId,
    this.userId,
    this.branchId,
    this.customerId,
    this.createdAt,
    this.updatedAt,
    this.salesReturnId,
    this.customer,
    this.user,
    this.branch,
    this.discount,
    this.orderType,
    this.saleProducts,
    this.payments,
  });

  factory SalesModel.fromJson(Map<String, dynamic> json) {
    return SalesModel(
      id: _parseToInt(json[ApiKeys.id]),
      subtotal: json[ApiKeys.subtotal]?.toString(),
      discountTotal: json[ApiKeys.discounttotal]?.toString(),
      totalAfterDiscount: json[ApiKeys.totalafterdiscount]?.toString(),
      taxTotal: json[ApiKeys.taxtotal]?.toString(),
      totalAfterTax: json[ApiKeys.totalaftertax]?.toString(),
      discountId: _parseToInt(json[ApiKeys.discountid]),
      userId: _parseToInt(json[ApiKeys.userid]),
      branchId: _parseToInt(json[ApiKeys.branchid]),
      customerId: _parseToInt(json[ApiKeys.customerid]),
      orderType: json[ApiKeys.ordertype]?.toString(),
      createdAt: json[ApiKeys.createdat]?.toString(),
      updatedAt: json[ApiKeys.updatedat]?.toString(),
      salesReturnId: _parseToInt(json[ApiKeys.salesReturnId]),
      customer: json[ApiKeys.customer] != null
          ? CustomerModel.fromJson(json[ApiKeys.customer])
          : null,
      user: json[ApiKeys.user] != null
          ? UserModel.fromJson(json[ApiKeys.user])
          : null,
      branch: json[ApiKeys.branch] != null
          ? BrancheModel.fromJson(json[ApiKeys.branch])
          : null,
      discount: json[ApiKeys.discount] != null
          ? DiscountModel.fromJson(json[ApiKeys.discount])
          : null,
      saleProducts: json[ApiKeys.saleproducts] != null
          ? (json[ApiKeys.saleproducts] as List)
              .map((e) => SaleProducts.fromJson(e))
              .toList()
          : null,
      payments: json['payments'] != null
          ? (json['payments'] as List)
              .map((e) => PaymentModel.fromJson(e))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data[ApiKeys.id] = id;
    data[ApiKeys.subtotal] = subtotal;
    data[ApiKeys.discounttotal] = discountTotal;
    data[ApiKeys.totalafterdiscount] = totalAfterDiscount;
    data[ApiKeys.taxtotal] = taxTotal;
    data[ApiKeys.totalaftertax] = totalAfterTax;
    data[ApiKeys.discountid] = discountId;
    data[ApiKeys.userid] = userId;
    data[ApiKeys.branchid] = branchId;
    data[ApiKeys.customerid] = customerId;
    data[ApiKeys.createdat] = createdAt;
    data[ApiKeys.updatedat] = updatedAt;
    data[ApiKeys.salesReturnId] = salesReturnId;
    data[ApiKeys.customer] = customer?.toJson();
    data[ApiKeys.user] = user?.toJson();
    data[ApiKeys.branch] = branch?.toJson();
    data[ApiKeys.discount] = discount?.toJson();
    data[ApiKeys.ordertype] = orderType;
    data[ApiKeys.saleproducts] = saleProducts?.map((e) => e.toJson()).toList();
    data['payments'] = payments?.map((e) => e.toJson()).toList();
    return data;
  }
}