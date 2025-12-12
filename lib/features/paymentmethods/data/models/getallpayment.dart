import 'package:dartz/dartz.dart';
import 'package:pos_app/features/paymentmethods/data/models/paymentmethodmodel.dart';

class GetAllPaymentMethods {
  String? status;
  int? code;
  String? message;
  Data? data;

  GetAllPaymentMethods({this.status, this.code, this.message, this.data});

  GetAllPaymentMethods.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['status'] = this.status;
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<PaymentMethodsModel>? items;
  Pagination? pagination;

  Data({this.items, this.pagination});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <PaymentMethodsModel>[];
      json['items'].forEach((v) {
        items!.add(PaymentMethodsModel.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    return data;
  }
}

class Items {
  int? id;
  String? name;
  int? isActive;
  int? requiresReference;
  Null? deletedAt;
  String? createdAt;
  String? updatedAt;

  Items(
      {this.id,
      this.name,
      this.isActive,
      this.requiresReference,
      this.deletedAt,
      this.createdAt,
      this.updatedAt});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    isActive = json['is_active'];
    requiresReference = json['requires_reference'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['is_active'] = this.isActive;
    data['requires_reference'] = this.requiresReference;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Pagination {
  int? total;
  int? perPage;
  int? currentPage;
  int? lastPage;
  int? from;
  int? to;

  Pagination(
      {this.total,
      this.perPage,
      this.currentPage,
      this.lastPage,
      this.from,
      this.to});

  Pagination.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    perPage = json['per_page'];
    currentPage = json['current_page'];
    lastPage = json['last_page'];
    from = json['from'];
    to = json['to'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    data['per_page'] = this.perPage;
    data['current_page'] = this.currentPage;
    data['last_page'] = this.lastPage;
    data['from'] = this.from;
    data['to'] = this.to;
    return data;
  }
}
