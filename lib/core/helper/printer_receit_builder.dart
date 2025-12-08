import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart'; // or esc_pos_utils depending on your package
import 'package:http/http.dart' as http;
import 'package:flutter/widgets.dart'; // for ParagraphBuilder (raster text)
import 'package:intl/intl.dart'; // optional for formatting dates/currency
import 'package:image/image.dart' as img; // مهم جداً: استيراد مكتبة image مع اسم مستعار

/// Build ESC/POS bytes for 80mm paper using Generator.
/// - response: نفس الخريطة اللي كنت تمررها للـ PDF.
/// - paid: المدفوع
/// - branchName: اسم الفرع (اختياري)
/// - openCashDrawer: فتح الدراور قبل الطباعة
/// - useRasterForArabic: لو true سيحوّل النص العربي إلى صورة قبل الطباعة (يحل مشكلة التشكيل والRTL)
Future<List<int>> buildInvoiceBytesEscPos(
    Map<String, dynamic> response, {
      required double paid,
      String? branchName,
      bool openCashDrawer = false,
      bool useRasterForArabic = true,
      String paperSize = '80mm',
    }) async {
  final CapabilityProfile profile = await CapabilityProfile.load();
  final PaperSize size = (paperSize == '58mm') ? PaperSize.mm58 : PaperSize.mm80;
  final Generator generator = Generator(size, profile);

  final List<int> bytes = [];

  try {
    final sale = response['sale'] ?? {};
    final setting = response['settings'] ?? {};
    final products = (sale['saleproducts'] as List<dynamic>?) ?? [];

    // parse date/time
    String dateStr = '';
    String timeStr = '';
    final createdAt = sale['created_at']?.toString() ?? sale['createdat']?.toString() ?? '';
    if (createdAt.isNotEmpty) {
      final parsed = DateTime.tryParse(createdAt)?.toLocal();
      if (parsed != null) {
        dateStr = DateFormat('yyyy-MM-dd').format(parsed);
        timeStr = DateFormat('HH:mm:ss').format(parsed);
      }
    }

    // optional: fetch logo image bytes
    Uint8List? logoBytes;
    final logoUrl = setting['imageurl'] as String? ?? '';
    if (logoUrl.isNotEmpty) {
      try {
        final resp = await http.get(Uri.parse(logoUrl));
        if (resp.statusCode == 200) logoBytes = resp.bodyBytes;
      } catch (_) {
        logoBytes = null;
      }
    }

    // helper format number
    String fmt(dynamic v) {
      try {
        final d = double.tryParse(v?.toString() ?? '') ?? 0.0;
        return d.toStringAsFixed(2);
      } catch (e) {
        return '0.00';
      }
    }

    // helper to build product line: name | qty | price | total
    // because widths are limited, we truncate/pad name
    String productLine(Map p) {
      final name = p['product']?['name']?.toString() ?? p['name']?.toString() ?? '';
      final qty = p['quantity']?.toString() ?? p['qty']?.toString() ?? '';
      final price = fmt(p['price'] ?? p['unitprice']);
      final total = fmt(p['linetotalafterdiscount'] ?? p['total']);
      // adjust widths (these are approximate char counts; tweak if needed)
      final nameMax = 18;
      final shortName = name.length > nameMax ? name.substring(0, nameMax - 1) + '…' : name;
      // Build a single line with spacing; printer uses monospaced font
      // Format: [name (left)] [qty] [price] [total (right)]
      // We'll build with manual padding
      final qtyCol = qty.padLeft(3);
      final priceCol = price.padLeft(8);
      final totalCol = total.padLeft(9);
      return shortName.padRight(nameMax) + ' ' + qtyCol + ' ' + priceCol + ' ' + totalCol;
    }

    // Optionally open drawer
    if (openCashDrawer) {
      bytes.addAll(generator.drawer());
    }

    // Header: date/time
    if (dateStr.isNotEmpty || timeStr.isNotEmpty) {
      final header = '${timeStr.isNotEmpty ? timeStr : ''} ${dateStr.isNotEmpty ? dateStr : ''}'.trim();
      bytes.addAll(generator.text(header, styles: PosStyles(align: PosAlign.center)));
    }

    // Title
    bytes.addAll(generator.text('*** ${response['settings']?['shopname'] ?? 'فاتورة'} ***',
        styles: PosStyles(align: PosAlign.center, bold: true, height: PosTextSize.size2, width: PosTextSize.size2)));

    // Logo (if exists) - print as image (better for Arabic shop names in logo)
    if (logoBytes != null && logoBytes.isNotEmpty) {
      try {
        final img.Image? decodedImage = img.decodeImage(logoBytes);
        if (decodedImage != null) {
          bytes.addAll(generator.image(decodedImage)); // الآن النوع صحيح
        }
      } catch (e) {
        // fallback: ignore logo
      }
    }

    // Shop info
    if (setting['shopname'] != null) {
      bytes.addAll(generator.text(setting['shopname'].toString(), styles: PosStyles(align: PosAlign.center)));
    }
    if (setting['phone'] != null) {
      bytes.addAll(generator.text('Tel: ${setting['phone']}', styles: PosStyles(align: PosAlign.center)));
    }
    if (setting['commercialno'] != null) {
      bytes.addAll(generator.text('Reg#: ${setting['commercialno']}', styles: PosStyles(align: PosAlign.center)));
    }

    bytes.addAll(generator.hr());

    // Sale info: id, order type, payment method
    if (sale['id'] != null) bytes.addAll(generator.text('Invoice #: ${sale['id']}'));
    if (sale['ordertype'] != null) bytes.addAll(generator.text('Order Type: ${sale['ordertype']}'));
    if (sale['payment_method'] != null || sale['paymentmethod'] != null) {
      final pm = sale['payment_method'] ?? sale['paymentmethod'];
      bytes.addAll(generator.text('Payment: $pm'));
    }

    bytes.addAll(generator.hr());

    // Header row for products (we'll print a table-like header)
    // Because many printers LTR, we'll print columns: Name | QTY | Price | Total
    bytes.addAll(generator.text('Item'.padRight(18) + ' QTY  Price     Total',
        styles: PosStyles(bold: true)));

    // Products
    for (final p in products) {
      if (useRasterForArabic) {
        // Rasterize the product line (better for Arabic)
        final line = productLine(p);
        final ui.Image? rasterImage = await _rasterizeTextLine(line, size.width);
        if (rasterImage != null) {
          final img.Image? printableImage = await _convertUiImageToImage(rasterImage);
          if (printableImage != null) {
            bytes.addAll(generator.image(printableImage));
          }
        }
      } else {
        bytes.addAll(generator.text(productLine(p)));
      }
    }

    bytes.addAll(generator.hr());

    // Totals block
    final subtotal = fmt(sale['subtotal']);
    final discount = fmt(sale['discounttotal'] ?? sale['discount']);
    final totalAfterDiscount = fmt(sale['totalafterdiscount']);
    final tax = fmt(sale['taxtotal']);
    final totalAfterTax = fmt(sale['totalaftertax'] ?? sale['total']);
    final remain = (double.tryParse(totalAfterTax) ?? 0.0) - paid;

    // Utility to print key/value with alignment
    void printKeyValue(String key, String val, {bool bold = false}) {
      final left = key;
      final right = val;
      // We print as: left (label) then right aligned value on next column by padding
      final line = left.padRight(24) + right.padLeft(12);
      bytes.addAll(generator.text(line, styles: PosStyles(bold: bold)));
    }

    if ((sale['subtotal'] ?? sale['sub_total']) != null) printKeyValue('Subtotal', subtotal);
    if ((sale['discounttotal'] ?? sale['discount']) != null) printKeyValue('Discount', discount);
    if ((sale['totalafterdiscount']) != null) printKeyValue('After Discount', totalAfterDiscount);
    if ((sale['taxtotal']) != null) printKeyValue('Tax', tax);
    if ((sale['totalaftertax'] ?? sale['total']) != null) printKeyValue('Total', totalAfterTax, bold: true);

    // Paid and remain
    printKeyValue('Paid', paid.toStringAsFixed(2), bold: true);
    printKeyValue('Remain', remain.toStringAsFixed(2));

    bytes.addAll(generator.hr());

    // ZATCA QR (if present) — print as QR code
    if (sale['zatcaQrcode'] != null && sale['zatcaQrcode'].toString().isNotEmpty) {
      final qrData = sale['zatcaQrcode'].toString();
      bytes.addAll(generator.qrcode(qrData, size: QRSize.size8, align: PosAlign.center));
    }

    // Thanks / address / employee / branch
    bytes.addAll(generator.text(response['settings']?['thanks'] ?? 'شكرا لزيارتك',
        styles: PosStyles(align: PosAlign.center)));
    if (response['settings']?['address'] != null) {
      bytes.addAll(generator.text(response['settings']?['address'], styles: PosStyles(align: PosAlign.center)));
    }
    final employeeName = (response['user']?['name'] ?? response['employee'] ?? '')?.toString();
    if ( employeeName != null && employeeName.isNotEmpty) {
      bytes.addAll(generator.text('Employee: $employeeName', styles: PosStyles(align: PosAlign.center, height: PosTextSize.size1)));
    }
    if (branchName != null && branchName.isNotEmpty) {
      bytes.addAll(generator.text('Branch: $branchName', styles: PosStyles(align: PosAlign.center)));
    }

    bytes.addAll(generator.feed(3));
    bytes.addAll(generator.cut());

    return bytes;
  } catch (e) {
    // on error return an "error" text print so operator knows something happened
    final Generator gen = generator;
    final List<int> err = [];
    err.addAll(gen.text('Error building invoice: $e', styles: PosStyles(align: PosAlign.center)));
    err.addAll(gen.feed(2));
    err.addAll(gen.cut());
    return err;
  }
}
Future<List<int>> buildInvoiceBytesEscPosForArabic(
    Map<String, dynamic> response, {
      required double paid,
      String? branchName,
      bool openCashDrawer = false,
      bool useRasterForArabic = true,
      String paperSize = '80mm',
    }) async {
  final CapabilityProfile profile = await CapabilityProfile.load();
  final PaperSize size = (paperSize == '58mm') ? PaperSize.mm58 : PaperSize.mm80;
  final Generator generator = Generator(size, profile);

  final List<int> bytes = [];

  // دالة مساعدة لطباعة نص عربي (أو أي نص) كصورة
  Future<void> addTextRaster(String text, {bool bold = false, PosAlign align = PosAlign.right}) async {
    if (!useRasterForArabic) {
      bytes.addAll(generator.text(text, styles: PosStyles(bold: bold, align: align)));
      return;
    }
    final ui.Image? raster = await _rasterizeTextLine(text, size.width);
    if (raster != null) {
      final img.Image? printableImage = await _convertUiImageToImage(raster);
      if (printableImage != null) {
        bytes.addAll(generator.image(printableImage));
      } else {
        // fallback text
        bytes.addAll(generator.text(text, styles: PosStyles(bold: bold, align: align)));
      }
    } else {
      // fallback text
      bytes.addAll(generator.text(text, styles: PosStyles(bold: bold, align: align)));
    }
  }

  try {
    final sale = response['sale'] ?? {};
    final setting = response['settings'] ?? {};
    final products = (sale['saleproducts'] as List<dynamic>?) ?? [];

    // parse date/time
    String dateStr = '';
    String timeStr = '';
    final createdAt = sale['created_at']?.toString() ?? sale['createdat']?.toString() ?? '';
    if (createdAt.isNotEmpty) {
      final parsed = DateTime.tryParse(createdAt)?.toLocal();
      if (parsed != null) {
        dateStr = DateFormat('yyyy-MM-dd').format(parsed);
        timeStr = DateFormat('HH:mm:ss').format(parsed);
      }
    }

    // optional: fetch logo image bytes
    Uint8List? logoBytes;
    final logoUrl = setting['imageurl'] as String? ?? '';
    if (logoUrl.isNotEmpty) {
      try {
        final resp = await http.get(Uri.parse(logoUrl));
        if (resp.statusCode == 200) logoBytes = resp.bodyBytes;
      } catch (_) {
        logoBytes = null;
      }
    }

    // helper format number
    String fmt(dynamic v) {
      try {
        final d = double.tryParse(v?.toString() ?? '') ?? 0.0;
        return d.toStringAsFixed(2);
      } catch (e) {
        return '0.00';
      }
    }

    // helper to build product line: name | qty | price | total
    String productLine(Map p) {
      final name = p['product']?['name']?.toString() ?? p['name']?.toString() ?? '';
      final qty = p['quantity']?.toString() ?? p['qty']?.toString() ?? '';
      final price = fmt(p['price'] ?? p['unitprice']);
      final total = fmt(p['linetotalafterdiscount'] ?? p['total']);
      final nameMax = 18;
      final shortName = name.length > nameMax ? name.substring(0, nameMax - 1) + '…' : name;
      final qtyCol = qty.padLeft(3);
      final priceCol = price.padLeft(8);
      final totalCol = total.padLeft(9);
      return shortName.padRight(nameMax) + ' ' + qtyCol + ' ' + priceCol + ' ' + totalCol;
    }

    if (openCashDrawer) {
      bytes.addAll(generator.drawer());
    }

    // طباعة التاريخ والوقت كصورة
    if (dateStr.isNotEmpty || timeStr.isNotEmpty) {
      final header = '${timeStr.isNotEmpty ? timeStr : ''} ${dateStr.isNotEmpty ? dateStr : ''}'.trim();
      await addTextRaster(header, align: PosAlign.center);
    }

    // Title
    await addTextRaster('*** ${response['settings']?['shopname'] ?? 'فاتورة'} ***',
        bold: true, align: PosAlign.center);

    // Logo (if exists) - print as image
    if (logoBytes != null && logoBytes.isNotEmpty) {
      try {
        final img.Image? decodedImage = img.decodeImage(logoBytes);
        if (decodedImage != null) {
          bytes.addAll(generator.image(decodedImage));
        }
      } catch (e) {
        // ignore
      }
    }

    // Shop info
    if (setting['shopname'] != null) {
      await addTextRaster(setting['shopname'].toString(), align: PosAlign.center);
    }
    if (setting['phone'] != null) {
      await addTextRaster('Tel: ${setting['phone']}', align: PosAlign.center);
    }
    if (setting['commercialno'] != null) {
      await addTextRaster('Reg#: ${setting['commercialno']}', align: PosAlign.center);
    }

    bytes.addAll(generator.hr());

    // Sale info: id, order type, payment method
    if (sale['id'] != null) await addTextRaster('Invoice #: ${sale['id']}');
    if (sale['ordertype'] != null) await addTextRaster('Order Type: ${sale['ordertype']}');
    if (sale['payment_method'] != null || sale['paymentmethod'] != null) {
      final pm = sale['payment_method'] ?? sale['paymentmethod'];
      await addTextRaster('Payment: $pm');
    }

    bytes.addAll(generator.hr());

    // Header row for products
    await addTextRaster('Item'.padRight(18) + ' QTY  Price     Total', bold: true);

    // Products lines
    for (final p in products) {
      final line = productLine(p);
      await addTextRaster(line);
    }

    bytes.addAll(generator.hr());

    final subtotal = fmt(sale['subtotal']);
    final discount = fmt(sale['discounttotal'] ?? sale['discount']);
    final totalAfterDiscount = fmt(sale['totalafterdiscount']);
    final tax = fmt(sale['taxtotal']);
    final totalAfterTax = fmt(sale['totalaftertax'] ?? sale['total']);
    final remain = (double.tryParse(totalAfterTax) ?? 0.0) - paid;

    // طباعة الكي والفاليو
    Future<void> printKeyValue(String key, String val, {bool bold = false}) async {
      final line = key.padRight(24) + val.padLeft(12);
      await addTextRaster(line, bold: bold);
    }

    if ((sale['subtotal'] ?? sale['sub_total']) != null) await printKeyValue('Subtotal', subtotal);
    if ((sale['discounttotal'] ?? sale['discount']) != null) await printKeyValue('Discount', discount);
    if ((sale['totalafterdiscount']) != null) await printKeyValue('After Discount', totalAfterDiscount);
    if ((sale['taxtotal']) != null) await printKeyValue('Tax', tax);
    if ((sale['totalaftertax'] ?? sale['total']) != null) await printKeyValue('Total', totalAfterTax, bold: true);

    await printKeyValue('Paid', paid.toStringAsFixed(2), bold: true);
    await printKeyValue('Remain', remain.toStringAsFixed(2));

    bytes.addAll(generator.hr());

    // QR code ZATCA
    if (sale['zatcaQrcode'] != null && sale['zatcaQrcode'].toString().isNotEmpty) {
      bytes.addAll(generator.qrcode(sale['zatcaQrcode'].toString(),
          size: QRSize.size8, align: PosAlign.center));
    }

    // Thanks / address / employee / branch
    await addTextRaster(response['settings']?['thanks'] ?? 'شكرا لزيارتك', align: PosAlign.center);
    if (response['settings']?['address'] != null) {
      await addTextRaster(response['settings']?['address'], align: PosAlign.center);
    }
    final employeeName = (response['user']?['name'] ?? response['employee'] ?? '')?.toString();
    if (employeeName != null && employeeName.isNotEmpty) {
      await addTextRaster('Employee: $employeeName', align: PosAlign.center);
    }
    if (branchName != null && branchName.isNotEmpty) {
      await addTextRaster('Branch: $branchName', align: PosAlign.center);
    }

    bytes.addAll(generator.feed(3));
    bytes.addAll(generator.cut());

    return bytes;
  } catch (e) {
    final Generator gen = generator;
    final List<int> err = [];
    err.addAll(gen.text('Error building invoice: $e', styles: PosStyles(align: PosAlign.center)));
    err.addAll(gen.feed(2));
    err.addAll(gen.cut());
    return err;
  }
}

/// Helper: rasterize a single text line into a ui.Image (for printing Arabic correctly).
/// widthPx should be generator.paperWidth in pixels, but we approximate using PaperSize.
Future<ui.Image?> _rasterizeTextLine(String text, int paperWidthPx) async {
  try {
    // pick font size based on width
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final paint = Paint()..color = const Color(0xFF000000);

    // build paragraph
    final paragraphStyle = ui.ParagraphStyle(textDirection: ui.TextDirection.rtl, textAlign: ui.TextAlign.right);
    final textStyle = ui.TextStyle(fontSize: 14.0);
    final builder = ui.ParagraphBuilder(paragraphStyle)..pushStyle(textStyle)..addText(text);
    final paragraph = builder.build();
    paragraph.layout(ui.ParagraphConstraints(width: paperWidthPx.toDouble()));

    // white background
    final bgPaint = Paint()..color = const Color(0xFFFFFFFF);
    final height = paragraph.height + 8;
    canvas.drawRect(Rect.fromLTWH(0, 0, paperWidthPx.toDouble(), height), bgPaint);
    // draw text
    canvas.drawParagraph(paragraph, Offset(0, 4));

    final picture = recorder.endRecording();
    final img = await picture.toImage(paperWidthPx, height.ceil());
    return img;
  } catch (e) {
    return null;
  }
}

/// Helper: convert ui.Image (Flutter) to image.Image (package:image)
Future<img.Image?> _convertUiImageToImage(ui.Image uiImage) async {
  try {
    final byteData = await uiImage.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) return null;
    final buffer = byteData.buffer.asUint8List();
    return img.decodeImage(buffer);
  } catch (e) {
    return null;
  }
}

/// Utility: decode image from bytes to ui.Image
Future<ui.Image> decodeImageFromList(Uint8List bytes) {
  final completer = Completer<ui.Image>();
  ui.decodeImageFromList(bytes, (ui.Image img) {
    completer.complete(img);
  });
  return completer.future;
}
