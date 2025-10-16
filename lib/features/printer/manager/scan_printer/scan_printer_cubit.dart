// scan_printers_cubit.dart
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/helper/printer_helper.dart';
import 'package:pos_app/features/printer/manager/scan_printer/scan_printer_state.dart';


class ScanPrintersCubit extends Cubit<ScanPrintersState> {
  ScanPrintersCubit() : super(ScanPrintersInitial());
  static ScanPrintersCubit get(context) => BlocProvider.of<ScanPrintersCubit>(context);
  final PrinterHelper _helper = PrinterHelper();
  final List<DiscoveredPrinter> _printers = [];
  Timer? _debounceTimer;

  List<DiscoveredPrinter> get printers => List.unmodifiable(_printers);

  bool _scanning = false;
  bool get isScanning => _scanning;

  /// Start scanning. If force==false and we already have results, it will emit them.
  Future<void> startScan({bool force = false}) async {
    if (!force && _printers.isNotEmpty) {
      emit(ScanPrintersSuccess(printers: printers));
      return;
    }

    emit(ScanPrintersLoading());
    _scanning = true;

    try {
      await _helper.startScan(onUpdate: () {
        // debounce rapid updates
        _debounceTimer?.cancel();
        _debounceTimer = Timer(const Duration(milliseconds: 250), () {
          _syncFromHelper();
        });
      });

      // immediately sync initial found devices (if any)
      _syncFromHelper();
    } catch (e) {
      emit(ScanPrintersFailing(error: e));
    }
  }

  void _syncFromHelper() {
    _printers
      ..clear()
      ..addAll(_helper.discoveredDevices.values.toList());

    if (_printers.isEmpty) {
      emit(ScanPrintersSuccess(printers: []));
    } else {
      emit(ScanPrintersSuccess(printers: printers));
    }
  }

  Future<void> stopScan({bool clear = false}) async {
    try {
      await _helper.stopScan();
    } catch (_) {}
    _debounceTimer?.cancel();
    _scanning = false;
    if (clear) {
      _printers.clear();
      emit(ScanPrintersSuccess(printers: []));
    } else {
      // emit last-known (could be empty)
      emit(ScanPrintersSuccess(printers: printers));
    }
  }

  Future<void> refresh() async {
    await stopScan(clear: true);
    await startScan(force: true);
  }

  Future<void> printTest(DiscoveredPrinter p) async {
    try {
      await _helper.printTest(p);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    _helper.stopScan();
    return super.close();
  }
}
