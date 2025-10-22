import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/constant/constant.dart';
import 'package:pos_app/core/helper/printer_helper.dart';
import 'package:pos_app/features/printer/data/repo/printer_repo.dart';
import 'package:pos_app/features/printer/manager/scan_printer/scan_printer_state.dart';

class ScanPrintersCubit extends Cubit<ScanPrintersState> {
  ScanPrintersCubit(this._repo) : super(ScanPrintersInitial());

  static ScanPrintersCubit get(context) =>
      BlocProvider.of<ScanPrintersCubit>(context);

  final PrinterHelper _helper = PrinterHelper();
  final PrinterRepo _repo;
  final List<dynamic> _printers = [];
  Timer? _debounceTimer;
  final ScrollController scrollController = ScrollController();
  bool _scanning = false;
  bool get isScanning => _scanning;
  List<dynamic> get printers => List.unmodifiable(_printers);
  bool canLoading() {
    return _repo.printersModel?.nextPageUrl != null &&
        _repo.printersModel!.nextPageUrl!.isNotEmpty;
  }

  bool isFirtsTime() => _repo.printersModel == null;

  void init() {
    if (isFirtsTime()) {
      fetchPrintersFromApi();
    }

    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        if (canLoading()) {
          fetchPrintersFromApi();
        }
      }
    });
  }

  bool ifScrollNotFillScreen() {
    if (!scrollController.hasClients) return false;
    return scrollController.position.maxScrollExtent == 0;
  }

  void ifNotFillScreen() {
    if (!canLoading()) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ifScrollNotFillScreen()) {
        if (_scanning) return;

        _scanning = true;
        Future.delayed(
          const Duration(seconds: AppConstant.callPaginationSeconds),
          () async {
            log("getPaginationProducts");
            await fetchPrintersFromApi();
            _scanning = false;
          },
        );
      }
    });
  }

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
  Future<void> fetchPrintersFromApi({bool isFresh = false}) async {
    if (isFresh) {
      emit(ScanPrintersLoading());
      _printers.clear();
      _repo.printersModel = null;
    }

    try {
      final result = await _repo.getPrinters(isFresh: isFresh);

      result.fold(
        (failure) => emit(ScanPrintersFailing(error: failure)),
        (apiPrinters) {
          if (apiPrinters.isEmpty) return;
          final existingIds = _printers.map((p) => p.id).toSet();
          final uniqueNewPrinters =
              apiPrinters.where((p) => !existingIds.contains(p.id)).toList();

          _printers.addAll(uniqueNewPrinters);

          emit(ScanPrintersSuccess(printers: List.from(_printers)));
          ifNotFillScreen();
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
