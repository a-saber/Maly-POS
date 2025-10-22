import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:pos_app/core/api/api_helper.dart';
import 'package:pos_app/core/api/api_keys.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/features/printer/data/model/post_printers_model.dart';
import 'package:pos_app/features/printer/data/model/printers_search_model.dart';
import 'package:pos_app/features/printer/data/model/update_printers_model.dart';

class PrinterRepo {
  PrintersModel? printersModel;
  final ApiHelper api;
  PrinterRepo({required this.api});
  Future<Either<ApiResponse, List<Data>>> getPrinters({
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
        url = printersModel!.nextPageUrl!;
      }

      final response = await api.get(
        url: url,
        data: {
          ApiKeys.search: query,
        },
      );

      if (response.status) {
        final newModel = PrintersModel.fromJson(response.data);

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

  Future<Either<ApiResponse, AddPrinters>> addPrinter({
    required AddPrinters printer,
  }) async {
    try {
      final url = await ApiEndPoints.getPrinters();
      Map<String, dynamic> printerData = printer.toJson();
      printerData['categories'] = printer.printer?.categories ?? [];
      debugPrint('Request Data: $printerData');

      final response = await api.post(url: url, data: printerData);
      debugPrint('Response Data: ${response.data}');

      if (response.status) {
        final addedPrinter = AddPrinters.fromJson(response.data);
        if (addedPrinter.printer != null) {
          return Right(addedPrinter);
        } else {
          return Left(response);
        }
      } else {
        debugPrint('API Error: ${response.message}');
        return Left(response);
      }
    } catch (e) {
      debugPrint('Exception in addPrinter: $e');
      return Left(ApiResponse.unKnownError());
    }
  }

  Future<Either<ApiResponse, UpdatePrinters>> updatePrinter({
    required int id,
    required String printerName,
    required List<int> categoryIds,
  }) async {
    try {
      String url = await ApiEndPoints.getPrinters();
      Map<String, dynamic> data = {
        "printer_name": printerName,
        "categories": categoryIds.map((id) => {"category_id": id}).toList(),
      };

      debugPrint(" Sending to: $url/$id");
      debugPrint(" Body: $data");

      var response = await api.post(
        url: "$url/$id",
        data: data,
        isFormData: true,
      );
      if (response.status) {
        final printerModel = UpdatePrinters.fromJson(response.data);

        return Right(printerModel);
      } else {
        return Left(response);
      }
    } catch (e) {
      debugPrint(" Update Printer Error: $e");
      return Left(ApiResponse.unKnownError());
    }
  }
  Future<Either<ApiResponse, int>> deletePrinter({
    required int id,
  }) async {
    try {
      String url = await ApiEndPoints.getPrinters();
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
