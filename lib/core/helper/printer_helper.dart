import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:thermal_printer/thermal_printer.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';

/// Wrapper that pairs a discovered PrinterDevice with its PrinterType
class DiscoveredPrinter {
  final PrinterDevice device;
  final PrinterType type;
  final bool isBle; // optional flag for bluetooth low energy

  DiscoveredPrinter({
    required this.device,
    required this.type,
    this.isBle = false,
  });
}

/// PrinterHelper is a single service responsible for:
/// - Scanning available printers
/// - Managing connections
/// - Building and sending print jobs
class PrinterHelper {
  final PrinterManager _manager = PrinterManager.instance;
  final Map<String, DiscoveredPrinter> _devices = {};
  final List<StreamSubscription<PrinterDevice>> _subscriptions = [];

  /// Returns a list of discovered printers
  Map<String, DiscoveredPrinter> get discoveredDevices => _devices;

  /// --- DEVICE SCANNING SECTION ---

  Future<void> startScan({VoidCallback? onUpdate}) async {
    _devices.clear();

    // Bluetooth (classic)
    final subBt = _manager.discovery(type: PrinterType.bluetooth, isBle: false).listen((d) {
      _addOrUpdateDevice(d, PrinterType.bluetooth, isBle: false);
      onUpdate?.call();
    }, onError: (e) => debugPrint('BT discovery error: $e'));
    _subscriptions.add(subBt);

    // Bluetooth Low Energy
    final subBle = _manager.discovery(type: PrinterType.bluetooth, isBle: true).listen((d) {
      _addOrUpdateDevice(d, PrinterType.bluetooth, isBle: true);
      onUpdate?.call();
    }, onError: (e) => debugPrint('BLE discovery error: $e'));
    _subscriptions.add(subBle);

    // USB
    final subUsb = _manager.discovery(type: PrinterType.usb).listen((d) {
      _addOrUpdateDevice(d, PrinterType.usb);
      onUpdate?.call();
    }, onError: (e) => debugPrint('USB discovery error: $e'));
    _subscriptions.add(subUsb);

    // Network (WiFi/Ethernet)
    final subNet = _manager.discovery(type: PrinterType.network).listen((d) {
      _addOrUpdateDevice(d, PrinterType.network);
      onUpdate?.call();
    }, onError: (e) => debugPrint('Network discovery error: $e'));
    _subscriptions.add(subNet);
  }

  Future<void> stopScan() async {
    for (final s in _subscriptions) {
      await s.cancel();
    }
    _subscriptions.clear();
  }

  void _addOrUpdateDevice(PrinterDevice d, PrinterType type, {bool isBle = false}) {
    final key = _deviceKey(d, type);
    _devices[key] = DiscoveredPrinter(device: d, type: type, isBle: isBle);
  }

  String _deviceKey(PrinterDevice d, PrinterType type) {
    if (d.address != null && d.address!.isNotEmpty) return '${type.name}_${d.address}';
    return '${type.name}_${d.vendorId ?? 'v'}_${d.productId ?? 'p'}_${d.name ?? 'n'}';
  }

  /// --- PRINTING SECTION ---

  Future<void> printTest(DiscoveredPrinter printer) async {
    final bytes = await _buildTestBytes(printer);
    await _printBytes(printer, bytes);
  }

  Future<void> printInvoice(DiscoveredPrinter printer, Map<String, dynamic> invoice) async {
    final bytes = await _buildInvoiceBytes(printer, invoice);
    await _printBytes(printer, bytes);
  }

  Future<void> _printBytes(DiscoveredPrinter printer, List<int> bytes) async {
    final type = printer.type;
    final device = printer.device;

    try {
      switch (type) {
        case PrinterType.usb:
          await _manager.connect(
            type: PrinterType.usb,
            model: UsbPrinterInput(
              name: device.name,
              vendorId: device.vendorId,
              productId: device.productId,
            ),
          );
          break;
        case PrinterType.bluetooth:
          if (device.address == null) throw Exception('Bluetooth printer missing address');
          await _manager.connect(
            type: PrinterType.bluetooth,
            model: BluetoothPrinterInput(
              name: device.name,
              address: device.address!,
              isBle: printer.isBle,
              autoConnect: false,
            ),
          );
          break;
        case PrinterType.network:
          if (device.address == null) throw Exception('Network printer missing IP');
          await _manager.connect(
            type: PrinterType.network,
            model: TcpPrinterInput(ipAddress: device.address!),
          );
          break;
        default:
          throw Exception('Unsupported printer type');
      }

      _manager.send(type: type, bytes: bytes);
      await Future.delayed(const Duration(milliseconds: 300));
      await _manager.disconnect(type: type);
    } catch (e) {
      await _safeDisconnect(type);
      rethrow;
    }
  }

  Future<void> _safeDisconnect(PrinterType type) async {
    try {
      await _manager.disconnect(type: type);
    } catch (_) {}
  }

  /// --- CONTENT GENERATORS ---

  Future<List<int>> _buildTestBytes(DiscoveredPrinter p) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);

    return [
      ...generator.setGlobalCodeTable('CP437'),
      ...generator.text('***************',
          styles: PosStyles(align: PosAlign.center, bold: true)),
      ...generator.text('   TEST PRINT   ',
          styles: PosStyles(align: PosAlign.center, bold: true)),
      ...generator.text('***************',
          styles: PosStyles(align: PosAlign.center, bold: true)),
      ...generator.hr(),
      ...generator.text('Printer: ${p.device.name ?? "Unknown"}'),
      if (p.device.address != null)
        ...generator.text('Address: ${p.device.address}'),
      ...generator.feed(2),
      ...generator.cut(),
    ];
  }

  Future<List<int>> _buildInvoiceBytes(
      DiscoveredPrinter p, Map<String, dynamic> invoice) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);

    final items = (invoice['items'] as List<dynamic>? ?? [])
        .map((item) =>
    '${item['name']} x${item['qty']}  ${item['price']} = ${item['total']}')
        .toList();

    return [
      ...generator.text('*************** INVOICE ***************',
          styles: PosStyles(align: PosAlign.center, bold: true)),
      ...generator.text('Date: ${invoice['date'] ?? ''}'),
      ...generator.text('Invoice #: ${invoice['id'] ?? ''}'),
      ...generator.hr(),
      ...items.expand((line) => generator.text(line)).toList(),
      ...generator.hr(),
      ...generator.text('Total: ${invoice['total'] ?? '0.00'}',
          styles: PosStyles(align: PosAlign.right, bold: true)),
      ...generator.feed(2),
      ...generator.cut(),
    ];
  }
}
