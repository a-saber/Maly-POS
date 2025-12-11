import 'dart:async';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:thermal_printer/thermal_printer.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'dart:ui' as ui;
import 'package:image/image.dart' as img;
import 'dart:typed_data';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

import '../../features/selling_point/view/widget/invoice.dart';

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
  Future<bool> ensureBluetoothPermissions() async {
    if (!await Permission.bluetoothScan.isGranted) {
      await Permission.bluetoothScan.request();
    }

    if (!await Permission.bluetoothConnect.isGranted) {
      await Permission.bluetoothConnect.request();
    }

    // LOCATION REQUIRED for BLE scanning in Android
    if (!await Permission.location.isGranted) {
      await Permission.location.request();
    }

    final locationService = await Permission.location.serviceStatus;
    if (!locationService.isEnabled) {
      return false;
    }


    final scanStatus = await Permission.bluetoothScan.status;
    final connectStatus = await Permission.bluetoothConnect.status;
    final locationStatus = await Permission.location.status;

    return scanStatus.isGranted &&
        connectStatus.isGranted &&
        locationStatus.isGranted;
  }
  Future<bool>  isSunmiDevice() async {
    try {
      if (!kIsWeb) {
        final deviceInfo = DeviceInfoPlugin();
        final androidInfo = await deviceInfo.androidInfo;
        final manufacturer = androidInfo.manufacturer.toLowerCase();
        final brand = androidInfo.brand.toLowerCase();

        return manufacturer.contains('sunmi') || brand.contains('sunmi');
      }
      return false;
    } catch (e) {
      debugPrint('Error checking if Sunmi device: $e');
      return false;
    }
  }

  Future<void> startScan({VoidCallback? onUpdate}) async {
    _devices.clear();

    // Bluetooth (classic)
    final subBt = _manager
        .discovery(type: PrinterType.bluetooth, isBle: false)
        .listen((d) {
      _addOrUpdateDevice(d, PrinterType.bluetooth, isBle: false);
      onUpdate?.call();
    }, onError: (e) => debugPrint('BT discovery error: $e'));
    _subscriptions.add(subBt);

    // Bluetooth Low Energy
    final subBle = _manager
        .discovery(type: PrinterType.bluetooth, isBle: true)
        .listen((d) {
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

  void _addOrUpdateDevice(PrinterDevice d, PrinterType type,
      {bool isBle = false}) {
    final key = _deviceKey(d, type);
    _devices[key] = DiscoveredPrinter(device: d, type: type, isBle: isBle);
  }

  String _deviceKey(PrinterDevice d, PrinterType type) {
    if (d.address != null && d.address!.isNotEmpty) {
      return '${type.name}_${d.address}';
    }
    return '${type.name}_${d.vendorId ?? 'v'}_${d.productId ?? 'p'}_${d.name}';
  }

  /// --- PRINTING SECTION ---

  Future<void> printTest(DiscoveredPrinter printer,{String? paperSize}) async {
   try {
      final bytes = await _buildTestBytes(printer, paperSize: paperSize);
      await _printBytes(printer, bytes);
    } catch (e) {
      debugPrint('Print Test Error: $e');
      rethrow;
    }
  }

  Future<void> printInvoice(
      DiscoveredPrinter printer, Uint8List bytes,
      {String? paperSize, bool openCashDrawer = false}) async {

    try {

     final invoice= await  convertPdfToThermalPrinter( bytes)??[];

      final byte = await addCutCommand(invoice,paperSize??'80');
      await _printBytes(printer, byte);
    } catch (e) {
      debugPrint(' Print Invoice Error: $e');
      rethrow;
    }
  }
  Future<List<int>>  addCutCommand(List<int> pdfBytes,String paperSize) async {
      final profile = await CapabilityProfile.load();
      final size = _getPaperSize(paperSize);
      final generator = Generator(size, profile);

      return [
        ...pdfBytes,
        ...generator.feed(2),
        ...generator.cut(),
        ];
    }


// Convert PDF to ESC/POS printer format

  Future<List<int>?> convertPdfToThermalPrinter(Uint8List pdfBytes) async {
    try {
      debugPrint('Starting PDF to thermal conversion...');

      // Convert PDF to raster images and collect as list
      final pages = await Printing.raster(
        pdfBytes,
        dpi: 203, // 203 DPI for most 80mm thermal printers
        pages: [0], // Only first page
      ).toList();

      if (pages.isEmpty) {
        debugPrint('❌ No pages generated from PDF');
        return null;
      }

      debugPrint('✓ PDF converted to raster (${pages.length} page(s))');

      // Get first page and convert to PNG
      final rasterImage = await pages.first.toPng();
      debugPrint('✓ PNG generated: ${rasterImage.length} bytes');

      // Decode PNG to image object
      img.Image? image = img.decodeImage(rasterImage);

      if (image == null) {
        debugPrint('❌ Failed to decode image');
        return null;
      }

      debugPrint('✓ Image decoded: ${image.width}x${image.height} pixels');

      // Convert to grayscale for thermal printing
      img.Image grayscale = img.grayscale(image);

      // Adjust contrast and brightness for better thermal output
      grayscale = img.adjustColor(
        grayscale,
        contrast: 1.3,
        brightness: 1.1,
      );

      debugPrint('✓ Image processed for thermal printing');

      // Convert to ESC/POS format
      final escPosBytes = _convertToEscPos(grayscale);

      debugPrint('✅ Converted to ESC/POS: ${escPosBytes.length} bytes');

      return escPosBytes;

    } catch (e, stackTrace) {
      debugPrint('❌ Error: $e');
      debugPrint('Stack trace: $stackTrace');
      return null;
    }
  }

// Convert image to ESC/POS bitmap format
  List<int> _convertToEscPos(img.Image image) {
    List<int> bytes = [];

    // Initialize printer
    bytes.addAll([0x1B, 0x40]); // ESC @ - Initialize

    int width = image.width;
    int height = image.height;
    int widthBytes = (width + 7) ~/ 8;

    // ESC/POS GS v 0 command
    bytes.addAll([0x1D, 0x76, 0x30, 0x00]);
    bytes.addAll([widthBytes & 0xFF, (widthBytes >> 8) & 0xFF]);
    bytes.addAll([height & 0xFF, (height >> 8) & 0xFF]);

    // Convert pixels to monochrome bitmap
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x += 8) {
        int byte = 0;
        for (int b = 0; b < 8; b++) {
          if (x + b < width) {
            final pixel = image.getPixel(x + b, y);
            final brightness = pixel.r.toInt();
            if (brightness < 128) {
              byte |= (1 << (7 - b));
            }
          }
        }
        bytes.add(byte);
      }
    }

    // Feed paper
    bytes.addAll([0x0A, 0x0A, 0x0A]);

    return bytes;
  }

  Future<Uint8List?> captureWidget( BuildContext context,Widget widget) async {
    try {

      final boundary = RenderRepaintBoundary();
      final renderView = RenderView(
        view: View.of(context),
        child: RenderPositionedBox(

          alignment: Alignment.topCenter,
          child: boundary,
        ),
        configuration: ViewConfiguration(
          physicalConstraints: BoxConstraints(minWidth: 384, maxWidth: 384, minHeight: 200, maxHeight: double.infinity),
          logicalConstraints: BoxConstraints(minWidth: 384, maxWidth: 384, minHeight: 200, maxHeight: double.infinity),
          devicePixelRatio: 2.0, // Higher DPI for crisp printing
        ),
      );





      final pipelineOwner = PipelineOwner();
      final buildOwner = BuildOwner(focusManager: FocusManager());

      pipelineOwner.rootNode = renderView;
      renderView.prepareInitialFrame();

      final rootElement = RenderObjectToWidgetAdapter<RenderBox>(
        container: boundary,
        child: Directionality(
          textDirection: ui.TextDirection.rtl ,
          child: widget,
        ),
      ).attachToRenderTree(buildOwner);

      buildOwner.buildScope(rootElement);
      buildOwner.finalizeTree();

      pipelineOwner.flushLayout();
      pipelineOwner.flushCompositingBits();
      pipelineOwner.flushPaint();

      final image = await boundary.toImage(pixelRatio: 2.0);

      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      return byteData?.buffer.asUint8List();
    } catch (e) {
      debugPrint('Error capturing widget: $e');
      return null;
    }
  }
  // Convert widget image to printer format
  Future<List<int>?> convertWidgetToPrinterBytes(BuildContext context, Widget widget) async {
    // Capture widget as image
    final Uint8List? imageBytes = await captureWidget(context, widget);

    if (imageBytes == null) {
      debugPrint('Failed to capture widget');
      return null;
    }

    // Decode PNG image
    img.Image? image = img.decodeImage(imageBytes);

    if (image == null) {
      debugPrint('Failed to decode image');
      return null;
    }

    // Convert to grayscale for better printing
    img.Image grayscale = img.grayscale(image);

    // Adjust contrast for thermal printers (optional but recommended)
    grayscale = img.adjustColor(grayscale, contrast: 1.2);

    // Convert to ESC/POS bitmap format
    List<int> bytes = [];

    int width = grayscale.width;
    int height = grayscale.height;
    int widthBytes = (width + 7) ~/ 8; // Round up to nearest byte

    // ESC/POS image command: GS v 0
    bytes.addAll([0x1D, 0x76, 0x30, 0x00]);
    bytes.addAll([widthBytes & 0xFF, (widthBytes >> 8) & 0xFF]); // width in bytes
    bytes.addAll([height & 0xFF, (height >> 8) & 0xFF]); // height in pixels

    // Convert pixels to monochrome bitmap
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x += 8) {
        int byte = 0;
        for (int b = 0; b < 8; b++) {
          if (x + b < width) {
            // Get pixel as Pixel object
            final pixel = grayscale.getPixel(x + b, y);

            // Get luminance from the pixel (average of RGB values)
            final luminance = (pixel.r + pixel.g + pixel.b) / 3;

            // Threshold: pixels darker than 128 become black
            if (luminance < 128) {
              byte |= (1 << (7 - b));
            }
          }
        }
        bytes.add(byte);
      }
    }

    return bytes;
  }
  // Usage example
  Future<void> printWidget(BuildContext context, DiscoveredPrinter printer, ) async {


    // Convert widget to printer bytes
    final List<int>? printerBytes = await convertWidgetToPrinterBytes(context, InvoicePrintWidget());

    if (printerBytes != null) {
      _printBytes( printer, printerBytes);
      debugPrint('Widget sent to printer successfully');
    } else {
      debugPrint('Failed to convert widget to printer format');
    }
  }

 Future<void> _printBytes(DiscoveredPrinter printer, List<int> bytes,{Uint8List?unit8List}) async {
    final type = printer.type;
    final device = printer.device;

    try {
   
      await _connectWithTimeout(type, device, printer.isBle);
      

      _manager.send(type: type, bytes: bytes);

      
     
      await Future.delayed(Duration(milliseconds: 500 + (bytes.length ~/ 10)));

      
      await _manager.disconnect(type: type);
      
    } catch (e) {
      debugPrint(' Print error: $e');
      await _safeDisconnect(type);
      rethrow;
    }
  }


  Future<void> _connectWithTimeout(
    PrinterType type,
    PrinterDevice device,
    bool isBle,
  ) async {
    await Future.any([
      _connect(type, device, isBle),
      Future.delayed(const Duration(seconds: 10), () {
        // throw TimeoutException('Connection timeout after 10 seconds');
      }),
    ]);
  }

  Future<void> _connect(PrinterType type, PrinterDevice device, bool isBle) async {
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
        if (device.address == null) {
          throw Exception('Bluetooth printer missing address');
        }
        await _manager.connect(
          type: PrinterType.bluetooth,
          model: BluetoothPrinterInput(
            name: device.name,
            address: device.address!,
            isBle: isBle,
            autoConnect: false,
          ),
        );
        break;
      case PrinterType.network:
        if (device.address == null) {
          throw Exception('Network printer missing IP');
        }
        await _manager.connect(
          type: PrinterType.network,
          model: TcpPrinterInput(ipAddress: device.address!),
        );
        break;
    }
  }

  Future<void> _safeDisconnect(PrinterType type) async {
    try {
      await _manager.disconnect(type: type);
    } catch (_) {}
  }

PaperSize _getPaperSize(String? paperSize) {
  debugPrint('');
  debugPrint('==================== DEBUG PAPER SIZE ====================');
  debugPrint(' Input paperSize: "$paperSize"');
  debugPrint(' paperSize type: ${paperSize.runtimeType}');
  
  if (paperSize == null) {
    debugPrint(' paperSize is NULL - Using default 80mm');
    debugPrint('==========================================================');
    return PaperSize.mm80;
  }
  
  final cleanSize = paperSize.toLowerCase().replaceAll('mm', '').trim();
  debugPrint(' Clean size after removing "mm": "$cleanSize"');
  
  PaperSize result;
  switch (cleanSize) {
    case '80':
      result = PaperSize.mm80;
      debugPrint(' Selected: 80mm');
      break;
    case '72':
      result = PaperSize.mm72;
      debugPrint(' Selected: 72mm');
      break;
    case '58':
      result = PaperSize.mm58;
      debugPrint(' Selected: 58mm');
      break;
    default:
      result = PaperSize.mm80;
      debugPrint(' Unknown size "$cleanSize" - Using default 80mm');
      break;
  }
  
  debugPrint('==========================================================');
  debugPrint('');
  return result;
}
  /// --- CONTENT GENERATORS ---

  Future<List<int>> _buildTestBytes(DiscoveredPrinter p, {String? paperSize}) async {
    final profile = await CapabilityProfile.load();
     final size = _getPaperSize(paperSize);
    final generator = Generator(size, profile);

    return [
      ...generator.setGlobalCodeTable('CP437'),
      ...generator.text('***************',
          styles: PosStyles(align: PosAlign.center, bold: true)),
      ...generator.text('   TEST PRINT   ',
          styles: PosStyles(align: PosAlign.center, bold: true)),
      ...generator.text('***************', styles: PosStyles(align: PosAlign.center, bold: true)),
      ...generator.hr(),
      ...generator.text('Printer: ${p.device.name}'),
      if (p.device.address != null)
        ...generator.text('Address: ${p.device.address}'),
      ...generator.feed(2),
      ...generator.cut(),
    ];
  }

  Future<List<int>> _buildInvoiceBytes(
      DiscoveredPrinter p, Map<String, dynamic> invoice,
      {
    String? paperSize, required bool openCashDrawer,
  }) async {
    final profile = await CapabilityProfile.load();
    final size = _getPaperSize(paperSize);
    final generator = Generator(size, profile);

    final items = (invoice['items'] as List<dynamic>? ?? [])
        .map((item) =>
            '${item['name']} x${item['qty']}  ${item['price']} = ${item['total']}')
        .toList();

    return [
      if (openCashDrawer) ...generator.drawer(),
      ...generator.text('*************** INVOICE ***************',
          styles: PosStyles(align: PosAlign.center, bold: true)),
      ...generator.text('Date: ${invoice['date'] ?? ''}'),
      ...generator.text('Invoice #: ${invoice['id'] ?? ''}'),
      ...generator.hr(),
      ...items.expand((line) => generator.text(line)),
      ...generator.hr(),
      ...generator.text('Total: ${invoice['total'] ?? '0.00'}',
          styles: PosStyles(align: PosAlign.right, bold: true)),
      ...generator.feed(2),
      ...generator.cut(),
    ];
  }

  Future<void> printTestByIp(String ip, {int port = 9100, String? paperSize}) async {
    try {
      final profile = await CapabilityProfile.load();
      final size = _getPaperSize(paperSize);
      final generator = Generator(size, profile);

      List<int> bytes = [];
      bytes += generator.text(
        'Test Print Successful by IP',
        styles: PosStyles(bold: true, align: PosAlign.center),
        linesAfter: 2,
      );

      final socket =
          await Socket.connect(ip, port, timeout: const Duration(seconds: 3));
      socket.add(bytes);
      await socket.flush();
      await socket.close();
    } catch (e) {
      debugPrint("Print error: $e");
    }
  }
}

