import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_helper.dart';
import 'package:pos_app/core/helper/printer_helper.dart';
import 'package:pos_app/features/printer/data/repo/printer_repo.dart';
import 'package:pos_app/features/printer/manager/scan_printer/scan_printer_state.dart';

class ScanPrintersCubit extends Cubit<ScanPrintersState> {
  ScanPrintersCubit(this._repo) : super(ScanPrintersInitial());


  static ScanPrintersCubit get(context) => BlocProvider.of<ScanPrintersCubit>(context);

  final PrinterHelper _helper = PrinterHelper();
  final PrinterRepo _repo;
  final List<dynamic> _printers = [];
  Timer? _debounceTimer;

  bool _scanning = false;
  bool get isScanning => _scanning;
  List<dynamic> get printers => List.unmodifiable(_printers);


  Future<void> startLocalScan({bool force = false}) async {
    if (!force && _printers.isNotEmpty) {
      emit(ScanPrintersSuccess(printers: printers));
      return;
    }

    emit(ScanPrintersLoading());
    _scanning = true;
    _printers.clear();

    try {
      await _helper.startScan(onUpdate: () {
        _debounceTimer?.cancel();
        _debounceTimer = Timer(const Duration(milliseconds: 250), () {
          _syncFromHelper();
        });
      });

      _syncFromHelper(); // sync immediately
    } catch (e) {
      emit(ScanPrintersFailing(error: e));
    } finally {
      _scanning = false;
    }
  }

  /// Fetch printers from API
  Future<void> fetchPrintersFromApi({bool isFresh = true}) async {
    emit(ScanPrintersLoading());
    _printers.clear();

    try {
      final result = await _repo.getPrinters(isFresh: isFresh);
      result.fold(
        (failure) => emit(ScanPrintersFailing(error: failure)),
        (apiPrinters) {
          _printers.addAll(apiPrinters);
          emit(ScanPrintersSuccess(printers: List.from(_printers)));
        },
      );
    } catch (e) {
      emit(ScanPrintersFailing(error: e));
    }
  }

  void _syncFromHelper() {
    _printers
      ..clear()
      ..addAll(_helper.discoveredDevices.values.toList());

    emit(ScanPrintersSuccess(printers: List.from(_printers)));
  }

  /// Stop scanning
  Future<void> stopScan({bool clear = false}) async {
    try {
      await _helper.stopScan();
    } catch (_) {}

    _debounceTimer?.cancel();
    _scanning = false;

    if (clear) _printers.clear();
    emit(ScanPrintersSuccess(printers: List.from(_printers)));
  }

  /// Refresh scan
  Future<void> refreshLocalScan() async {
    await stopScan(clear: true);
    await startLocalScan(force: true);
  }

  /// Print a test page
  Future<void> printTest(dynamic printer) async {
    try {
      await _helper.printTest(printer);
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
