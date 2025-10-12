import 'package:dio/dio.dart';
import 'package:pos_app/core/api/api_keys.dart';
import 'package:pos_app/core/api/api_response.dart';

class ApiHelper {
  final Dio dio;
  CancelToken? cancelToken;
  ApiHelper({required this.dio});

  void _resetCancelToken({
    bool allowCancel = false,
  }) {
    if (allowCancel) {
      cancelToken?.cancel(); // cancel any ongoing request
      cancelToken = CancelToken(); // create a fresh token
    }
  }

  Future<ApiResponse> get({
    required String url,
    Map<String, dynamic>? data,
    bool isFormData = true,
    Map<String, dynamic>? queryParameters,
    Options? options,
    // bool allowCacnel = true,
  }) async {
    try {
      _resetCancelToken(
          // allowCancel: allowCacnel,
          );
      dynamic response = await dio.get(url,
          data: isFormData
              ? FormData.fromMap(
                  data ?? {},
                )
              : data,
          queryParameters: queryParameters,
          cancelToken: cancelToken,
          options: options);
      return ApiResponse.successResonse(
          message: response.data[ApiKeys.message], data: response.data);
    } on DioException catch (e) {
      return handleDioError(
        e,
      );
    } catch (e) {
      return ApiResponse.errorResonse(
        statusCode: ApiStatusCode.unknown,
        "Unknown error",
      );
    }
  }

  Future<ApiResponse> post({
    required String url,
    Map<String, dynamic>? data,
    bool isFormData = true,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    _resetCancelToken();
    try {
      dynamic response = await dio.post(url,
          data: data == null
              ? null
              : isFormData
                  ? FormData.fromMap(
                      data,
                    )
                  : data,
          queryParameters: queryParameters,
          cancelToken: cancelToken,
          options: options);
      return ApiResponse.successResonse(
          message: response.data[ApiKeys.message], data: response.data);
    } on DioException catch (e) {
      return handleDioError(
        e,
      );
    } catch (e) {
      return ApiResponse.errorResonse(
        statusCode: ApiStatusCode.unknown,
        "Unknown error",
      );
    }
  }

  Future<ApiResponse> delete({
    required String url,
    Map<String, dynamic>? data,
    bool isFormData = true,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      _resetCancelToken();
      dynamic response = await dio.delete(url,
          data: isFormData
              ? FormData.fromMap(
                  data ?? {},
                )
              : data,
          queryParameters: queryParameters,
          cancelToken: cancelToken,
          options: options);
      return ApiResponse.successResonse(
          message: response.data[ApiKeys.message], data: response.data);
    } on DioException catch (e) {
      return handleDioError(
        e,
      );
    } catch (e) {
      return ApiResponse.errorResonse(
        statusCode: ApiStatusCode.unknown,
        "Unknown error",
      );
    }
  }
}
