import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:pos_app/features/selling_point/data/repo/selling_point_repo.dart';
import 'package:thermal_printer/thermal_printer.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';

import '../api/api_keys.dart';
import '../cache/custom_user_hive_box.dart';
import '../constant/app_invoice_string.dart';
import '../invoice/sales_invoices_pdf_80.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<void> testPrintAfterSaleAsPdf({
  required Map<String, dynamic> data,
  required String branchName,
  required double paid,
}) async {
  print('Generating PDF...');
  // توليد الريسيت بصيغة PDF
  Uint8List bytes = await salesInvoicesPdf80(
    data,
    branchName: branchName,
    paid: paid,
  );

  // نحفظه مؤقتًا
  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/test_receipt.pdf');
  await file.writeAsBytes(bytes);

  print('✅ PDF Saved at: ${file.path}');
}

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
    final bytes = await _buildInvoiceBytes(invoice);
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
      ...generator.text('  اختبار   ',
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

  Future<List<int>> _buildInvoiceBytes( Map<String, dynamic> invoice) async {
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
  Future<List<int>> _buildInvoiceBytesAfterSale(Map<String, dynamic> response,
      {String? branchName, required double paid, bool isMainPrinter = false}) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);

    final bytes = <int>[];

    try {
      final sale = response[ApiKeys.sale] ?? {};
      final setting = response[ApiKeys.settings] ?? {};
      final products = (sale[ApiKeys.saleproducts] ?? []) as List<dynamic>;

      // التاريخ والوقت
      DateTime? parsed;
      final createdAt = sale[ApiKeys.createdat]?.toString() ?? '';
      if (createdAt.isNotEmpty) {
        parsed = DateTime.tryParse(createdAt)?.toLocal();
      }
      final date = parsed != null
          ? "${parsed.year}-${parsed.month.toString().padLeft(2, '0')}-${parsed.day.toString().padLeft(2, '0')}"
          : '';
      final time = parsed != null
          ? "${parsed.hour.toString().padLeft(2, '0')}:${parsed.minute.toString().padLeft(2, '0')}:${parsed.second.toString().padLeft(2, '0')}"
          : '';

      // 🧾 العنوان / بيانات المتجر
      bytes.addAll(generator.text(
        AppInvoiceString.invoiceTitle,
        styles: const PosStyles(
          align: PosAlign.center,
          bold: true,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ),
      ));

      if(isMainPrinter){
        if (setting[ApiKeys.shopname] != null) {
          bytes.addAll(generator.text(setting[ApiKeys.shopname],
              styles: const PosStyles(align: PosAlign.center)));
        }
        if (setting[ApiKeys.phone] != null) {
          bytes.addAll(generator.text(setting[ApiKeys.phone],
              styles: const PosStyles(align: PosAlign.center)));
        }
        if (setting[ApiKeys.commercialno] != null) {
          bytes.addAll(generator.text(
              '${AppInvoiceString.numberOfDariba}: ${setting[ApiKeys.commercialno]}',
              styles: const PosStyles(align: PosAlign.center)));
        }
      }

      bytes.addAll(generator.hr());
      if (time.isNotEmpty || date.isNotEmpty) {
        bytes.addAll(generator.row([
          PosColumn(
            text: time,
            width: 6,
            styles: const PosStyles(align: PosAlign.left),
          ),
          PosColumn(
            text: date,
            width: 6,
            styles: const PosStyles(align: PosAlign.right),
          ),
        ]));
      }

      if (sale[ApiKeys.id] != null) {
        bytes.addAll(generator.text("${AppInvoiceString.sellingId} : ${sale[ApiKeys.id]}",
            styles: const PosStyles(align: PosAlign.center)));
      }
      if (sale[ApiKeys.ordertype] != null) {
        bytes.addAll(generator.text("${AppInvoiceString.orderType} ${sale[ApiKeys.ordertype]}",
            styles: const PosStyles(align: PosAlign.center)));
      }

      bytes.addAll(generator.hr(ch: '-'));

      // 🧱 جدول المنتجات
      if (products.isNotEmpty) {
        bytes.addAll(generator.row([
          PosColumn(
            text: AppInvoiceString.product,
            width: 6,
            styles: const PosStyles(bold: true, align: PosAlign.right),
          ),
          PosColumn(
            text: AppInvoiceString.quantity,
            width: 2,
            styles: const PosStyles(bold: true, align: PosAlign.center),
          ),
          PosColumn(
            text: AppInvoiceString.price,
            width: 2,
            styles: const PosStyles(bold: true, align: PosAlign.center),
          ),
          PosColumn(
            text: AppInvoiceString.total,
            width: 2,
            styles: const PosStyles(bold: true, align: PosAlign.left),
          ),
        ]));

        bytes.addAll(generator.hr());

        for (var p in products) {
          final name =  p[ApiKeys.product]?[ApiKeys.name]?.toString() ?? "";
          final qty = p[ApiKeys.quantity]?.toString() ?? "";
          final price = p[ApiKeys.price]?.toString() ?? "";
          final total = p[ApiKeys.linetotalafterdiscount]?.toString() ?? "";

          bytes.addAll(generator.row([
            PosColumn(text: name, width: 6, styles: const PosStyles(align: PosAlign.right)),
            PosColumn(text: qty, width: 2, styles: const PosStyles(align: PosAlign.center)),
            PosColumn(text: price, width: 2, styles: const PosStyles(align: PosAlign.center)),
            PosColumn(text: total, width: 2, styles: const PosStyles(align: PosAlign.left)),
          ]));
        }
      }

      bytes.addAll(generator.hr(ch: '='));

      if(isMainPrinter){
        // 💰 الإجماليات
        final subtotal = sale[ApiKeys.subtotal]?.toString();
        final discount = sale[ApiKeys.discounttotal]?.toString();
        final afterDiscount = sale[ApiKeys.totalafterdiscount]?.toString();
        final tax = sale[ApiKeys.taxtotal]?.toString();
        final totalAfterTax = sale[ApiKeys.totalaftertax]?.toString();
        final paymentMethod = sale[ApiKeys.paymentmethod]?.toString();

        void addRow(String label, String? value, {bool bold = false}) {
          if (value != null) {
            bytes.addAll(generator.row([
              PosColumn(
                  text: label,
                  width: 6,
                  styles: PosStyles(
                      align: PosAlign.right,
                      bold: bold,
                      height: bold ? PosTextSize.size2 : PosTextSize.size1)),
              PosColumn(
                  text: value,
                  width: 6,
                  styles: PosStyles(
                      align: PosAlign.left,
                      bold: bold,
                      height: bold ? PosTextSize.size2 : PosTextSize.size1)),
            ]));
          }
        }

        addRow(AppInvoiceString.totalBeforeTax, subtotal);
        addRow(AppInvoiceString.discount, discount);
        addRow(AppInvoiceString.totalAfterDiscount, afterDiscount);
        addRow(AppInvoiceString.tax, tax);
        addRow(AppInvoiceString.totalAfterTax, totalAfterTax, bold: true);
        addRow(AppInvoiceString.paymentMethod, paymentMethod);

        addRow(AppInvoiceString.paid, paid.toString(), bold: true);

        if (totalAfterTax != null) {
          final remain = ((paid - (double.tryParse(totalAfterTax) ?? 0)) * 100)
                  .truncateToDouble() /
              100;
          addRow(AppInvoiceString.remain, remain.toStringAsFixed(2));
        }

        bytes.addAll(generator.hr());

        // QR + شكراً
        if (sale[ApiKeys.zatcaQrcode] != null) {
          bytes.addAll(generator.qrcode(sale[ApiKeys.zatcaQrcode]));
        }

        bytes.addAll(generator.text(AppInvoiceString.thanks,
            styles: const PosStyles(align: PosAlign.center)));

        if (setting[ApiKeys.address] != null) {
          bytes.addAll(generator.text(setting[ApiKeys.address],
              styles: const PosStyles(align: PosAlign.center)));
        }

        // employee name
        if (CustomUserHiveBox.getUser().name != null) {
          bytes.addAll(generator.text(
              "${AppInvoiceString.employeeName} ${CustomUserHiveBox.getUser().name}",
              styles: const PosStyles(align: PosAlign.center)));
        }

        if (branchName != null) {
          bytes.addAll(generator.text(
              "${AppInvoiceString.branchName} $branchName",
              styles: const PosStyles(align: PosAlign.center)));
        }
      }

      bytes.addAll(generator.cut());
    } catch (e) {
      print('Error printing ${e.toString()}');
      bytes.addAll(generator.text('خطأ أثناء إنشاء الفاتورة',
          styles: const PosStyles(align: PosAlign.center, bold: true)));
      bytes.addAll(generator.cut());
    }

    return bytes;
  }


  Future<void> printAfterSale({ required List<ProductsPrinters> productsPrinters,
    required Map<String, dynamic> data, required String branchName, required double paid})async
  {
    print('called');
    for (var pp in productsPrinters) {
      testPrintAfterSaleAsPdf(data: data, paid: paid, branchName: branchName,);

      var bytes = await salesInvoicesPdf80(
        data,
        branchName: branchName, paid: paid
      );
      print("test: ${pp.printerModel.discoveredPrinter?.type} ${pp.isMainPrinter} ${pp.count} ${pp.categoryModel?.name}");
      if(pp.printerModel.discoveredPrinter != null){
        for(int i = 0; i < pp.count; i++) {
          _printBytes(pp.printerModel.discoveredPrinter!, bytes);
        }
      }
    }
  }
}
