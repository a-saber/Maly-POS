import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/core/helper/printer_helper.dart';

abstract class ScanPrintersState {}

class ScanPrintersInitial extends ScanPrintersState {}

class ScanPrintersLoading extends ScanPrintersState {}

class ScanPrintersSuccess extends ScanPrintersState {
  final List<DiscoveredPrinter> discoveredPrinters;

  ScanPrintersSuccess({required this.discoveredPrinters});
}

class ScanPrintersFailing extends ScanPrintersState {
  final ApiResponse? errMessage;
  final String? message;

  ScanPrintersFailing({ this.errMessage, this.message});
}
