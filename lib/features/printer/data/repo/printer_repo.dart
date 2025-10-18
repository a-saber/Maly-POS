import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:pos_app/core/api/api_helper.dart';
import 'package:pos_app/core/api/api_keys.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/features/printer/data/model/printers_search_model.dart';

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
      } else {
        if (printersModel!.nextPageUrl == null) {
          return const Right([]);
        } 
      }
      var response = await api.get(
        url: url,
        data: {
          ApiKeys.search: query,
        },
      );

      if (response.status) {
        printersModel = PrintersModel.fromJson(response.data);
        return Right(printersModel!.data ?? []);
      } else {
        debugPrint('API Error: ${response.message}');
        return Left(response);
      }
    } catch (e) {
      debugPrint(e.toString());
      return Left(ApiResponse.unKnownError());
    }
  }
}
