import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:pos_app/core/api/api_helper.dart';
import 'package:pos_app/core/api/api_keys.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/core/cache/cache_helper.dart';
import 'package:pos_app/core/cache/cache_keys.dart';
import 'package:pos_app/core/cache/custom_secure_storage.dart';
import 'package:pos_app/core/cache/custom_user_hive_box.dart';
import 'package:pos_app/features/auth/login/data/model/login_model.dart';
import 'package:pos_app/features/auth/login/data/model/user_model.dart';

class LoginRepo {
  final ApiHelper api;

  LoginRepo({required this.api});

  Future<Either<ApiResponse, ApiResponse>> login({
    required String email,
    required String password,
  }) async {
    try {
      ApiResponse response = await api.post(
        url: ApiEndPoints.login,
        data: {
          ApiKeys.email: email,
          ApiKeys.password: password,
        },
      );
      if (response.status) {
        LoginModel loginModel = LoginModel.fromJson(response.data);
        await storeData(
          token: loginModel.token!,
          user: loginModel.user!,
          domain: loginModel.domain!,
        );
        // ignore: use_build_context_synchronously
        return Right(response);
      } else {
        // ignore: use_build_context_synchronously
        return Left(
          response,
        );
      }
    } catch (e) {
      return Left(ApiResponse.unKnownError()); // failure
    }
  }

  Future<void> storeData({
    required String token,
    required String domain,
    required UserModel user,
  }) async {
    //////////////////////////////////////////////////////
    // Endocde Token and Domain
    String encodeToken = base64Encode(utf8.encode(token));
    String domainEncoded = base64Encode(utf8.encode(domain));
    //////////////////////////////////////////////////////
    /// Print to Test
    // debugPrint("encodeToken : $encodeToken");
    // debugPrint("domain : $domain");
    // debugPrint("domainEncoded : $domainEncoded");
    ///////////////////////////////////////////////////////
    ///
    /// Write to Secure Storage
    await CustomSecureStorage.write(
        key: CacheKeys.accessToken, value: encodeToken);
    await CustomSecureStorage.write(
        key: CacheKeys.domain, value: domainEncoded);
    /////////////////////////////////////////////////////

    await Future.wait([
      ////////////////////////////////////////////////////////////
      // Flutter Secure Storage
      // CustomSecureStorage.write(key: CacheKeys.accessToken, value: encodeToken),
      // CustomSecureStorage.write(key: CacheKeys.domain, value: domainEncoded),
      /////////////////////////////////////////////////////////////

      //// SharedPrefrences not secure
      // CacheHelper.saveData(key: CacheKeys.accessToken, value: token),
      // CacheHelper.saveData(key: CacheKeys.domain, value: domain),

      CustomUserHiveBox.setUser(user),
      CacheHelper.saveData(key: CacheKeys.isLogin, value: true),
    ]);
  }
}
