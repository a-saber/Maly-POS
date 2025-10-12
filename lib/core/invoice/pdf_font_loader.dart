import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfFontLoader {
  static late pw.Font arabicFont;
  static late pw.Font arabicFontBold;

  static Future<void> init() async {
    final fontData =
        await rootBundle.load("assets/fonts/arial/alfont_com_arial-1.ttf");
    final fontBoldData = await rootBundle
        .load("assets/fonts/arial/alfont_com_AlFont_com_arialbd.ttf");

    arabicFont = pw.Font.ttf(fontData);
    arabicFontBold = pw.Font.ttf(fontBoldData);
  }
}
