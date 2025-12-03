import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/helper/printer_helper.dart';
import 'package:pos_app/features/printer/manager/scan_local_printers_cubit/scan_local_printers_state.dart';

class ScanLocalPrintersCubit extends Cubit<ScanLocalPrintersState> {
  ScanLocalPrintersCubit() : super(ScanLocalPrintersInitial());
  
  static ScanLocalPrintersCubit get(context) => BlocProvider.of(context);
  
  final PrinterHelper _helper = PrinterHelper();
  Timer? _scanTimer;
  Future<void> getDiscoveredPrinters() async {
    emit(ScanLocalPrintersLoading());
    
    try {
      await _helper.startScan(
        onUpdate: () {
          final printers = _helper.discoveredDevices.values.toList();
          emit(ScanLocalPrintersSuccess(printers));
        },
      );
      _scanTimer?.cancel();
      _scanTimer = Timer(const Duration(seconds: 8), () async {
        await _helper.stopScan();
        
        final printers = _helper.discoveredDevices.values.toList();
        
        if (printers.isEmpty) {
          emit(ScanLocalPrintersFailure(
            'No printers found. Please check:\n'
            '1. Bluetooth is enabled\n'
            '2. App has Bluetooth permissions\n'
            '3. Printer is powered on and in pairing mode'
          ));
        } else {
          emit(ScanLocalPrintersSuccess(printers));
        }
      });
      
    } catch (e) {
      await _helper.stopScan();
      emit(ScanLocalPrintersFailure(
        'Failed to scan: ${e.toString()}\n'
        'Make sure you have granted all required permissions.'
      ));
    }
  }
  
  @override
  Future<void> close() {
    _scanTimer?.cancel();
    _helper.stopScan();
    return super.close();
  }
}