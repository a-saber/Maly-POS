import 'package:pos_app/core/api/api_keys.dart';
import 'package:pos_app/features/suppliers/data/models/supplier_model.dart';

class AddOrUpdateSupplierModel {
  final bool? status;
  final String? message;
  final SupplierModel? supplier;

  AddOrUpdateSupplierModel(
      {required this.status, required this.message, required this.supplier});

  factory AddOrUpdateSupplierModel.fromJson(Map<String, dynamic> json) {
    return AddOrUpdateSupplierModel(
      status: json[ApiKeys.status],
      message: json[ApiKeys.message],
      supplier: json[ApiKeys.supplier] == null
          ? null
          : SupplierModel.fromJson(json[ApiKeys.supplier]),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data[ApiKeys.status] = status;
    data[ApiKeys.message] = message;
    data[ApiKeys.supplier] = supplier;
    return data;
  }
}
