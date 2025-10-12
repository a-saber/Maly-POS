import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pos_app/core/api/api_keys.dart';
import 'package:pos_app/generated/l10n.dart';

class ApiResponse {
  final bool status;
  final int? statusCode;
  final String? message;
  final dynamic data;
  final dynamic error;

  ApiResponse(
      {required this.status,
      required this.message,
      required this.data,
      required this.statusCode,
      required this.error});

  factory ApiResponse.successResonse(
          {required String? message, required dynamic data}) =>
      ApiResponse(
        status: true,
        message: message,
        data: data,
        error: null,
        statusCode: ApiStatusCode.success,
      );
  factory ApiResponse.unKnownError() => ApiResponse(
        status: false,
        message: "unKnownError",
        data: null,
        error: null,
        statusCode: ApiStatusCode.unknown,
      );

  factory ApiResponse.errorResonse(String error,
      {dynamic errorResponse, required int? statusCode}) {
    debugPrint(errorResponse.toString());
    String errorRes = "";
    if (errorResponse != null) {
      try {
        List<String> data = [];
        for (var element in (errorResponse as Map<String, dynamic>).entries) {
          List<String> values = List<String>.from(element.value);
          data.add(
            returnKeyAndValues(element.key, values),
          );
          debugPrint(returnKeyAndValues(element.key, values));
        }

        errorRes = returnAllString(data);
      } catch (e) {
        debugPrint(e.toString());
        errorRes = error;
      }
    }
    return ApiResponse(
      status: false,
      message: errorRes.isEmpty ? error : errorRes,
      data: null,
      error: errorResponse,
      statusCode: ApiStatusCode.badResponse,
    );
  }
}

String returnAllString(List<String> data) {
  String res = "";
  for (int i = 0; i < data.length; i++) {
    if (i == 0) {
      res += data[i];
    } else {
      res += "\n${data[i]}";
    }
  }

  return res;
}

String returnKeyAndValues(String key, List<String> value) {
  String res = '';
  for (int i = 0; i < value.length; i++) {
    if (i != 0) {
      res += "\n$key: ${value[i]}";
    } else {
      res += "$key: ${value[i]}";
    }
  }

  return res;
}

ApiResponse handleDioError(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
      return ApiResponse.errorResonse(
        "Connection timeout",
        statusCode: ApiStatusCode.connectionTimeout,
      );
    case DioExceptionType.sendTimeout:
      return ApiResponse.errorResonse(
        "Send timeout",
        statusCode: ApiStatusCode.sendTimeout,
      );
    case DioExceptionType.receiveTimeout:
      return ApiResponse.errorResonse(
        "Receive timeout",
        statusCode: ApiStatusCode.receiveTimeout,
      );
    case DioExceptionType.badResponse:
      return _handleServerError(error.response);
    case DioExceptionType.cancel:
      return ApiResponse.errorResonse(
        "Request cancelled",
        statusCode: ApiStatusCode.cancelled,
      );
    case DioExceptionType.connectionError:
      return ApiResponse.errorResonse(
        "No internet connection",
        statusCode: ApiStatusCode.noInternet,
      );
    default:
      return ApiResponse.errorResonse(
        "Unknown error",
        statusCode: ApiStatusCode.unknown,
      );
  }
}

/// Handling errors from the server response
ApiResponse _handleServerError(Response? response) {
  if (response == null) {
    return ApiResponse.errorResonse(
      "No response from server",
      statusCode: ApiStatusCode.noResponse,
    );
  }

  if (response.data is Map<String, dynamic>) {
    return ApiResponse.errorResonse(
      response.data[ApiKeys.message] ?? "An error occurred",
      errorResponse: response.data[ApiKeys.errors],
      statusCode: ApiStatusCode.badResponse,
    );
  }

  return ApiResponse.errorResonse(
    "Server error: ${response.statusMessage}",
    statusCode: ApiStatusCode.badResponse,
  );
}

String mapStatusCodeToMessage(BuildContext context, ApiResponse response,
    {String? fallback, String? message}) {
  switch (response.statusCode) {
    case ApiStatusCode.badResponse:
      return message ?? response.message ?? S.of(context).serverError;
    case ApiStatusCode.connectionTimeout:
      return S.of(context).connectionTimeout;
    case ApiStatusCode.sendTimeout:
      return S.of(context).sendTimeout;
    case ApiStatusCode.receiveTimeout:
      return S.of(context).receiveTimeout;
    case ApiStatusCode.noInternet:
      return S.of(context).noInternet;
    case ApiStatusCode.cancelled:
      return S.of(context).requestCancelled;
    case ApiStatusCode.noResponse:
      return S.of(context).noResponseFromServer;
    case ApiStatusCode.unknown:
      return S.of(context).unknownError;
    default:
      return fallback ?? S.of(context).unknownError;
  }
}

abstract class ApiStatusCode {
  static const int success = 200;

  // Network related
  static const int connectionTimeout = 408; // Request Timeout
  static const int sendTimeout = 409;
  static const int receiveTimeout = 410;
  static const int noInternet = 503;

  // Request cancel
  static const int cancelled = 499;

  // Server
  static const int badResponse = 500;
  static const int noResponse = 502;

  // Unknown
  static const int unknown = 520;
}
