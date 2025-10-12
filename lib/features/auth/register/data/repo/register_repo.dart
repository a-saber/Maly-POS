import 'package:dartz/dartz.dart';
import 'package:pos_app/core/api/api_helper.dart';
import 'package:pos_app/core/api/api_keys.dart';
import 'package:pos_app/core/api/api_response.dart';

class RegisterRepo {
  final ApiHelper api;

  RegisterRepo({required this.api});

  Future<Either<ApiResponse, ApiResponse>> register({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String address,
    required String shopName,
  }) async {
    try {
      ApiResponse response = await api.post(url: ApiEndPoints.register, data: {
        ApiKeys.email: email,
        ApiKeys.password: password,
        ApiKeys.name: name,
        ApiKeys.phone: phone,
        ApiKeys.address: address,
        ApiKeys.shopname: shopName
      });
      if (response.status) {
        // ignore: use_build_context_synchronously
        return Right(response);
      } else {
        return Left(response);
      }
    } catch (e) {
      return Left(
        ApiResponse.unKnownError(),
      ); // failure
    }
  }
}
