import 'package:pos_app/core/api/api_keys.dart';
import 'package:pos_app/features/auth/login/data/model/user_model.dart';

class LoginModel {
  final bool? status;
  final String? message;
  final String? token;
  final UserModel? user;
  final String? domain;

  LoginModel(
      {required this.status,
      required this.message,
      required this.token,
      required this.user,
      required this.domain});

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      status: json[ApiKeys.status],
      message: json[ApiKeys.message],
      token: json[ApiKeys.token],
      user: json[ApiKeys.user] != null
          ? UserModel.fromJson(json[ApiKeys.user])
          : null,
      domain: json[ApiKeys.domain],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data[ApiKeys.status] = status;
    data[ApiKeys.message] = message;
    data[ApiKeys.token] = token;
    data[ApiKeys.user] = user;
    data[ApiKeys.domain] = domain;
    return data;
  }
}
