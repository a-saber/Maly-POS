import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:pos_app/core/api/api_helper.dart';
import 'package:pos_app/core/api/api_keys.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/features/paymentmethods/data/models/getallpayment.dart';
import 'package:pos_app/features/paymentmethods/data/models/paymentmodel.dart';

class PaymentMethodsRepo {
  GetAllPaymentMethods? paymentMethodsModel;
  final ApiHelper api;

  PaymentMethodsRepo({required this.api});
  
  Future<Either<ApiResponse, List<PaymentMethodSalesModel>>> getPaymentMethods({
    bool isFresh = false,
    String? query,
  }) async {
    try {
      String url;

      if (paymentMethodsModel == null || isFresh) {
        url = await ApiEndPoints.getAllPaymentMethods();
        debugPrint("🔍 Fetching payment methods from: $url");
        paymentMethodsModel = null;
      } else {
        if (paymentMethodsModel?.paymentMethod?.currentPage != null &&
            paymentMethodsModel?.paymentMethod?.lastPage != null &&
            paymentMethodsModel!.paymentMethod!.currentPage! >=
                paymentMethodsModel!.paymentMethod!.lastPage!) {
          debugPrint("📄 No more pages available");
          return const Right([]);
        }
        
        url = await ApiEndPoints.getAllPaymentMethods();
      }

      final response = await api.get(
        url: url,
        data: {
          if (query != null && query.isNotEmpty) ApiKeys.search: query,
          'page': paymentMethodsModel?.paymentMethod?.currentPage != null
              ? (paymentMethodsModel!.paymentMethod!.currentPage! + 1)
              : 1,
        },
      );

      debugPrint("📥 Response status: ${response.status}");
      debugPrint("📥 Response message: ${response.message}");

      if (response.status) {
        final newModel = GetAllPaymentMethods.fromJson(response.data);

        List<PaymentMethodSalesModel> convertedItems = [];
        if (newModel.paymentMethod?.data != null) {
          convertedItems = newModel.paymentMethod!.data!
              .map((item) => PaymentMethodSalesModel.fromData(item))
              .toList();
        }

        if (paymentMethodsModel == null || isFresh) {
          paymentMethodsModel = newModel;
          debugPrint("✅ Loaded ${convertedItems.length} payment methods");
          return Right(convertedItems);
        } else {
          paymentMethodsModel!.paymentMethod!.currentPage = 
              newModel.paymentMethod?.currentPage;
          paymentMethodsModel!.paymentMethod!.lastPage = 
              newModel.paymentMethod?.lastPage;
          
          debugPrint("✅ Added ${convertedItems.length} more payment methods");
          return Right(convertedItems);
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
  required String name,
  required int isActive,
  required int requiresReference,
  required int isNearpay,
}) async {
  try {
    final url = await ApiEndPoints.getAllPaymentMethods();
    debugPrint("➕ Adding payment method to: $url");

    // استخدم Map مباشرة بدلاً من class
    final data = {
      'name': name,
      'is_active': isActive,
      'requires_reference': requiresReference,
      'is_nearpay': isNearpay,
    };

    debugPrint("📤 Payment method data: $data");

    final response = await api.post(
      url: url,
      data: data, 
    );

    debugPrint(' Response status: ${response.status}');
    debugPrint(' Response message: ${response.message}');

    if (response.status) {
      debugPrint(" Payment method added successfully");
      paymentMethodsModel = null;
      return Right(unit);
    } else {
      debugPrint(' API Error: ${response.message}');
      return Left(response);
    }
  } catch (e, stackTrace) {
    debugPrint(' Exception in addPaymentMethod: $e');
    debugPrint('Stack trace: $stackTrace');
    return Left(ApiResponse.unKnownError());
  }
}  Future<Either<ApiResponse, Unit>> updatePaymentMethod({
    required PaymentMethodSalesModel paymentMethod,
  }) async {
    try {
      final String url = await ApiEndPoints.getAllPaymentMethods();
      final fullUrl = "$url/${paymentMethod.id}";
      debugPrint(" Updating payment method at: $fullUrl");

      Map<String, dynamic> data = {
        'name': paymentMethod.name,
        'is_active': paymentMethod.isActive,
        'requires_reference': paymentMethod.requiresReference,
        'is_nearpay': paymentMethod.isNearpay ?? 0,
      };

      debugPrint(" Update data: $data");

      final response = await api.post(
        url: fullUrl,
        data: data,
      );

      if (response.status) {
        debugPrint(" Payment method updated successfully");
        paymentMethodsModel = null;
        return Right(unit);
      } else {
        debugPrint(" API Error: ${response.message}");
        return Left(response);
      }
    } catch (e, stackTrace) {
      debugPrint(" Exception in updatePaymentMethod: $e");
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
      debugPrint(" Deleting payment method at: $fullUrl");

      var response = await api.delete(
        url: fullUrl,
      );

      if (response.status) {
        debugPrint(" Payment method deleted successfully");
        paymentMethodsModel = null;
        return Right(id);
      } else {
        debugPrint(" Delete failed: ${response.message}");
        return Left(response);
      }
    } catch (e, stackTrace) {
      debugPrint(" Exception in deletePaymentMethod: $e");
      debugPrint('Stack trace: $stackTrace');
      return Left(ApiResponse.unKnownError());
    }
  }
}