import 'package:pos_app/core/helper/printer_helper.dart';

abstract class ScanLocalPrintersState {}

class ScanLocalPrintersInitial extends ScanLocalPrintersState {}

class ScanLocalPrintersLoading extends ScanLocalPrintersState {}

class ScanLocalPrintersSuccess extends ScanLocalPrintersState {
  final List<DiscoveredPrinter> discoveredPrinters;
  ScanLocalPrintersSuccess(this.discoveredPrinters);
}

class ScanLocalPrintersFailure extends ScanLocalPrintersState {
  final String message;
  ScanLocalPrintersFailure(this.message);
}