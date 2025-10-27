import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/constant/constant.dart';
import 'package:pos_app/features/printer/data/model/printer_model.dart';
import 'package:pos_app/features/printer/data/repo/printer_repo.dart';

import 'scan_printer_state.dart';

class GetPrintersCubit extends Cubit<GetPrintersState> {
  GetPrintersCubit(this._repo) : super(ScanPrintersInitial());

  static GetPrintersCubit get(context) =>
      BlocProvider.of<GetPrintersCubit>(context);

  final PrinterRepo _repo;
  final List<PrinterModel> _printers = [];
  final ScrollController scrollController = ScrollController();
  bool _scanning = false;
  bool get isScanning => _scanning;
  List<PrinterModel> get printers => List.unmodifiable(_printers);
  bool canLoading() {
    return _repo.printersModel?.nextPageUrl != null;
  }

  bool isFirstTime() => _repo.printersModel == null;

  void init() {
    if (isFirstTime()) {
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
        (failure) => emit(ScanPrintersFailing(errMessage: failure)),
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
      emit(ScanPrintersFailing(message: 'Failed to fetch printers'));
    }
  }

  void removePrinter(int id) {
    _printers.removeWhere((element) => element.id == id);
    emit(ScanPrintersSuccess(printers: List.from(_printers)));
  }
}
