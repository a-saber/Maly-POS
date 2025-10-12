import 'dart:io';

import 'package:hive/hive.dart';
import 'package:pos_app/core/api/api_keys.dart';
import 'package:pos_app/core/helper/upload_image_to_api.dart';
import 'package:pos_app/features/auth/login/data/model/branche_model.dart';
import 'package:pos_app/features/auth/login/data/model/role_model.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel {
  @HiveField(0)
  final int? id;
  @HiveField(1)
  final String? name;
  @HiveField(2)
  final String? email;
  @HiveField(3)
  final String? phone;
  @HiveField(4)
  final String? address;
  @HiveField(5)
  final int? status;
  @HiveField(6)
  final String? imagePath;
  @HiveField(7)
  final String? emailVerifiedAt;
  @HiveField(8)
  final String? createdAt;
  @HiveField(9)
  final String? updatedAt;
  @HiveField(10)
  final int? centralUserId;
  @HiveField(11)
  final int? roleId;
  @HiveField(12)
  final String? imageUrl;
  @HiveField(13)
  final RoleModel? role;
  @HiveField(14)
  final List<BrancheModel>? branches;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.status,
    required this.imagePath,
    required this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.centralUserId,
    required this.roleId,
    required this.imageUrl,
    required this.role,
    required this.branches,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json[ApiKeys.id],
      name: json[ApiKeys.name],
      email: json[ApiKeys.email],
      phone: json[ApiKeys.phone],
      address: json[ApiKeys.address],
      status: (json[ApiKeys.status] is int)
          ? json[ApiKeys.status]
          : (json[ApiKeys.status] == true ? 1 : 0),
      imagePath: json[ApiKeys.imagepath],
      emailVerifiedAt: json[ApiKeys.emailverifiedat],
      createdAt: json[ApiKeys.createdat],
      updatedAt: json[ApiKeys.updatedat],
      centralUserId: json[ApiKeys.centraluserid],
      roleId: json[ApiKeys.roleid] is int
          ? json[ApiKeys.roleid] as int
          : int.tryParse(json[ApiKeys.roleid]?.toString() ?? ''),
      imageUrl: json[ApiKeys.imageurl],
      role: json[ApiKeys.role] != null
          ? RoleModel.fromJson(json[ApiKeys.role])
          : null,
      branches: json[ApiKeys.branches] != null
          ? List<BrancheModel>.from(
              json[ApiKeys.branches].map((x) => BrancheModel.fromJson(x)))
          : null,
    );
  }

  factory UserModel.fromJsonWithoutId({
    required String? email,
    required String? name,
    required String? phone,
    required String? address,
    required RoleModel? role,
    required List<BrancheModel>? branches,
  }) {
    return UserModel(
      id: null,
      name: name,
      email: email,
      phone: phone,
      address: address,
      status: null,
      imagePath: null,
      emailVerifiedAt: null,
      createdAt: null,
      updatedAt: null,
      centralUserId: null,
      roleId: role?.id,
      imageUrl: null,
      role: role,
      branches: branches,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data[ApiKeys.id] = id;
    data[ApiKeys.name] = name;
    data[ApiKeys.email] = email;
    data[ApiKeys.phone] = phone;
    data[ApiKeys.address] = address;
    data[ApiKeys.status] = status;
    data[ApiKeys.imagepath] = imagePath;
    data[ApiKeys.emailverifiedat] = emailVerifiedAt;
    data[ApiKeys.createdat] = createdAt;
    data[ApiKeys.updatedat] = updatedAt;
    data[ApiKeys.centraluserid] = centralUserId;
    data[ApiKeys.roleid] = roleId;
    data[ApiKeys.imageurl] = imageUrl;
    data[ApiKeys.role] = role;
    data[ApiKeys.branches] = branches;
    return data;
  }

  Future<Map<String, dynamic>> jsonWithoutId({
    required String? password,
    required File? image,
  }) async {
    final Map<String, dynamic> data = <String, dynamic>{};

    data[ApiKeys.name] = name;
    data[ApiKeys.email] = email;
    data[ApiKeys.phone] = phone;
    data[ApiKeys.address] = address;
    if (password != null) {
      data[ApiKeys.password] = password;
    }

    data[ApiKeys.roleid] = role?.id?.toString();

    if (image != null) {
      data[ApiKeys.image] = await uploadImageToApi(image: image);
    }

    for (int i = 0; i < (branches?.length ?? 0); i++) {
      data['branch_ids[$i]'] = branches?[i].id.toString();
    }

    return data;
  }
}
