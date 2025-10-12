import 'package:pos_app/core/api/api_keys.dart';
import 'package:pos_app/features/auth/login/data/model/branche_model.dart';
import 'package:pos_app/features/auth/login/data/model/user_model.dart';
import 'package:pos_app/features/clients/data/model/customer_model.dart';
import 'package:pos_app/features/discounts/data/model/discount_model.dart';

class SalesReturnModel {
  final int? id;
  final int? saleId;
  final int? userId;
  final String? reason;
  final String? createdAt;
  final String? updatedAt;
  final Sale? sale;
  final UserModel? user;

  SalesReturnModel(
      {required this.id,
      required this.saleId,
      required this.userId,
      required this.reason,
      required this.createdAt,
      required this.updatedAt,
      required this.sale,
      required this.user});

  factory SalesReturnModel.fromJson(Map<String, dynamic> json) {
    return SalesReturnModel(
        id: json[ApiKeys.id],
        saleId: json[ApiKeys.saleid],
        userId: json[ApiKeys.userid],
        reason: json[ApiKeys.reason],
        createdAt: json[ApiKeys.createdat],
        updatedAt: json[ApiKeys.updatedat],
        sale: json[ApiKeys.sale] != null
            ? Sale.fromJson(json[ApiKeys.sale])
            : null,
        user: json[ApiKeys.user] != null
            ? UserModel.fromJson(json[ApiKeys.user])
            : null);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data[ApiKeys.id] = id;
    data[ApiKeys.saleid] = saleId;
    data[ApiKeys.userid] = userId;
    data[ApiKeys.reason] = reason;
    data[ApiKeys.createdat] = createdAt;
    data[ApiKeys.updatedat] = updatedAt;
    data[ApiKeys.sale] = sale;
    data[ApiKeys.user] = user;
    return data;
  }
}

class Sale {
  final int? id;
  final String? subtotal;
  final String? discountTotal;
  final String? totalAfterDiscount;
  final String? taxTotal;
  final String? totalAfterTax;
  final String? paymentMethod;
  final int? discountId;
  final int? userId;
  final int? branchId;
  final int? customerId;
  final String? createdAt;
  final String? updatedAt;
  final int? salesReturnId;
  final UserModel? user;
  final CustomerModel? customer;
  final DiscountModel? discount;
  final BrancheModel? branch;
  final String? orderType;

  Sale(
      {required this.id,
      required this.subtotal,
      required this.discountTotal,
      required this.totalAfterDiscount,
      required this.taxTotal,
      required this.totalAfterTax,
      required this.paymentMethod,
      required this.discountId,
      required this.userId,
      required this.branchId,
      required this.customerId,
      required this.createdAt,
      required this.updatedAt,
      required this.salesReturnId,
      required this.user,
      required this.customer,
      required this.discount,
      required this.orderType,
      required this.branch});

  factory Sale.fromJson(Map<String, dynamic> json) {
    return Sale(
      id: json[ApiKeys.id],
      subtotal: json[ApiKeys.subtotal],
      discountTotal: json[ApiKeys.discounttotal],
      totalAfterDiscount: json[ApiKeys.totalafterdiscount],
      taxTotal: json[ApiKeys.taxtotal],
      totalAfterTax: json[ApiKeys.totalaftertax],
      paymentMethod: json[ApiKeys.paymentmethod],
      discountId: json[ApiKeys.discountid],
      userId: json[ApiKeys.userid],
      branchId: json[ApiKeys.branchid],
      customerId: json[ApiKeys.customerid],
      createdAt: json[ApiKeys.createdat],
      updatedAt: json[ApiKeys.updatedat],
      salesReturnId: json[ApiKeys.salesReturnId],
      orderType: json[ApiKeys.ordertype],
      user: json[ApiKeys.user] != null
          ? UserModel.fromJson(json[ApiKeys.user])
          : null,
      customer: json[ApiKeys.customer] != null
          ? CustomerModel.fromJson(json[ApiKeys.customer])
          : null,
      discount: json[ApiKeys.discount] != null
          ? DiscountModel.fromJson(json[ApiKeys.discount])
          : null,
      branch: json[ApiKeys.branch] != null
          ? BrancheModel.fromJson(json[ApiKeys.branch])
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
    data[ApiKeys.paymentmethod] = paymentMethod;
    data[ApiKeys.discountid] = discountId;
    data[ApiKeys.userid] = userId;
    data[ApiKeys.branchid] = branchId;
    data[ApiKeys.customerid] = customerId;
    data[ApiKeys.createdat] = createdAt;
    data[ApiKeys.updatedat] = updatedAt;
    data[ApiKeys.salesReturnId] = salesReturnId;
    data[ApiKeys.user] = user;
    data[ApiKeys.customer] = customer;
    data[ApiKeys.discount] = discount;
    data[ApiKeys.branch] = branch;
    data[ApiKeys.ordertype] = orderType;
    return data;
  }
}
