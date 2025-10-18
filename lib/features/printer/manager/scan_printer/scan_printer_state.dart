abstract class ScanPrintersState {}

class ScanPrintersInitial extends ScanPrintersState {}

class ScanPrintersLoading extends ScanPrintersState {}

class ScanPrintersSuccess extends ScanPrintersState {
  final List<dynamic> printers;

  ScanPrintersSuccess({required this.printers});
}

class ScanPrintersFailing extends ScanPrintersState {
  final Object error;

  ScanPrintersFailing({required this.error});
}
