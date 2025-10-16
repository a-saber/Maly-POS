// scan_printers_state.dart
import 'package:pos_app/core/helper/printer_helper.dart';

abstract class ScanPrintersState {}

class ScanPrintersInitial extends ScanPrintersState {}

class ScanPrintersLoading extends ScanPrintersState {}

class ScanPrintersSuccess extends ScanPrintersState {
  final List<DiscoveredPrinter> printers;
  ScanPrintersSuccess({required this.printers});
}

class ScanPrintersFailing extends ScanPrintersState {
  final Object error;
  ScanPrintersFailing({required this.error});
}
