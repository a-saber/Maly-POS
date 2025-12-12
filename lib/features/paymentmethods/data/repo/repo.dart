import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:pos_app/core/api/api_helper.dart';
import 'package:pos_app/core/api/api_keys.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/features/paymentmethods/data/models/getallpayment.dart';
import 'package:pos_app/features/paymentmethods/data/models/paymentmethodmodel.dart';
import 'package:pos_app/features/paymentmethods/data/models/paymentmodel.dart';

class PaymentMethodsRepo {
  GetAllPaymentMethods? paymentMethodsModel;
  final ApiHelper api;

  PaymentMethodsRepo({required this.api});
  
  Future<Either<ApiResponse, List<PaymentMethodsModel>>> getPaymentMethods({
    bool isFresh = false,
    String? query,
  }) async {
    try {
      String? url;

      if (paymentMethodsModel == null || isFresh) {
        url = await ApiEndPoints.getAllPaymentMethods();
        debugPrint("🔍 Fetching payment methods from: $url");
        paymentMethodsModel = null;
      } else {
        // التحقق من الصفحة التالية
        if (paymentMethodsModel?.data?.pagination?.currentPage != null &&
            paymentMethodsModel?.data?.pagination?.lastPage != null &&
            paymentMethodsModel!.data!.pagination!.currentPage! >=
                paymentMethodsModel!.data!.pagination!.lastPage!) {
          return const Right([]);
        }
      }

      final response = await api.get(
        url: url!,
        data: {
          ApiKeys.search: query,
          'page': paymentMethodsModel?.data?.pagination?.currentPage != null
              ? (paymentMethodsModel!.data!.pagination!.currentPage! + 1)
              : 1,
        },
      );

      debugPrint("📥 Response status: ${response.status}");
      debugPrint("📥 Response message: ${response.message}");
      debugPrint("📥 Response data: ${response.data}");

      if (response.status) {
        final newModel = GetAllPaymentMethods.fromJson(response.data);

        if (paymentMethodsModel == null || isFresh) {
          paymentMethodsModel = newModel;
          return Right(paymentMethodsModel!.data?.items ?? []);
        } else {
          paymentMethodsModel!.data!.items!.addAll(newModel.data?.items ?? []);
          paymentMethodsModel!.data!.pagination = newModel.data?.pagination;
          return Right(paymentMethodsModel!.data?.items ?? []);
        }
      } else {
        debugPrint('❌ API Error: ${response.message}');
        return Left(response);
      }
    } catch (e, stackTrace) {
      debugPrint('❌ Exception in getPaymentMethods: $e');
      debugPrint('Stack trace: $stackTrace');
      return Left(ApiResponse.unKnownError());
    }
  }

  Future<Either<ApiResponse, Unit>> addPaymentMethod({
    required AddPaymentMethodModel paymentMethod,
  }) async {
    try {
      final url = await ApiEndPoints.getAllPaymentMethods();
      debugPrint("➕ Adding payment method to: $url");

      Map<String, dynamic> data = {
        'name': paymentMethod.name,
        'is_active': paymentMethod.isActive,
        'requires_reference': paymentMethod.requiresReference,
      };

      debugPrint("📤 Payment method data: $data");

      final response = await api.post(
        url: url,
        data: data,
      );

      debugPrint('📥 Response status: ${response.status}');
      debugPrint('📥 Response data: ${response.data}');

      if (response.status) {
        return Right(unit);
      } else {
        debugPrint('❌ API Error: ${response.message}');
        return Left(response);
      }
    } catch (e, stackTrace) {
      debugPrint('❌ Exception in addPaymentMethod: $e');
      debugPrint('Stack trace: $stackTrace');
      return Left(ApiResponse.unKnownError());
    }
  }

  Future<Either<ApiResponse, Unit>> updatePaymentMethod({
    required PaymentMethodsModel paymentMethod,
  }) async {
    try {
      final String url = await ApiEndPoints.getAllPaymentMethods();
      final fullUrl = "$url/${paymentMethod.id}";
      debugPrint("✏️ Updating payment method at: $fullUrl");

      Map<String, dynamic> data = {
        'name': paymentMethod.name,
        'is_active': paymentMethod.isActive,
        'requires_reference': paymentMethod.requiresReference,
      };

      debugPrint("📤 Update data: $data");

      final response = await api.post(
        url: fullUrl,
        data: data,
      );

      if (response.status) {
        debugPrint("✅ Payment method updated successfully");
        return Right(unit);
      } else {
        debugPrint("❌ API Error: ${response.message}");
        return Left(response);
      }
    } catch (e, stackTrace) {
      debugPrint("❌ Exception in updatePaymentMethod: $e");
      debugPrint('Stack trace: $stackTrace');
      return Left(ApiResponse.unKnownError());
    }
  }

  Future<Either<ApiResponse, int>> deletePaymentMethod({
    required int id,
  }) async {
    try {
      String url = await ApiEndPoints.getAllPaymentMethods();
      final fullUrl = "$url/$id";
      debugPrint("🗑️ Deleting payment method at: $fullUrl");

      var response = await api.delete(
        url: fullUrl,
      );

      if (response.status) {
        debugPrint("✅ Payment method deleted successfully");
        return Right(id);
      } else {
        debugPrint("❌ Delete failed: ${response.message}");
        return Left(response);
      }
    } catch (e, stackTrace) {
      debugPrint("❌ Exception in deletePaymentMethod: $e");
      debugPrint('Stack trace: $stackTrace');
      return Left(ApiResponse.unKnownError());
    }
  }
}