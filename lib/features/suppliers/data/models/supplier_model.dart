import 'package:pos_app/core/api/api_keys.dart';

class SupplierModel {
  final int? id;
  final String? name;
  final String? phone;
  final String? email;
  final String? address;
  final String? createdAt;
  final String? updatedAt;

  SupplierModel(
      {required this.id,
      required this.name,
      required this.phone,
      required this.email,
      required this.address,
      required this.createdAt,
      required this.updatedAt});

  factory SupplierModel.fromJson(Map<String, dynamic> json) {
    return SupplierModel(
      id: json[ApiKeys.id],
      name: json[ApiKeys.name],
      phone: json[ApiKeys.phone],
      email: json[ApiKeys.email],
      address: json[ApiKeys.address],
      createdAt: json[ApiKeys.createdat],
      updatedAt: json[ApiKeys.updatedat],
    );
  }
  factory SupplierModel.createUserWIthoutId({
    final String? name,
    final String? phone,
    final String? email,
    final String? address,
    final int? id,
  }) {
    return SupplierModel(
      id: id,
      name: name,
      phone: phone,
      email: email,
      address: address,
      createdAt: '',
      updatedAt: '',
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

// class SupplierModel {
//   int? id;
//   String? name;
//   String? phone;
//   String? email;
//   String? address;
//   String? commercialRegister;
//   String? taxIdentificationNumber;
//   String? note;
//   String? imagePath;

//   SupplierModel({
//     this.id,
//     this.name,
//     this.phone,
//     this.email,
//     this.address,
//     this.commercialRegister,
//     this.taxIdentificationNumber,
//     this.note,
//     this.imagePath,
//   });

//   static SupplierModel from(SupplierModel source) {
//     return SupplierModel(
//       id: source.id,
//       name: source.name,
//       phone: source.phone,
//       email: source.email,
//       address: source.address,
//       commercialRegister: source.commercialRegister,
//       taxIdentificationNumber: source.taxIdentificationNumber,
//       note: source.note,
//       imagePath: source.imagePath,
//     );
//   }
// }
