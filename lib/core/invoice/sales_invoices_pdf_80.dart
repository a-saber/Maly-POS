
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:http/http.dart' as http;
import 'package:pos_app/core/api/api_keys.dart';
import 'package:pos_app/core/cache/custom_user_hive_box.dart';
import 'package:pos_app/core/constant/app_invoice_string.dart';
import 'package:pos_app/core/invoice/pdf_font_loader.dart';
import 'package:pos_app/core/utils/extensions.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';
import 'package:pdfx/pdfx.dart' as pdfx;
import '../../features/shifts/data/model/end_shift_model.dart';
import '../../generated/l10n.dart';
import '../helper/formate_date_time.dart';

Future<void> printSunmiPDF(Uint8List pdfData,String paperSize) async {
  try {
    final SunmiPrinterPlus sunmiPrinterPlus = SunmiPrinterPlus();
    // /// new select Size
    //  Map<String, PaperConfig> paperConfigs = {
    //   '58': PaperConfig(
    //     width: 384,        // 58mm = 384 pixels at 203 DPI
    //     scale: 2.0,
    //     maxWidth: 380,
    //   ),
    //   '80': PaperConfig(
    //     width: 576,        // 80mm = 576 pixels at 203 DPI
    //     scale: 2.6,
    //     maxWidth: 570,
    //   ),
    // };
    // final config = paperConfigs[paperSize];
    // /// new select Size

    final pdfDocument = await pdfx.PdfDocument.openData(pdfData);
    // Render the first page as an image
    debugPrint("************* _printPDF 01 *********");
    final pdfPage = await pdfDocument.getPage(1); // 0-based index
    debugPrint("************* _printPDF 02 *********");
    /// old select Size /////////////////////////////////////////////////
    const double scale = 2.6; // Adjust scaling factor as needed
     final double renderWidth = (pdfPage.width * scale);
    final double renderHeight = (pdfPage.height * scale);
     ///old select Size
    /// ///////////////////////////////////////////////////////////////
    // Calculate render dimensions based on paper size
    // /// new select Size
    // final double renderWidth = config!.width.toDouble();
    // final double renderHeight = (pdfPage.height * config.scale);
    final pdfx.PdfPageImage? pageImage = await pdfPage.render(
        width: renderWidth,
       height: renderHeight,

     );
    // /// new select Size
    debugPrint("************* _printPDF 03 *********");

    if (pageImage != null) {
      // Print the rendered image

      await sunmiPrinterPlus.printImage(pageImage.bytes, align: SunmiPrintAlign.CENTER); // Use 'bytes' property
      await sunmiPrinterPlus.lineWrap(times: 70); // Add spacing after the print
    } else {
      debugPrint("Failed to render PDF page.");
    }

    await pdfPage.close();
    //await pdfDocument.close();
  } catch (e) {
    debugPrint("Error printing PDF: $e");
  }
}

Future<Uint8List> salesInvoicesPdf80(
    Map<String, dynamic> response, {
      String? branchName,
      required double paid,
      required String size,
    }) async
{
  var arabicFont = PdfFontLoader.arabicFont;
  var arabicFontBold = PdfFontLoader.arabicFontBold;

  final pdf = pw.Document(

    theme: pw.ThemeData.withFont(
      base: arabicFont,
      bold: arabicFontBold,

    ),
  );

  try {
    http.Response? imageResponse;
    if (response[ApiKeys.settings][ApiKeys.imageurl] != null) {
      try {
        final url = response[ApiKeys.settings][ApiKeys.imageurl] as String? ?? "";
        if (url.isNotEmpty) {
          imageResponse = await http.get(Uri.parse(url));
          if (imageResponse.statusCode != 200) {
            imageResponse = null;
          }
        }
      } catch (e) {
        debugPrint('⚠️ Failed to load image: $e');
        imageResponse = null;
      }
    }

    final sale = response[ApiKeys.sale];
    final setting = response[ApiKeys.settings];
    final products = sale[ApiKeys.saleproducts] as List<dynamic>;

    // Format time & date
    final createdAt = sale[ApiKeys.createdat]?.toString() ?? "";
    DateTime? parsed;
    if (createdAt.isNotEmpty) {
      parsed = DateTime.tryParse(createdAt)?.toLocal();
    }

    final date = parsed != null
        ? "${parsed.year}-${parsed.month.toString().padLeft(2, '0')}-${parsed.day.toString().padLeft(2, '0')}"
        : "";

    final time = parsed != null
        ? "${parsed.hour.toString().padLeft(2, '0')}:${parsed.minute.toString().padLeft(2, '0')}:${parsed.second.toString().padLeft(2, '0')}"
        : "";

    // Paper size settings
    const double mmToPoint = 2.83465;
    final double paperWidth = size == '80' ? 80 : 57;
    final double margin = size == '80' ? 3 : 2;
    final double fontSize = size == '80' ? 7 : 6;
    final double titleSize = size == '80' ? 10 : 9;
    final double logoSize = size == '80' ? 35 : 25;

    pdf.addPage(
      pw.Page(
        textDirection: pw.TextDirection.rtl,
        pageFormat: PdfPageFormat(
          paperWidth * mmToPoint,
          double.infinity,
          marginAll: margin * mmToPoint,

        ),
        build: (context) => pw.Container(
          decoration: pw.BoxDecoration(color: PdfColors.white),
          width: double.infinity,
          margin: pw.EdgeInsets.zero,
          child: pw.Center(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              mainAxisSize: pw.MainAxisSize.min,
              children: [
                // Time & Date
                if (time.isNotEmpty || date.isNotEmpty) ...[
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      if (time.isNotEmpty)
                        pw.Text(
                          time,
                          style: pw.TextStyle(fontSize: fontSize, font: arabicFont),
                        ),
                      if (time.isNotEmpty && date.isNotEmpty)
                        pw.SizedBox(width: 10),
                      if (date.isNotEmpty)
                        pw.Text(
                          date,
                          style: pw.TextStyle(fontSize: fontSize, font: arabicFont),
                        ),
                    ],
                  ),
                  pw.SizedBox(height: 5),
                ],

                // Title
                pw.Text(
                  AppInvoiceString.invoiceTitle,
                  style: pw.TextStyle(
                    fontSize: titleSize,
                    font: arabicFontBold,
                    fontWeight: pw.FontWeight.bold,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
                pw.SizedBox(height: 5),

                // Logo
                if (setting[ApiKeys.imageurl] != null && imageResponse != null) ...[
                  pw.ClipOval(
                    child: pw.Container(
                      width: logoSize,
                      height: logoSize,
                      child: pw.Image(
                        pw.MemoryImage(imageResponse.bodyBytes),
                        fit: pw.BoxFit.cover,
                      ),
                    ),
                  ),
                  pw.SizedBox(height: 5),
                ],

                // Shop Info
                if (setting[ApiKeys.shopname] != null)
                  pw.Text(
                    setting[ApiKeys.shopname],
                    style: pw.TextStyle(fontSize: fontSize + 1, font: arabicFontBold, fontWeight: pw.FontWeight.bold),
                    textAlign: pw.TextAlign.center,
                  ),
                if (setting[ApiKeys.phone] != null)
                  pw.Text(
                    setting[ApiKeys.phone],
                    style: pw.TextStyle(fontSize: fontSize, font: arabicFont),
                    textAlign: pw.TextAlign.center,
                  ),
                if (setting[ApiKeys.commercialno] != null)
                  pw.Text(
                    "${AppInvoiceString.numberOfDariba}: ${setting[ApiKeys.commercialno]}",
                    style: pw.TextStyle(fontSize: fontSize - 1, font: arabicFont),
                    textAlign: pw.TextAlign.center,
                  ),
                if (sale[ApiKeys.id] != null)
                  pw.Text(
                    "${AppInvoiceString.sellingId}: ${sale[ApiKeys.id]}",
                    style: pw.TextStyle(fontSize: fontSize - 1, font: arabicFont),
                    textAlign: pw.TextAlign.center,
                  ),
                if (sale[ApiKeys.ordertype] != null)
                  pw.Text(
                    "${AppInvoiceString.orderType}: ${orderType(sale[ApiKeys.ordertype])}",
                    style: pw.TextStyle(fontSize: fontSize - 1, font: arabicFont),
                    textAlign: pw.TextAlign.center,
                  ),
                pw.SizedBox(height: 5),

                // Order Number Box
                pw.Container(
                  width: double.infinity,
                  padding: pw.EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.black, width: 0.5),
                  ),
                  child: pw.Column(
                    children: [
                      pw.Text(
                        'OrderNumber',
                        style: pw.TextStyle(fontSize: fontSize, font: arabicFont),
                        textAlign: pw.TextAlign.center,
                      ),
                      pw.SizedBox(height: 2),
                      pw.Text(
                        "#${sale['order_number']}",
                        style: pw.TextStyle(
                          fontSize: fontSize + 3,
                          font: arabicFontBold,
                          fontWeight: pw.FontWeight.bold,
                        ),
                        textAlign: pw.TextAlign.center,
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 5),

                // Divider
                pw.Container(width: double.infinity, height: 0.5, color: PdfColors.black),
                pw.SizedBox(height: 3),

                // Products Table
                if (products.isNotEmpty)
                  pw.Table(
                    border: pw.TableBorder.all(color: PdfColors.black, width:2),
                    columnWidths: {
                      0: pw.FlexColumnWidth(2), // Product
                      1: pw.FlexColumnWidth(1), // Qty
                      2: pw.FlexColumnWidth(1), // Price
                      3: pw.FlexColumnWidth(1), // Total
                    },
                    children: [
                      // Header
                      pw.TableRow(
                        decoration: pw.BoxDecoration(color: PdfColors.grey200),
                        children: [
                          _buildTableCell(AppInvoiceString.product, arabicFontBold, fontSize - 1, true),
                          _buildTableCell(AppInvoiceString.quantity, arabicFontBold, fontSize - 1, true),
                          _buildTableCell(AppInvoiceString.price, arabicFontBold, fontSize - 1, true),
                          _buildTableCell(AppInvoiceString.total, arabicFontBold, fontSize - 1, true),
                        ].reversed.toList(),
                      ),
                      // Data rows
                      ...products.map((p) {
                        return pw.TableRow(
                          decoration: pw.BoxDecoration(color: PdfColors.white),
                          children: [
                            _buildTableCell(
                              p[ApiKeys.product]?[ApiKeys.name]?.toString() ?? "",
                              arabicFont,
                              fontSize - 1,
                              false,
                            ),
                            _buildTableCell(
                              p[ApiKeys.quantity]?.toString() ?? "",
                              arabicFont,
                              fontSize - 1,
                              false,
                            ),
                            _buildTableCell(
                              double.tryParse(p[ApiKeys.price] ?? '0')?.toStringAsFixed(2) ?? '0',
                              arabicFont,
                              fontSize - 1,
                              false,
                            ),
                            _buildTableCell(
                              double.tryParse(p[ApiKeys.linetotalaftertax] ?? '0')
                                  ?.toStringAsFixed(2) ??
                                  '0',
                              arabicFont,
                              fontSize - 1,
                              false,
                            ),
                          ].reversed.toList(),
                        );
                      }),
                    ],
                  ),

                if (products.isNotEmpty) pw.SizedBox(height: 5),

                // Divider
                pw.Container(width: double.infinity, height: 0.5, color: PdfColors.black),
                pw.SizedBox(height: 3),

                // Totals Table
                pw.Table(
                  border: pw.TableBorder.all(color: PdfColors.black, width: 2),
                  columnWidths: {
                    0: pw.FlexColumnWidth(2),
                    1: pw.FlexColumnWidth(1),
                  },
                  children: [
                    if (sale[ApiKeys.subtotal] != null)
                      _buildTotalRow(
                        AppInvoiceString.totalBeforeTax,
                        double.tryParse(sale[ApiKeys.subtotal] ?? '0')?.toStringAsFixed(2) ?? '0',
                        arabicFont,
                        fontSize - 1,
                      ),
                    if (sale[ApiKeys.discounttotal] != null)
                      _buildTotalRow(
                        AppInvoiceString.discount,
                        double.tryParse(sale[ApiKeys.discounttotal] ?? '0')?.toStringAsFixed(2) ?? '0',
                        arabicFont,
                        fontSize - 1,
                      ),
                    if (sale[ApiKeys.totalafterdiscount] != null)
                      _buildTotalRow(
                        AppInvoiceString.totalAfterDiscount,
                        double.tryParse(sale[ApiKeys.totalafterdiscount] ?? '0')
                            ?.toStringAsFixed(2) ??
                            '0',
                        arabicFont,
                        fontSize - 1,
                      ),
                    if (sale[ApiKeys.taxtotal] != null)
                      _buildTotalRow(
                        AppInvoiceString.tax,
                        double.tryParse(sale[ApiKeys.taxtotal] ?? '0')?.toStringAsFixed(2) ?? '0',
                        arabicFont,
                        fontSize - 1,
                      ),
                    if (sale[ApiKeys.totalaftertax] != null)
                      _buildTotalRow(
                        AppInvoiceString.totalAfterTax,
                        double.tryParse(sale[ApiKeys.totalaftertax] ?? '0')?.toStringAsFixed(2) ??
                            '0',
                        arabicFontBold,
                        fontSize - 1,
                        isBold: true,
                      ),
                    if (sale[ApiKeys.paymentmethod] != null)
                      _buildTotalRow(
                        AppInvoiceString.paymentMethod,
                        "${sale[ApiKeys.paymentmethod]}",
                        arabicFont,
                        fontSize - 1,
                      ),
                    _buildTotalRow(
                      AppInvoiceString.paid,
                      paid.toStringAsFixed(2),
                      arabicFontBold,
                      fontSize - 1,
                      isBold: true,
                    ),
                    _buildTotalRow(
                      AppInvoiceString.remain,
                      (paid - (double.tryParse(sale[ApiKeys.totalaftertax]) ?? 0))
                          .toStringAsFixed(2),
                      arabicFont,
                      fontSize - 1,
                    ),
                  ],
                ),

                pw.SizedBox(height: 8),

                // QR Code
                if (sale[ApiKeys.zatcaQrcode] != null) ...[
                  pw.BarcodeWidget(
                    barcode: pw.Barcode.qrCode(),
                    data: sale[ApiKeys.zatcaQrcode],
                    width: size == '80' ? 80 : 60,
                    height: size == '80' ? 80 : 60,
                  ),
                  pw.SizedBox(height: 5),
                ],

                // Divider
                pw.Container(width: double.infinity, height: 0.5, color: PdfColors.black),
                pw.SizedBox(height: 5),

                // Footer
                pw.Text(
                  AppInvoiceString.thanks,
                  style: pw.TextStyle(
                    fontSize: fontSize,
                    font: arabicFontBold,
                    fontWeight: pw.FontWeight.bold,
                  ),
                  textAlign: pw.TextAlign.center,
                ),

                if (setting[ApiKeys.address] != null) ...[
                  pw.SizedBox(height: 3),
                  pw.Text(
                    setting[ApiKeys.address],
                    style: pw.TextStyle(fontSize: fontSize - 1, font: arabicFont),
                    textAlign: pw.TextAlign.center,
                  ),
                ],

                if (CustomUserHiveBox.getUser().name != null) ...[
                  pw.SizedBox(height: 3),
                  pw.Text(
                    "${AppInvoiceString.employeeName} ${CustomUserHiveBox.getUser().name}",
                    style: pw.TextStyle(fontSize: fontSize - 2, font: arabicFont),
                    textAlign: pw.TextAlign.center,
                  ),
                ],

                if (branchName != null) ...[
                  pw.SizedBox(height: 3),
                  pw.Text(
                    "${AppInvoiceString.branchName} $branchName",
                    style: pw.TextStyle(fontSize: fontSize - 2, font: arabicFont),
                    textAlign: pw.TextAlign.center,
                  ),
                ],

                pw.SizedBox(height: 5),
              ],
            )
          ),
        ),
      ),
    );

    return pdf.save();
  } catch (e) {
    debugPrint('⚠️ PDF Generation Error: $e');
    final emptyPdf = pw.Document();
    emptyPdf.addPage(
      pw.Page(
        build: (context) => pw.Center(
          child: pw.Text(
            'خطأ في إنشاء الفاتورة',
            style: pw.TextStyle(font: arabicFont),
          ),
        ),
      ),
    );
    return emptyPdf.save();
  }
}

// Helper: Build table cell
pw.Widget _buildTableCell(String text, pw.Font font, double fontSize, bool isBold) {
  return pw.Padding(
    padding: const pw.EdgeInsets.all(2),
    child: pw.Text(
      text,
      style: pw.TextStyle(
        fontSize: fontSize,
        font: font,
        fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
      ),
      textAlign: pw.TextAlign.center,
      maxLines: 2,
      overflow: pw.TextOverflow.clip,
    ),
  );
}

// Helper: Build total row
pw.TableRow _buildTotalRow(
    String label,
    String value,
    pw.Font font,
    double fontSize, {
      bool isBold = false,
    }) {
  return pw.TableRow(
    decoration: pw.BoxDecoration(color: PdfColors.grey100),

    children: [
      pw.Padding(
        padding: const pw.EdgeInsets.all(2),
        child: pw.Text(
          label,
          style: pw.TextStyle(
            fontSize: fontSize,
            font: font,
            fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
          ),
          textAlign: pw.TextAlign.center,
        ),
      ),
      pw.Padding(
        padding: const pw.EdgeInsets.all(2),
        child: pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: fontSize,
            font: font,
            fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
          ),
          textAlign: pw.TextAlign.center,
        ),
      ),
    ].reversed.toList(),
  );
}
Future<Uint8List> endShiftInvoicesPdf( BuildContext contextView, {required EndShiftModel shift, required String size }) async
{
  http.Response? imageResponse;
  var arabicFont = PdfFontLoader.arabicFont;
  var arabicFontBold = PdfFontLoader.arabicFontBold;

  final pdf = pw.Document(
    theme: pw.ThemeData.withFont(
      base: arabicFont,
      bold: arabicFontBold,
    ),
  );

  try {
    if (shift.setting?.logoUrl != null) {
      try {
        final url = shift.setting?.logoUrl ?? "";
        if (url.isNotEmpty) {
          imageResponse = await http.get(Uri.parse(url));
          // Only use if status is OK
          if (imageResponse.statusCode != 200) {
            imageResponse = null; // invalidate on bad status
          }
        }
      } catch (e) {
        debugPrint('⚠️ Failed to load image: $e');
        imageResponse = null;
      }
    }


    pdf.addPage(
      pw.Page(
        textDirection: pw.TextDirection.rtl,
        pageFormat: size == '80'
            ? PdfPageFormat(
          80 * 2.83465, // 80mm width in points
          double.infinity,
          marginAll: 5 * 2.83465, // 5mm margin
        )
            : PdfPageFormat(
          57 * 2.83465, // 57mm width in points
          double.infinity,
          marginAll: 3 * 2.83465, // 3mm margin
        ),
        build: (context) => pw.Container(
          decoration: pw.BoxDecoration(color: PdfColors.white),
          width: double.infinity,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            mainAxisSize: pw.MainAxisSize.min,
            children: [
              pw.SizedBox(height: 5),

              // Logo - Centered
              if (shift.setting?.logoUrl != null && imageResponse != null)
                pw.Center(
                  child: pw.ClipOval(
                    child: pw.Container(
                      width: size == '80' ? 40 : 30, // Smaller for thermal
                      height: size == '80' ? 40 : 30,
                      child: pw.Image(
                        pw.MemoryImage(imageResponse.bodyBytes),
                        fit: pw.BoxFit.cover,
                      ),
                    ),
                  ),
                ),

              if (shift.setting?.logoUrl != null && imageResponse != null)
                pw.SizedBox(height: 8),

              // Title - Centered and Bold
              pw.Text(
                S.of(contextView).shiftDetails,
                style: pw.TextStyle(
                  fontSize: size == '80' ? 12 : 10,
                  font: arabicFontBold,
                  fontWeight: pw.FontWeight.bold,
                ),
                textAlign: pw.TextAlign.center,
              ),
              pw.SizedBox(height: 8),

              // Start Time - Centered
              pw.Text(
                "${S.of(contextView).startAt}: ${getLocalTimeFormate(shift.shift?.startAt ?? '-')}",
                style: pw.TextStyle(
                  fontSize: size == '80' ? 8 : 7,
                  font: arabicFont,
                ),
                textAlign: pw.TextAlign.center,
              ),
              pw.SizedBox(height: 3),

              // End Time - Centered
              pw.Text(
                "${S.of(contextView).endAt}: ${getLocalTimeFormate(shift.shift?.endAt ?? '-')}",
                style: pw.TextStyle(
                  fontSize: size == '80' ? 8 : 7,
                  font: arabicFont,
                ),
                textAlign: pw.TextAlign.center,
              ),
              pw.SizedBox(height: 10),

              // Divider Line
              pw.Container(
                width: double.infinity,
                height: 1,
                color: PdfColors.black,
              ),
              pw.SizedBox(height: 5),

              // Details Table
              pw.Container(
                width: double.infinity,
                child: pw.Table(
                  border: pw.TableBorder.all(
                    color: PdfColors.black,
                    width: 0.5,
                  ),
                  columnWidths: {
                    0: pw.FlexColumnWidth(2), // Label
                    1: pw.FlexColumnWidth(1.5), // Value
                  },
                  children: [
                    _buildTableRow(
                      S.of(contextView).user,
                      shift.shift?.user?.name ?? '-',
                      arabicFont,
                      size,
                    ),
                    _buildTableRow(
                      S.of(contextView).branch,
                      shift.shift?.branch?.name ?? '-',
                      arabicFont,
                      size,
                    ),
                    _buildTableRow(
                      S.of(contextView).openingQuantity,
                      double.tryParse(shift.shift?.openingQuantity ?? '0')
                          ?.toStringAsFixed(1) ??
                          '-',
                      arabicFont,
                      size,
                    ),
                    _buildTableRow(
                      S.of(contextView).discountTotal,
                      (shift.shift?.discountTotal ?? '-').toAmount(),
                      arabicFont,
                      size,
                    ),
                    _buildTableRow(
                      S.of(contextView).taxestotal,
                      (shift.shift?.taxTotal ?? '-').toAmount(),
                      arabicFontBold,
                      size,
                      isBold: true,
                    ),
                    _buildTableRow(
                      S.of(contextView).cashTotal,
                      (shift.shift?.cashTotal ?? '-').toAmount(),
                      arabicFont,
                      size,
                    ),
                    _buildTableRow(
                      S.of(contextView).onlineTotal,
                      (shift.shift?.onlineTotal ?? '-').toAmount(),
                      arabicFont,
                      size,
                    ),
                    _buildTableRow(
                      S.of(contextView).total,
                      (shift.shift?.totalAfterTax ?? '-').toAmount(),
                      arabicFontBold,
                      size,
                      isBold: true,
                    ),
                  ],
                ),
              ),

              pw.SizedBox(height: 10),

              // Divider Line
              pw.Container(
                width: double.infinity,
                height: 1,
                color: PdfColors.black,
              ),
              pw.SizedBox(height: 8),

              // Employee Name - Centered
              if (CustomUserHiveBox.getUser().name != null)
                pw.Text(
                  "${AppInvoiceString.employeeName} ${CustomUserHiveBox.getUser().name}",
                  style: pw.TextStyle(
                    fontSize: size == '80' ? 7 : 6,
                    font: arabicFont,
                  ),
                  textAlign: pw.TextAlign.center,
                ),

              pw.SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );

// Helper function to build table rows


    return pdf.save();
  } catch (e) {
    debugPrint('⚠️ PDF Generation Error: $e');
    final emptyPdf = pw.Document();
    emptyPdf.addPage(pw.Page(
        build: (context) =>
            pw.Center(child: pw.Text('خطأ في إنشاء الفاتورة'))));
    return emptyPdf.save();
  }
}
pw.TableRow _buildTableRow(
    String label,
    String value,
    pw.Font font,
    String size, {
      bool isBold = false,
    }) {
  return pw.TableRow(
    decoration: pw.BoxDecoration(
      color: PdfColors.grey100,
    ),
    children: [
      pw.Padding(
        padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 3),
        child: pw.Text(
          label,
          style: pw.TextStyle(
            fontSize: size == '80' ? 7 : 6,
            font: font,
            fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
          ),
          textAlign: pw.TextAlign.center,
        ),
      ),
      pw.Padding(
        padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 3),
        child: pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: size == '80' ? 7 : 6,
            font: font,
            fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
          ),
          textAlign: pw.TextAlign.center,
        ),
      ),
    ].reversed.toList(), // Reverse for RTL
  );
}

String  orderType(String type ){
  switch (type){
    case  ApiKeys.hall:return "${ApiKeys.hall}-${'محلي'}";
    case  ApiKeys.delivery : return "${ApiKeys.delivery}-${'توصيل'}";
    default: return "${"takeaway"}-${'سفري'}";



  }


}

Future<Uint8List> salesInvoicesPdfSunmi(Map<String, dynamic> response,
    {String? branchName, required double paid,required String size}) async
{
  var arabicFont = PdfFontLoader.arabicFont;
  var arabicFontBold = PdfFontLoader.arabicFontBold;

  final pdf = pw.Document(
    theme: pw.ThemeData.withFont(
      base: arabicFont,
      bold: arabicFontBold,
    ),
  );

  try {
    http.Response? imageResponse;
    if (response[ApiKeys.settings][ApiKeys.imageurl] != null) {
      try {
        final url =
            response[ApiKeys.settings][ApiKeys.imageurl] as String? ?? "";
        if (url.isNotEmpty) {
          imageResponse = await http.get(Uri.parse(url));
          // Only use if status is OK
          if (imageResponse.statusCode != 200) {
            imageResponse = null; // invalidate on bad status
          }
        }
      } catch (e) {
        debugPrint('⚠️ Failed to load image: $e');
        imageResponse = null;
      }
    }

    final sale = response[ApiKeys.sale];
    final setting = response[ApiKeys.settings];
    final products = sale[ApiKeys.saleproducts] as List<dynamic>;

    // ✅ Format time & date from created_at (convert to local)
    final createdAt = sale[ApiKeys.createdat]?.toString() ?? "";
    DateTime? parsed;
    if (createdAt.isNotEmpty) {
      parsed = DateTime.tryParse(createdAt)?.toLocal();
    }

    final date = parsed != null
        ? "${parsed.year}-${parsed.month.toString().padLeft(2, '0')}-${parsed.day.toString().padLeft(2, '0')}"
        : "";

    final time = parsed != null
        ? "${parsed.hour.toString().padLeft(2, '0')}:${parsed.minute.toString().padLeft(2, '0')}:${parsed.second.toString().padLeft(2, '0')}"
        : "";

    pdf.addPage(
      pw.Page(
        textDirection: pw.TextDirection.rtl,
        pageFormat: size=='80' ? PdfPageFormat.roll80: PdfPageFormat.roll57,
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
          children: [
            // Time & Date row (only if not empty)
            if (time.isNotEmpty || date.isNotEmpty)
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  if (time.isNotEmpty)
                    pw.Text(time,
                        style: pw.TextStyle(
                          fontSize: 10,
                          font: arabicFont,
                        )),
                  if (date.isNotEmpty)
                    pw.Text(date,
                        style: pw.TextStyle(
                          fontSize: 10,
                          font: arabicFont,
                        )),
                ].reversed.toList(),
              ),
            if (time.isNotEmpty || date.isNotEmpty) pw.SizedBox(height: 5),

            // Title
            pw.Center(
              child: pw.Text(
                AppInvoiceString.invoiceTitle,
                style: pw.TextStyle(
                  fontSize: 14,
                  font: arabicFontBold,
                  fontWeight: pw.FontWeight.bold,
                ),
                textAlign: pw.TextAlign.center,
              ),
            ),
            pw.SizedBox(height: 10),

            // Shop Info
            (setting[ApiKeys.imageurl] != null && imageResponse != null)
                ? pw.Center(
              // ✅ keeps it centered without stretching
              child: pw.ClipOval(
                child: pw.Container(
                  width: 50, // fixed size
                  height: 50, // fixed size
                  child: pw.Image(
                    pw.MemoryImage(imageResponse.bodyBytes),
                    fit: pw.BoxFit.fill,
                  ),
                ),
              ),
            )
                : pw.SizedBox(),

            // Setting Info
            if (setting[ApiKeys.shopname] != null)
              pw.Text(
                setting[ApiKeys.shopname],
                style: pw.TextStyle(
                  font: arabicFont,
                ),
                textAlign: pw.TextAlign.center,
              ),
            if (setting[ApiKeys.phone] != null)
              pw.Text(
                setting[ApiKeys.phone],
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(
                  font: arabicFont,
                ),
              ),
            if (setting[ApiKeys.commercialno] != null)
              pw.Text(
                "${AppInvoiceString.numberOfDariba} : ${setting[ApiKeys.commercialno]}",
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(
                  font: arabicFont,
                ),
              ),

            if (sale[ApiKeys.id] != null)
              pw.Text(
                "${AppInvoiceString.sellingId} : ${sale[ApiKeys.id]}",
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(
                  font: arabicFont,
                ),
              ),
            if (sale[ApiKeys.ordertype] != null)
              pw.Text(
                "${AppInvoiceString.orderType}:${ orderType(sale[ApiKeys.ordertype])}",
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(
                  font: arabicFont,
                ),
              ),
            pw.SizedBox(height: 10),
            pw.Container(
                width: double.infinity,
                padding: pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                    border: pw.Border.all(
                      color: PdfColors.black,
                      width: 1,
                      style: pw.BorderStyle.solid,
                    )
                ),
                child: pw.Center(
                  child: pw.Column(
                      children: [
                    pw.Text(
                    'OrderNumber',
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(
                      font: arabicFont,
                      fontSize: 16,
                    ),
                  ),
                        pw.SizedBox(height: 2),

                    pw.Text(
                      "#${sale['order_number']}",
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                        font: arabicFont,
                        fontSize: 20,
                      ),
                    )
                  ]
                  ),
                )

            ),

            // if (sale["branch_id"] != null) pw.Text("الفرع: ${sale["branch_id"]}"),
            // if (sale["customer"]?["name"] != null)
            //   pw.Text("العميل: ${sale["customer"]["name"]}"),
            // if (sale["payment_method"] != null)
            //   pw.Text("طريقة الدفع: ${sale["payment_method"]}"),
            pw.SizedBox(height: 10),

            // Products Table
            if (products.isNotEmpty)
              pw.Table(
                border: pw.TableBorder(
                  horizontalInside: pw.BorderSide.none, // no inside lines
                  verticalInside: pw.BorderSide.none, // no vertical lines
                  top: pw.BorderSide.none,
                  bottom: pw.BorderSide.none,
                  left: pw.BorderSide.none,
                  right: pw.BorderSide.none,
                ),
                columnWidths: {
                  0: pw.FlexColumnWidth(1),
                  1: pw.FlexColumnWidth(1),
                  2: pw.FlexColumnWidth(1),
                  3: pw.FlexColumnWidth(2),
                },
                children: [
                  pw.TableRow(
                    decoration:
                    pw.BoxDecoration(color: PdfColors.grey300), // gray bg
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(2),
                        child: pw.Text(
                          AppInvoiceString.product,
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                            fontSize: 8,
                            font: arabicFont,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(2),
                        child: pw.Text(
                          AppInvoiceString.quantity,
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                            fontSize: 8,
                            font: arabicFont,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(2),
                        child: pw.Text(
                          AppInvoiceString.price,
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                            fontSize: 8,
                            font: arabicFont,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(2),
                        child: pw.Text(
                          AppInvoiceString.total,
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                            fontSize: 8,
                            font: arabicFont,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                    ].reversed.toList(),
                  ),
                  // ✅ خط فاصل بين العناوين والعناصر
                  pw.TableRow(
                    children: [
                      pw.Container(
                        height: 0.5,
                        color: PdfColors.black,
                      ),
                      pw.Container(
                        height: 0.5,
                        color: PdfColors.black,
                      ),
                      pw.Container(
                        height: 0.5,
                        color: PdfColors.black,
                      ),
                      pw.Container(
                        height: 0.5,
                        color: PdfColors.black,
                      ),
                    ],
                  ),
                  // ✅ Data rows
                  ...products.map(
                        (p) {
                      return pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(1),
                            child: pw.Text(
                              p[ApiKeys.product]?[ApiKeys.name]?.toString() ?? "",
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(
                                fontSize: 8,
                                font: arabicFont,
                              ),
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(1),
                            child: pw.Text(
                              p[ApiKeys.quantity]?.toString() ?? "",
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(
                                fontSize: 8,
                                font: arabicFont,
                              ),
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(1),
                            child: pw.Text(
                              double.tryParse(p[ApiKeys.price]??'0')?.toStringAsFixed(2)??'0',
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(
                                fontSize: 8,
                                font: arabicFont,
                              ),
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(1),
                            child: pw.Text(
                              double.tryParse(p[ApiKeys.linetotalaftertax]??'0')?.toStringAsFixed(2)??'0',
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(
                                fontSize: 8,
                                font: arabicFont,
                              ),
                            ),
                          ),
                        ].reversed.toList(),
                      );
                    },
                  ),
                ],
              ),
            if (products.isNotEmpty) pw.SizedBox(height: 10),

            // Totals
            pw.Table(
              border: pw.TableBorder(
                horizontalInside: pw.BorderSide(
                  width: 0.2,
                  color: PdfColors.black,
                ), // خطوط أفقية بين الصفوف
                verticalInside: pw.BorderSide(
                  width: 0.2,
                  color: PdfColors.black,
                ), // خطوط عمودية بين الأعمدة
                top: pw.BorderSide(
                  width: 0.7,
                  color: PdfColors.black,
                ), // خط علوي
                bottom: pw.BorderSide(
                  width: 0.7,
                  color: PdfColors.black,
                ), // خط سفلي
                left: pw.BorderSide(
                  width: 0.7,
                  color: PdfColors.black,
                ), // خط يسار
                right: pw.BorderSide(
                  width: 0.7,
                  color: PdfColors.black,
                ), // خط يمين
              ),
              columnWidths: {
                0: pw.FlexColumnWidth(1), // العناوين
                1: pw.FlexColumnWidth(2), // القيم
              },
              children: [
                if (sale[ApiKeys.subtotal] != null)
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(2),
                        child: pw.Text(
                          AppInvoiceString.totalBeforeTax,
                          style: pw.TextStyle(
                            fontSize: 8,
                            font: arabicFont,
                          ),
                          textAlign: pw.TextAlign.center,
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(2),
                        child: pw.Text(
                          double.tryParse(sale[ApiKeys.subtotal]??'0')?.toStringAsFixed(2)??'0',
                          style: pw.TextStyle(
                            fontSize: 8,
                            font: arabicFont,
                          ),
                          textAlign: pw.TextAlign.center,
                        ),
                      ),
                    ].reversed.toList(),
                  ),
                if (sale[ApiKeys.discounttotal] != null)
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(2),
                        child: pw.Text(
                          AppInvoiceString.discount,
                          style: pw.TextStyle(
                            fontSize: 8,
                            font: arabicFont,
                          ),
                          textAlign: pw.TextAlign.center,
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(2),
                        child: pw.Text(
                          //"${sale[ApiKeys.discounttotal]}",
                          double.tryParse(sale[ApiKeys.discounttotal]??'0')?.toStringAsFixed(2)??'0',
                          style: pw.TextStyle(
                            fontSize: 8,
                            font: arabicFont,
                          ),
                          textAlign: pw.TextAlign.center,
                        ),
                      ),
                    ].reversed.toList(),
                  ),
                if (sale[ApiKeys.totalafterdiscount] != null)
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(2),
                        child: pw.Text(
                          AppInvoiceString.totalAfterDiscount,
                          style: pw.TextStyle(
                            fontSize: 8,
                            font: arabicFont,
                          ),
                          textAlign: pw.TextAlign.center,
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(2),
                        child: pw.Text(
                          // "${sale[ApiKeys.totalafterdiscount]}",
                          double.tryParse(sale[ApiKeys.totalafterdiscount]??'0')?.toStringAsFixed(2)??'0',
                          style: pw.TextStyle(
                            fontSize: 8,
                            font: arabicFont,
                          ),
                          textAlign: pw.TextAlign.center,
                        ),
                      ),
                    ].reversed.toList(),
                  ),
                if (sale[ApiKeys.taxtotal] != null)
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(2),
                        child: pw.Text(
                          AppInvoiceString.tax,
                          style: pw.TextStyle(
                            fontSize: 8,
                            font: arabicFont,
                          ),
                          textAlign: pw.TextAlign.center,
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(2),
                        child: pw.Text(
                          //"${sale[ApiKeys.taxtotal]}",
                          double.tryParse(sale[ApiKeys.taxtotal]??'0')?.toStringAsFixed(2)??'0',
                          style: pw.TextStyle(
                            fontSize: 8,
                            font: arabicFont,
                          ),
                          textAlign: pw.TextAlign.center,
                        ),
                      ),
                    ].reversed.toList(),
                  ),
                if (sale[ApiKeys.totalaftertax] != null)
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(2),
                        child: pw.Text(
                          AppInvoiceString.totalAfterTax,
                          style: pw.TextStyle(
                            fontSize: 8,
                            fontWeight: pw.FontWeight.bold,
                            font: arabicFontBold,
                          ),
                          textAlign: pw.TextAlign.center,
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(2),
                        child: pw.Text(
                          // "${sale[ApiKeys.totalaftertax]}",
                          double.tryParse(sale[ApiKeys.totalaftertax]??'0')?.toStringAsFixed(2)??'0',
                          style: pw.TextStyle(
                            fontSize: 8,
                            fontWeight: pw.FontWeight.bold,
                            font: arabicFontBold,
                          ),
                          textAlign: pw.TextAlign.center,
                        ),
                      ),
                    ].reversed.toList(),
                  ),
                if (sale[ApiKeys.paymentmethod] != null)
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(2),
                        child: pw.Text(
                          AppInvoiceString.paymentMethod,
                          style: pw.TextStyle(
                            fontSize: 8,
                            font: arabicFont,
                          ),
                          textAlign: pw.TextAlign.center,
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(2),
                        child: pw.Text(
                          "${sale[ApiKeys.paymentmethod]}",
                          style: pw.TextStyle(
                            fontSize: 8,
                            font: arabicFont,
                          ),
                          textAlign: pw.TextAlign.center,
                        ),
                      ),
                    ].reversed.toList(),
                  ),
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(2),
                      child: pw.Text(
                        AppInvoiceString.paid,
                        style: pw.TextStyle(
                          fontSize: 8,
                          font: arabicFontBold,
                          fontWeight: pw.FontWeight.bold,
                        ),
                        textAlign: pw.TextAlign.center,
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(2),
                      child: pw.Text(
                        "$paid",
                        style: pw.TextStyle(
                          fontSize: 8,
                          font: arabicFontBold,
                          fontWeight: pw.FontWeight.bold,
                        ),
                        textAlign: pw.TextAlign.center,
                      ),
                    ),
                  ].reversed.toList(),
                ),
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(2),
                      child: pw.Text(
                        AppInvoiceString.remain,
                        style: pw.TextStyle(
                          fontSize: 8,
                          font: arabicFont,
                        ),
                        textAlign: pw.TextAlign.center,
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(2),
                      child: pw.Text(
                        (((paid - (double.tryParse(sale[ApiKeys.totalaftertax]) ?? 0)) * 100) / 100).toStringAsFixed(1),
                        style: pw.TextStyle(
                          fontSize: 8,
                          font: arabicFont,
                        ),
                        textAlign: pw.TextAlign.center,
                      ),
                    ),
                  ].reversed.toList(),
                ),
              ],
            ),

            pw.SizedBox(height: 15),

            // Random QR Code
            if (sale[ApiKeys.zatcaQrcode] != null)
              pw.Center(
                child: pw.BarcodeWidget(
                  barcode: pw.Barcode.qrCode(),
                  data: sale[ApiKeys.zatcaQrcode],
                  width: 100,
                  height: 100,
                  textStyle: pw.TextStyle(
                    fontSize: 10,
                    font: arabicFont,
                  ),
                ),
              ),
            if (sale[ApiKeys.zatcaQrcode] != null) pw.SizedBox(height: 10),
            pw.Center(
              child: pw.Text(
                AppInvoiceString.thanks,
                style: pw.TextStyle(
                  fontSize: 10,
                  font: arabicFont,
                ),
                textAlign: pw.TextAlign.center,
              ),
            ),
            pw.SizedBox(height: 5),
            if (setting[ApiKeys.address] != null)
              pw.Center(
                child: pw.Text(
                  setting[ApiKeys.address],
                  style: pw.TextStyle(
                    fontSize: 9,
                    font: arabicFont,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
              ),
            pw.SizedBox(height: 3),
            CustomUserHiveBox.getUser().name != null
                ? pw.Center(
              child: pw.Text(
                "${AppInvoiceString.employeeName} ${CustomUserHiveBox.getUser().name}",
                style: pw.TextStyle(
                  fontSize: 7,
                  font: arabicFont,
                ),
                textAlign: pw.TextAlign.center,
              ),
            )
                : pw.SizedBox(),
            branchName != null
                ? pw.Center(
              child: pw.Text(
                "${AppInvoiceString.branchName} $branchName",
                style: pw.TextStyle(
                  fontSize: 7,
                  font: arabicFont,
                ),
                textAlign: pw.TextAlign.center,
              ),
            )
                : pw.SizedBox(),
          ],
        ),
      ),
    );

    return pdf.save();
  } catch (e) {
    debugPrint('⚠️ PDF Generation Error: $e');
    final emptyPdf = pw.Document();
    emptyPdf.addPage(pw.Page(
        build: (context) =>
            pw.Center(child: pw.Text('خطأ في إنشاء الفاتورة'))));
    return emptyPdf.save();
  }
}







