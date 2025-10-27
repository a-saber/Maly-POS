import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/features/printer/data/model/printer_model.dart';

abstract class GetPrintersState {}

class ScanPrintersInitial extends GetPrintersState {}

class ScanPrintersLoading extends GetPrintersState {}

class ScanPrintersSuccess extends GetPrintersState {
  final List<PrinterModel> printers;

  ScanPrintersSuccess({required this.printers});
}

class ScanPrintersFailing extends GetPrintersState {
  final ApiResponse? errMessage;
  final String? message;

  ScanPrintersFailing({ this.errMessage, this.message});
}
