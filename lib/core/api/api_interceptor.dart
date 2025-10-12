import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pos_app/core/api/api_keys.dart';
import 'package:pos_app/core/cache/cache_keys.dart';
import 'package:pos_app/core/cache/custom_secure_storage.dart';

class CustomInterceptor extends Interceptor {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      String? accessTokenCoded =
          await CustomSecureStorage.read(key: CacheKeys.accessToken);
      String accessToken = accessTokenCoded != null
          ? utf8.decode(base64Decode(accessTokenCoded))
          : "";
      // String accessToken =
      //     CacheHelper.getString(key: CacheKeys.accessToken) ?? '';
      if (accessToken.isNotEmpty) {
        options.headers[ApiKeys.authorization] =
            '${ApiKeys.bearer} $accessToken';
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    handler.next(err);
  }
}

Dio getDio() {
  Dio dio = Dio();
  dio.options.connectTimeout = const Duration(seconds: 15); // connect to server
  dio.options.receiveTimeout =
      const Duration(seconds: 45); // wait for server response
  dio.options.sendTimeout = const Duration(seconds: 30); // send data (upload)
  dio.options.headers[ApiKeys.contentType] = "application/json";
  dio.options.headers[ApiKeys.accept] = "application/json";
  dio.interceptors.add(CustomInterceptor());
  dio.interceptors.add(LogInterceptor(
    requestBody: true,
    responseBody: true,
    requestHeader: true,
    responseHeader: true,
    error: true,
  ));
  return dio;
}
