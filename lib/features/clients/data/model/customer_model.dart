import 'package:pos_app/core/api/api_keys.dart';

class CustomerModel {
  final int? id;
  final String? name;
  final String? phone;
  final String? email;
  final String? address;
  final String? createdAt;
  final String? updatedAt;

  CustomerModel(
      {required this.id,
      required this.name,
      required this.phone,
      required this.email,
      required this.address,
      required this.createdAt,
      required this.updatedAt});

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json[ApiKeys.id],
      name: json[ApiKeys.name],
      phone: json[ApiKeys.phone],
      email: json[ApiKeys.email],
      address: json[ApiKeys.address],
      createdAt: json[ApiKeys.createdat],
      updatedAt: json[ApiKeys.updatedat],
    );
  }
  factory CustomerModel.createWithoutId({
    required String name,
    required String phone,
    required String email,
    required String address,
  }) {
    return CustomerModel(
      id: null,
      name: name,
      phone: phone,
      email: email,
      address: address,
      createdAt: null,
      updatedAt: null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data[ApiKeys.id] = id;
    data[ApiKeys.name] = name;
    data[ApiKeys.phone] = phone;
    data[ApiKeys.email] = email;
    data[ApiKeys.address] = address;
    data[ApiKeys.createdat] = createdAt;
    data[ApiKeys.updatedat] = updatedAt;
    return data;
  }

  Map<String, dynamic> toJsonWithoutId() {
    final Map<String, dynamic> data = {};

    data[ApiKeys.name] = name;
    data[ApiKeys.phone] = phone;
    data[ApiKeys.email] = email;
    data[ApiKeys.address] = address;

    return data;
  }
}
