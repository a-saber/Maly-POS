import 'package:pos_app/core/api/api_keys.dart';
import 'package:pos_app/features/auth/login/data/model/role_model.dart';

class AddAndUpdatePermissionResponseModel {
  final bool? status;
  final String? message;
  final RoleModel? role;

  AddAndUpdatePermissionResponseModel(
      {required this.status, required this.message, required this.role});

  factory AddAndUpdatePermissionResponseModel.fromJson(
      Map<String, dynamic> json) {
    return AddAndUpdatePermissionResponseModel(
      status: json[ApiKeys.status],
      message: json[ApiKeys.message],
      role: json[ApiKeys.role] != null
          ? RoleModel.fromJson(json[ApiKeys.role])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data[ApiKeys.status] = status;
    data[ApiKeys.message] = message;
    data[ApiKeys.role] = role;
    return data;
  }
}
