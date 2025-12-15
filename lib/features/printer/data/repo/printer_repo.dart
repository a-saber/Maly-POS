import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:pos_app/core/api/api_helper.dart';
import 'package:pos_app/core/api/api_keys.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/features/printer/data/model/printers_search_model.dart';

import '../../../../core/helper/printer_helper.dart';
import '../../manager/printer_data_cubit/printer_data_cubit.dart';
import '../model/printer_model.dart';

class PrinterRepo {
  GetPrintersReponseModel? printersModel;
  final ApiHelper api;
  PrinterRepo({required this.api});
  Future<Either<ApiResponse, List<PrinterModel>>> getPrinters({
    bool isFresh = false,
    String? query,
  }) async {
    try {
      String? url;

      if (printersModel == null || isFresh) {
        url = await ApiEndPoints.getPrinters();
        printersModel = null;
      } else {
        if (printersModel!.nextPageUrl == null) {
          return const Right([]);
        }
      }

      final response = await api.get(
        url: url!,
        data: {
          ApiKeys.search: query,
        },
      );

      if (response.status) {
        final newModel = GetPrintersReponseModel.fromJson(response.data);

        if (printersModel == null || isFresh) {
          printersModel = newModel;
          return Right(printersModel!.data ?? []);
        } else {
          printersModel!.data!.addAll(newModel.data ?? []);
          printersModel!.nextPageUrl = newModel.nextPageUrl;
          return Right(printersModel!.data ?? []);
        }
      } else {
        debugPrint('API Error: ${response.message}');
        return Left(response);
      }
    } catch (e) {
      debugPrint(' Exception in getPrinters: $e');
      return Left(ApiResponse.unKnownError());
    }
  }

  Future<Either<ApiResponse, Unit>> addPrinter({
    required PrinterModel printer,
    required List<CategoryRowsModel> categoryRows,
  }) async {
    try {
      // printer.printer.
      final url = await ApiEndPoints.getPrinters();

      Map<String, dynamic> printerData = printer.toJson(categoryRows);
      final savePrinters=  await PrinterHelper.saveLocalPrinter(printerData);

      debugPrint("------------\n  printData${savePrinters} $printerData   \n----------------");
      final response = await api.post(url: url, data: printerData);
      debugPrint('Response Data: ${response.data}');
      if (response.status) {
        return Right(unit);
      } else {
        debugPrint('API Error: ${response.message}');
        return Left(response);
      }
    } catch (e) {
      debugPrint('Exception in addPrinter: $e');
      return Left(ApiResponse.unKnownError());
    }
  }

  Future<Either<ApiResponse, Unit>> updatePrinter({
    required PrinterModel printer,
    required List<CategoryRowsModel> categoryRows,
  }) async {
    try {
      final String url = await ApiEndPoints.getPrinters();
      Map<String, dynamic> data = printer.toJson(categoryRows);
      final updatePrinter=    await PrinterHelper.updateLocalPrinter(data);
      final response = await api.post(
        url: "$url/${printer.id}",
        data: data,
      );

      if (response.status) {
        debugPrint(" Printer updated successfully:");
        return Right(unit);
      } else {
        debugPrint(" API Error: ${response.message}");
        return Left(response);
      }
    } catch (e) {
      debugPrint(" Exception in updatePrinter: $e");
      return Left(ApiResponse.unKnownError());
    }
  }

  Future<Either<ApiResponse, int>> deletePrinter({
    required int id,
  }) async {
    try {
      String url = await ApiEndPoints.getPrinters();
     final deletePrinters= await PrinterHelper.deleteLocalPrinter(id);
      var response = await api.delete(
        url: "$url/$id",
      );
      if (response.status) {
        return Right(id);
      } else {
        return Left(
          response,
        );
      }
    } catch (e) {
      debugPrint(e.toString());
      return Left(
        ApiResponse.unKnownError(),
      );
    }
  }
}
