import 'package:pos_app/core/api/api_keys.dart';
import 'package:pos_app/features/clients/data/model/customer_model.dart';

class AddOrUpdateCustomerResponseModel {
  final bool? status;
  final String? message;
  final CustomerModel? customer;

  AddOrUpdateCustomerResponseModel(
      {required this.status, required this.message, required this.customer});

  factory AddOrUpdateCustomerResponseModel.fromJson(Map<String, dynamic> json) {
    return AddOrUpdateCustomerResponseModel(
      status: json[ApiKeys.status],
      message: json[ApiKeys.message],
      customer: json[ApiKeys.customer] != null
          ? CustomerModel.fromJson(json[ApiKeys.customer])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data[ApiKeys.status] = status;
    data[ApiKeys.message] = message;
    data[ApiKeys.customer] = customer;
    return data;
  }
}
