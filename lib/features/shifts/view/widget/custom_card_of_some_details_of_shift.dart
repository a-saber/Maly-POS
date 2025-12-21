import 'package:flutter/material.dart';
import 'package:pos_app/core/helper/formate_date_time.dart';
import 'package:pos_app/core/router/app_route.dart';
import 'package:pos_app/core/utils/extensions.dart';
import 'package:pos_app/features/shifts/data/model/shifts_model.dart';
import 'package:pos_app/generated/l10n.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';

import '../../../../core/helper/my_service_locator.dart';
import '../../../../core/helper/printer_helper.dart';
import '../../../../core/invoice/sales_invoices_pdf_80.dart';
import '../../../../core/widget/custom_btn.dart';
import '../../../printer/manager/scan_printer/scan_printer_cubit.dart';
import '../../data/model/end_shift_model.dart';

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
                Text(
                    "${S.of(context).startAt}: ${getLocalTimeFormate(shift.startAt ?? '-')}"),
                Text(
                    "${S.of(context).endAt}: ${getLocalTimeFormate(shift.endAt ?? '-')}"),
                Text("${S.of(context).ordersCount}: ${shift.ordersCount ?? 0}"),
                Text("${S.of(context).branch}: ${shift.branch?.name ?? '-'}"),
                Text("${S.of(context).manager}: ${shift.user?.name ?? '-'}"),
              ],
            ).expand,
            CustomTextBtn(
              text: S.of(context).print,
              onPressed: () async {
                /*  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) {
                        return Scaffold(
                          appBar: AppBar(),
                          body: PdfPreview(build: (_) {
                            return endShiftInvoicesPdf(
                               context,
                                shift: shift,
                                size:'80'
                            );
                          }),
                        );
                      },
                    ),
                  );*/
                final bool isSunmi=await PrinterHelper().isSunmiDevice();
                final allAutomaticPrinters = MyServiceLocator.getSingleton<GetPrintersCubit>().printers;
                for (final printer in allAutomaticPrinters) {

                  if (printer.discoveredPrinter != null ) {

                    try {
                      debugPrint('');
                      debugPrint(' Printing to: ${printer.printerName}');
                      debugPrint(' Using paper size: "${printer.paperSize}"');
                      if(isSunmi && (printer?.automatic??false)){

                        await printSunmiPDF(await endShiftInvoicesPdf(
                            context,
                            shift: EndShiftModel(
                              shift: shift,
                            ),
                            size:printer.paperSize??'80'
                        ), printer.paperSize??'80');

                        await SunmiPrinter.lineWrap(4);
                        await SunmiPrinter.cutPaper();
                        await SunmiDrawer.openDrawer();
                        /*   if( state.printModel.apiResponse.data[ApiKeys.sale][ApiKeys.ordertype]==ApiKeys.hall){
                          await SunmiDrawer.openDrawer();
                            }*/
                      }
                      else if((printer.automatic??false)){

                        var invoiceBytesUint8List = await endShiftInvoicesPdf(
                            context,
                            shift: EndShiftModel(
                                shift: shift

                            ),
                            size:printer.paperSize??'80'
                        );

                        await PrinterHelper().printInvoice(
                          printer.discoveredPrinter!,
                          invoiceBytesUint8List,
                          // invoiceData,
                          paperSize: printer.paperSize,
                          openCashDrawer: true,
                        );
                        // await PrinterHelper().printWidget(context, printer.discoveredPrinter!);


                        debugPrint(' SUCCESS: ${printer.printerName}');
                      }
                    } catch (e) {

                      debugPrint(
                          ' FAILED: ${printer.printerName} - Error: $e');
                    }
                  }



                }
              },
            )
          ],
        ),
      ),
    );
  }
}
