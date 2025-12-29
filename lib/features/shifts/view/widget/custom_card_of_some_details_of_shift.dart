import 'package:flutter/material.dart';
import 'package:pos_app/core/helper/formate_date_time.dart';
import 'package:pos_app/core/router/app_route.dart';
import 'package:pos_app/core/utils/extensions.dart';
import 'package:pos_app/features/shifts/data/model/shifts_model.dart';
import 'package:pos_app/features/shifts/data/repo/shift_repo.dart';
import 'package:pos_app/generated/l10n.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';

import '../../../../core/helper/my_service_locator.dart';
import '../../../../core/helper/printer_helper.dart';
import '../../../../core/invoice/sales_invoices_pdf_80.dart';
import '../../../../core/widget/custom_btn.dart';
import '../../../printer/manager/scan_printer/scan_printer_cubit.dart';
import '../../data/model/end_shift_model.dart';

// ============================================
// في CustomCardOfSomeDetailsofShift
// ============================================

class CustomCardOfSomeDetailsofShift extends StatelessWidget {
  const CustomCardOfSomeDetailsofShift({
    super.key,
    required this.shift,
  });

  final ShiftData shift;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutes.shiftDetails,
            arguments: shift.id!,
          );
        },
        title: Text(
          "${S.of(context).shiftNumber}: ${shift.id}",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${S.of(context).startAt}: ${getLocalTimeFormate(shift.startAt ?? '-')}"),
                Text("${S.of(context).endAt}: ${getLocalTimeFormate(shift.endAt ?? '-')}"),
                Text("${S.of(context).ordersCount}: ${shift.ordersCount ?? 0}"),
                Text("${S.of(context).branch}: ${shift.branch?.name ?? '-'}"),
                Text("${S.of(context).manager}: ${shift.user?.name ?? '-'}"),
              ],
            ).expand,
            CustomTextBtn(
              text: S.of(context).print,
              onPressed: () async {
                // ✅ 1. اعرض loading
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                );

                try {
                  // ✅ 2. اجلب تفاصيل الـ shift من API
                  final shiftRepo = MyServiceLocator.getSingleton<ShiftRepo>();
                  
                  // استخدم getShiftDetailsForPrint اللي موجودة فعلاً
                  final result = await shiftRepo.getShiftDetailsForPrint(shift.id!);
                  
                  // اخفي الـ loading
                  Navigator.pop(context);
                  
                  result.fold(
                    (error) {
                      // لو فشلت، اعرض رسالة خطأ
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(error.message ?? 'Failed to load shift details')),
                      );
                    },
                    (endShiftModel) async {
                      // ✅ 3. اطبع البيانات
                      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
                      debugPrint('📊 Shift Data #${endShiftModel.shift?.id}');
                      debugPrint('💳 Payment Methods from Summary:');
                      
                      if (endShiftModel.summary?.paymentMethods != null && 
                          endShiftModel.summary!.paymentMethods!.isNotEmpty) {
                        endShiftModel.summary!.paymentMethods!.forEach((key, value) {
                          debugPrint('   • $key: $value');
                        });
                      } else {
                        debugPrint('   ⚠️ No payment methods found!');
                      }
                      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

                      final bool isSunmi = await PrinterHelper().isSunmiDevice();
                      final allAutomaticPrinters =
                          MyServiceLocator.getSingleton<GetPrintersCubit>().printers;

                      for (final printer in allAutomaticPrinters) {
                        if (printer.discoveredPrinter != null) {
                          try {
                            debugPrint('');
                            debugPrint('🖨️ Printing to: ${printer.printerName}');
                            debugPrint('📄 Using paper size: "${printer.paperSize}"');

                            if (isSunmi && (printer.automatic ?? false)) {
                              await printSunmiPDF(
                                  await endShiftInvoicesPdf(
                                    context,
                                    shift: endShiftModel,
                                    size: printer.paperSize ?? '80',
                                  ),
                                  printer.paperSize ?? '80');
                             
                              await SunmiPrinter.lineWrap(4);
                              await SunmiPrinter.cutPaper();
                              await SunmiDrawer.openDrawer();
                            } else if (printer.automatic ?? false) {
                              var invoiceBytesUint8List = await endShiftInvoicesPdf(
                                context,
                                shift: endShiftModel,
                                size: printer.paperSize ?? '80',
                              );
                              
                              await PrinterHelper().printInvoice(
                                printer.discoveredPrinter!,
                                invoiceBytesUint8List,
                                paperSize: printer.paperSize,
                                openCashDrawer: true,
                              );

                              debugPrint('✅ SUCCESS: ${printer.printerName}');
                            }
                          } catch (e) {
                            debugPrint('❌ FAILED: ${printer.printerName} - Error: $e');
                          }
                        }
                      }
                    },
                  );
                } catch (e) {
                  // اخفي الـ loading في حالة حدوث خطأ
                  Navigator.pop(context);
                  debugPrint('❌ Error in print flow: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}