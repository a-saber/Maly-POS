import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:http/http.dart' as http;
import 'package:pos_app/core/api/api_keys.dart';
import 'package:pos_app/core/cache/custom_user_hive_box.dart';
import 'package:pos_app/core/constant/app_invoice_string.dart';
import 'package:pos_app/core/invoice/pdf_font_loader.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';
import 'package:pdfx/pdfx.dart' as pdfx;

Future<void> printSunmiPDF(Uint8List pdfData) async {
  try {
    final SunmiPrinterPlus sunmiPrinterPlus = SunmiPrinterPlus();

    final pdfDocument = await pdfx.PdfDocument.openData(pdfData);
    // Render the first page as an image
    debugPrint("************* _printPDF 01 *********");
    final pdfPage = await pdfDocument.getPage(1); // 0-based index
    debugPrint("************* _printPDF 02 *********");
    const double scale = 2.6; // Adjust scaling factor as needed
    final double renderWidth = (pdfPage.width * scale);
    final double renderHeight = (pdfPage.height * scale);
    final pdfx.PdfPageImage? pageImage = await pdfPage.render(
      width: renderWidth,
      height: renderHeight,
    );
    debugPrint("************* _printPDF 03 *********");

    if (pageImage != null) {
      // Print the rendered image
      await sunmiPrinterPlus.printImage(pageImage.bytes,
          align: SunmiPrintAlign.CENTER); // Use 'bytes' property
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

Future<Uint8List> salesInvoicesPdf80(Map<String, dynamic> response,
    {String? branchName, required double paid}) async {
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
        pageFormat: PdfPageFormat.roll80,
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
                          fit: pw.BoxFit.cover,
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
                "${AppInvoiceString.orderType} ${sale[ApiKeys.ordertype]}",
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(
                  font: arabicFont,
                ),
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
                  // ✅ Header row
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
                            padding: const pw.EdgeInsets.all(2),
                            child: pw.Text(
                              p[ApiKeys.product]?[ApiKeys.name]?.toString() ??
                                  "",
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(
                                fontSize: 8,
                                font: arabicFont,
                              ),
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(2),
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
                            padding: const pw.EdgeInsets.all(2),
                            child: pw.Text(
                              p[ApiKeys.price]?.toString() ?? "",
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(
                                fontSize: 8,
                                font: arabicFont,
                              ),
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(2),
                            child: pw.Text(
                              p[ApiKeys.linetotalafterdiscount]?.toString() ??
                                  "",
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
                          "${sale[ApiKeys.subtotal]}",
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
                          "${sale[ApiKeys.discounttotal]}",
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
                          "${sale[ApiKeys.totalafterdiscount]}",
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
                          "${sale[ApiKeys.taxtotal]}",
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
                          "${sale[ApiKeys.totalaftertax]}",
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
                        "${((paid - (double.tryParse(sale[ApiKeys.totalaftertax]) ?? 0)) * 100).truncateToDouble() / 100}",
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
