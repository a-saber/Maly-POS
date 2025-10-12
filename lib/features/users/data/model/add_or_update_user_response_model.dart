import 'package:pos_app/core/api/api_keys.dart';
import 'package:pos_app/features/auth/login/data/model/user_model.dart';

class AddOrUpdateUserResponseModel {
  final bool? status;
  final String? message;
  final UserModel? user;

  AddOrUpdateUserResponseModel({
    required this.status,
    required this.message,
    required this.user,
  });

  factory AddOrUpdateUserResponseModel.fromJson(Map<String, dynamic> json) {
    return AddOrUpdateUserResponseModel(
      status: json[ApiKeys.status],
      message: json[ApiKeys.message],
      user: json[ApiKeys.user] != null
          ? UserModel.fromJson(json[ApiKeys.user])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data[ApiKeys.status] = status;
    data[ApiKeys.message] = message;
    data[ApiKeys.user] = user;
    return data;
  }
}
