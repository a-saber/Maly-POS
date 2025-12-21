import 'package:flutter/material.dart';
import 'package:pos_app/core/helper/formate_date_time.dart';
import 'package:pos_app/core/router/app_route.dart';
import 'package:pos_app/core/utils/app_colors.dart';
import 'package:pos_app/core/utils/extensions.dart';
import 'package:pos_app/core/widget/custom_btn.dart';
import 'package:pos_app/core/widget/custom_pop_up.dart';
import 'package:pos_app/features/shifts/data/model/end_shift_model.dart';
import 'package:pos_app/generated/l10n.dart';
import 'package:printing/printing.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';

import '../../../../core/helper/my_service_locator.dart';
import '../../../../core/helper/printer_helper.dart';
import '../../../../core/invoice/sales_invoices_pdf_80.dart';
import '../../../printer/manager/scan_printer/scan_printer_cubit.dart';

Future<void> showDialogForShiftEnd(BuildContext context,
    {required EndShiftModel shift}) async {
  await showDialog(
    context: context,
    // barrierDismissible: false,
    builder: (ctx) {
      return AlertDialog(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              S.of(context).shiftDetails,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.black,
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              "${S.of(context).startAt}: ${getLocalTimeFormate(shift.shift?.startAt ?? '-')}",
              style: const TextStyle(
                color: AppColors.black,
                fontSize: 13,
              ),
            ),
            Text(
              "${S.of(context).endAt}: ${getLocalTimeFormate(shift.shift?.endAt ?? '-')}",
              style: const TextStyle(
                color: AppColors.black,
                fontSize: 13,
              ),
            ),
            Text(
              "${S.of(context).user}: ${(shift.shift?.user?.name ?? '-')}",
              style: const TextStyle(
                color: AppColors.black,
                fontSize: 13,
              ),
            ),
            Text(
              "${S.of(context).branch}: ${(shift.shift?.branch?.name ?? '-')}",
              style: const TextStyle(
                color: AppColors.black,
                fontSize: 13,
              ),
            ),
            Text(
              "${S.of(context).openingQuantity}: ${(double.tryParse(shift.shift?.openingQuantity??'0')?.toStringAsFixed(1) ?? '-')}",
              style: const TextStyle(
                color: AppColors.black,
                fontSize: 13,
              ),
            ),
            Text(
              "${S.of(context).discountTotal}: ${(shift.shift?.discountTotal ?? '-').toAmount()}",
              style: const TextStyle(
                color: AppColors.black,
                fontSize: 13,
              ),
            ),
            Text(
              "${S.of(context).taxestotal}: ${(shift.shift?.taxTotal ?? '-').toAmount()}",
              style: const TextStyle(
                color: AppColors.black,
                fontSize: 13,
              ),
            ),
            Text(
              "${S.of(context).cashTotal}: ${(shift.summary?.paymentMethods?.cash ?? '-').toAmount()}",
              style: const TextStyle(
                color: AppColors.black,
                fontSize: 13,
              ),
            ),
            Text(
              "${S.of(context).onlineTotal}: ${(shift.summary?.paymentMethods?.malypay ?? '-').toAmount()}",
              style: const TextStyle(
                color: AppColors.black,
                fontSize: 13,
              ),
            ),
            Text(
              "${S.of(context).totalAfterTax}: ${(shift.shift?.totalAfterTax ?? '-').toAmount()}",
              style: const TextStyle(
                color: AppColors.black,
                fontSize: 13,
              ),
            ),
            Text(
              "${S.of(context).total}: ${(shift.summary?.totalCollected ?? '-').toAmount()}",
              style: const TextStyle(
                color: AppColors.black,
                fontSize: 13,
              ),
            ),
          ],
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
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
                              shift: shift,
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
                      shift: shift,
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
              ),
              CustomTextBtn(
                text: S.of(context).details,
                onPressed: () {
                  Navigator.pop(context);
                  if (shift.shift?.id == null) {
                    CustomPopUp.callMyToast(
                      context: context,
                      massage: S.of(context).notFoundShift,
                      state: PopUpState.ERROR,
                    );
                    return;
                  }
                  Navigator.pushNamed(
                    context,
                    AppRoutes.shiftDetails,
                    arguments: shift.shift?.id,
                  );
                },
              ),
            ],
          ),
        ],
      );
    },
  );
}
