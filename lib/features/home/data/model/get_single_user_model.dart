import 'package:pos_app/core/api/api_keys.dart';
import 'package:pos_app/features/auth/login/data/model/user_model.dart';

class GetSingleUserModel {
  final bool? status;
  final UserModel? user;

  const GetSingleUserModel({
    required this.status,
    required this.user,
  });

  factory GetSingleUserModel.fromJson(Map<String, dynamic> json) {
    return GetSingleUserModel(
      status: json[ApiKeys.status],
      user: json[ApiKeys.user] == null
          ? null
          : UserModel.fromJson(json[ApiKeys.user]),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data[ApiKeys.status] = status;
    data[ApiKeys.user] = user;
    return data;
  }
}
