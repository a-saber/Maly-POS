import 'dart:io';

import 'package:pos_app/core/api/api_keys.dart';
import 'package:pos_app/core/helper/upload_image_to_api.dart';

class ShopSettingModel {
  final int? id;
  final String? shopName;
  final String? address;
  final String? postalCode;
  final String? taxNo;
  final String? commercialNo;
  final String? phone;
  final String? email;
  final String? logoUrl;
  final String? createdAt;
  final String? updatedAt;
  final String? imageUrl;

  const ShopSettingModel(
      {required this.id,
      required this.shopName,
      required this.address,
      required this.postalCode,
      required this.taxNo,
      required this.commercialNo,
      required this.phone,
      required this.email,
      required this.logoUrl,
      required this.createdAt,
      required this.updatedAt,
      required this.imageUrl});

  factory ShopSettingModel.fromJson(Map<String, dynamic> json) {
    return ShopSettingModel(
      id: json[ApiKeys.id],
      shopName: json[ApiKeys.shopname],
      address: json[ApiKeys.address],
      postalCode: json[ApiKeys.postalcode],
      taxNo: json[ApiKeys.taxno],
      commercialNo: json[ApiKeys.commercialno],
      phone: json[ApiKeys.phone],
      email: json[ApiKeys.email],
      logoUrl: json[ApiKeys.logourl],
      createdAt: json[ApiKeys.createdat],
      updatedAt: json[ApiKeys.updatedat],
      imageUrl: json[ApiKeys.imageurl],
    );
  }
  factory ShopSettingModel.createModelWithoutId({
    required String shopName,
    required String? address,
    required String? postalCode,
    required String? taxNo,
    required String? commercialNo,
    required String? phone,
    required String? email,
  }) {
    return ShopSettingModel(
      id: null,
      shopName: shopName,
      address: address,
      postalCode: postalCode,
      taxNo: taxNo,
      commercialNo: commercialNo,
      phone: phone,
      email: email,
      logoUrl: null,
      createdAt: null,
      updatedAt: null,
      imageUrl: null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data[ApiKeys.id] = id;
    data[ApiKeys.shopname] = shopName;
    data[ApiKeys.address] = address;
    data[ApiKeys.postalcode] = postalCode;
    data[ApiKeys.taxno] = taxNo;
    data[ApiKeys.commercialno] = commercialNo;
    data[ApiKeys.phone] = phone;
    data[ApiKeys.email] = email;
    data[ApiKeys.logourl] = logoUrl;
    data[ApiKeys.createdat] = createdAt;
    data[ApiKeys.updatedat] = updatedAt;
    data[ApiKeys.imageurl] = imageUrl;
    return data;
  }

  Future<Map<String, dynamic>> toJsonWithoutId({File? image}) async {
    final Map<String, dynamic> data = <String, dynamic>{};

    data[ApiKeys.shopname] = shopName;
    if (address != null) {
      data[ApiKeys.address] = address;
    }
    if (postalCode != null) {
      data[ApiKeys.postalcode] = postalCode;
    }
    if (taxNo != null) {
      data[ApiKeys.taxno] = taxNo;
    }
    if (commercialNo != null) {
      data[ApiKeys.commercialno] = commercialNo;
    }
    if (phone != null) {
      data[ApiKeys.phone] = phone;
    }
    if (email != null) {
      data[ApiKeys.email] = email;
    }
    if (image != null) {
      var myImage = await uploadImageToApi(image: image);
      data[ApiKeys.image] = myImage;
    }

    return data;
  }
}
