import 'dart:async';
import 'package:flutter/material.dart';
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
    // Check permissions first
    final hasPermissions = await _helper.ensureBluetoothPermissions();
    
    if (!hasPermissions) {
      emit(ScanLocalPrintersFailure(
        'Required permissions not granted.\n'
        'Please enable:\n'
        '1. Bluetooth permissions\n'
        '2. Location services (for Android < 12)\n'
        '3. Nearby Devices (for Android 13+)'
      ));
      return;
    }

    // Add a small delay to ensure permissions are fully processed
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Start scanning
    await _helper.startScan(
      onUpdate: () {
        final printers = _helper.discoveredDevices.values.toList();
        debugPrint('Found ${printers.length} printers');
        if (printers.isNotEmpty) {
          emit(ScanLocalPrintersSuccess(printers));
        }
      },
    );

    // Stop scan after 10 seconds (increased from 8)
    _scanTimer?.cancel();
    _scanTimer = Timer(const Duration(seconds: 10), () async {
      await _helper.stopScan();
      
      final printers = _helper.discoveredDevices.values.toList();
      debugPrint('Scan completed. Total printers: ${printers.length}');
      
      if (printers.isEmpty) {
        emit(ScanLocalPrintersFailure(
          'No printers found. Please check:\n'
          '1. Bluetooth is ON\n'
          '2. Location is ON (Android < 12)\n'
          '3. Printer is powered ON\n'
          '4. Printer is in pairing mode\n'
          '5. App has all required permissions'
        ));
      } else {
        emit(ScanLocalPrintersSuccess(printers));
      }
    });
    
  } catch (e) {
    debugPrint('Scan error: $e');
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