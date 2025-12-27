
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/core/helper/is_mobile.dart';
import 'package:pos_app/core/helper/my_service_locator.dart';
import 'package:pos_app/core/helper/printer_helper.dart';
import 'package:pos_app/core/invoice/sales_invoices_pdf_80.dart';
import 'package:pos_app/core/utils/app_colors.dart';
import 'package:pos_app/core/utils/app_font_style.dart';
import 'package:pos_app/core/widget/custom_pop_up.dart';
import 'package:pos_app/features/branch/manager/get_all_branches_cubit/get_all_branches_cubit.dart';
import 'package:pos_app/features/printer/manager/scan_printer/scan_printer_cubit.dart';
import 'package:pos_app/features/selling_point/manager/selling_point_cubit/selling_point_cubit.dart';
import 'package:pos_app/features/selling_point/manager/selling_point_product_cubit/selling_point_product_cubit.dart';
import 'package:pos_app/features/shifts/manager/shift_cubit/shift_cubit.dart';
import 'package:pos_app/features/shifts/view/widget/showdialog_for_shift.dart';
import 'package:pos_app/generated/l10n.dart';
import 'package:printing/printing.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';

import '../../../../core/cache/cache_helper.dart';
import '../../../../core/cache/cache_keys.dart';

class CustomSellingPointCardButtons extends StatelessWidget {
  const CustomSellingPointCardButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 5,
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
              SellingPointProductCubit.get(context).resetProduct();

              if (isMobile(context: context)) {
                Navigator.pop(context);
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.error,
                border: Border.all(color: AppColors.error, width: 1.5),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                S.of(context).cancel,
                textAlign: TextAlign.center,
                style: AppFontStyle.itemsSubTitle(
                  context: context,
                  color: AppColors.white,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child:
              BlocConsumer<SellingPointProductCubit, SellingPointProductState>(
            listener: (context, state) async {
              if (state is SellingPointProductSuccess) {
                if (isMobile(context: context)) {
                  Navigator.pop(context);
                }
                CustomPopUp.callMyToast(
                  context: context,
                  massage: S.of(context).confirmPaymentSuccess,
                  state: PopUpState.SUCCESS,
                );

               final bool isSunmi=await PrinterHelper().isSunmiDevice();
                try {
               if (state.printModel.madaReceipt != null) {
                    await printSunmiPDF(state.printModel.madaReceipt!,'58');
                    await SunmiPrinter.lineWrap(4);
                    await SunmiPrinter.cutPaper();
                  }
               // throw Exception();
                  final allAutomaticPrinters = MyServiceLocator.getSingleton<GetPrintersCubit>().printers;
                          // .where((p) => p.automatic == true)


                  debugPrint('');
                  debugPrint(' ==================== SALE SUCCESS ====================');
                  debugPrint(' Total Automatic Printers: ${allAutomaticPrinters.length}');

                /*  for (int i = 0; i < allAutomaticPrinters.length; i++) {
                    final p = allAutomaticPrinters[i];
                    debugPrint('');
                    debugPrint(' Printer ${i + 1}:');
                   // debugPrint('   - Automatic: ${p.categories?.firstOrNull}');
                    debugPrint('   - Name: ${p.printerName}');
                    debugPrint('   - Paper Size: "${p.paperSize}"');
                    debugPrint('   - Type: ${p.communicationType}');
                  } 
                  debugPrint('========================================================');
                  debugPrint('');*/
                 /* final invoiceData = {
                    'date': DateTime.now().toString(),
                    'id': state.printModel.apiResponse.data['sale']['id']
                            ?.toString() ??
                        '',
                    'items': (state.printModel.apiResponse.data['sale']
                                ['sale_products'] as List?)
                            ?.map((p) => {
                                  'name': p['product']?['name'] ?? '',
                                  'qty': p['quantity']?.toString() ?? '0',
                                  'price': p['price']?.toString() ?? '0',
                                  'total': p['line_total_after_discount']
                                          ?.toString() ??
                                      '0',
                                })
                            .toList() ??
                        [],
                    'total': state.printModel.apiResponse
                            .data['sale']['total_after_tax']
                            ?.toString() ??
                        '0',
                  };*/
                  int successCount = 0;
                  int failCount = 0;
                  for (final printer in allAutomaticPrinters) {
                    if (printer.discoveredPrinter != null ) {
                      try {

                        if(isSunmi &&  (printer?.automatic??false)){
                          debugPrint('Date before ${DateTime.now()}');

                           for(int i=0;i<(printer.printReceiptCount??1);i++) {
                             await printSunmiPDF(await salesInvoicesPdfSunmi(
                                 state.printModel.apiResponse.data as Map<String, dynamic>,
                                 branchName: state.printModel.branchName,
                                 paid: state.printModel.paid,size: printer.paperSize??'80'), '58');

                             await SunmiPrinter.lineWrap(4);
                             await SunmiPrinter.cutPaper();
                             await SunmiDrawer.openDrawer();

                             /*   if( state.printModel.apiResponse.data[ApiKeys.sale][ApiKeys.ordertype]==ApiKeys.hall){
                          await SunmiDrawer.openDrawer();
                            }*/
                           }
                           CacheHelper.saveData(key:  CacheKeys.invoiceNumber, value:   ((CacheHelper.getData(key: CacheKeys.invoiceNumber)??0)+1));
                        }
                        else if((printer.automatic??false)){
                          for(int i=0;i<(printer.printReceiptCount??1);i++) {
                        var invoiceBytesUint8List = await salesInvoicesPdf80(
                          state.printModel.apiResponse.data as Map<String, dynamic>,
                          branchName: state.printModel.branchName,
                          paid: state.printModel.paid,
                          size: printer.paperSize??'80'
                        );

                        await PrinterHelper().printInvoice(
                          printer.discoveredPrinter!,
                          invoiceBytesUint8List,
                          // invoiceData,
                          paperSize: printer.paperSize,
                          openCashDrawer: true,
                        );
                         // await PrinterHelper().printWidget(context, printer.discoveredPrinter!);

                        successCount++;
                        debugPrint(' SUCCESS: ${printer.printerName}');

                        }
                          CacheHelper.saveData(key:  CacheKeys.invoiceNumber, value:   ((CacheHelper.getData(key: CacheKeys.invoiceNumber)??0)+1));
                        }
                      } catch (e) {
                        failCount++;
                        debugPrint(
                            ' FAILED: ${printer.printerName} - Error: $e');
                      }
                    }

                  }
                  debugPrint('');
                  debugPrint('📊 ==================== SUMMARY ====================');
                  debugPrint('📊 Total Printers: ${allAutomaticPrinters.length}');
                  debugPrint(' Successful: $successCount');
                  debugPrint(' Failed: $failCount');
                  debugPrint('===================================================');
                  debugPrint('');

                  // if (!Platform.isAndroid) {
                  //   throw 'not android';
                  // }

                  // await printSunmiPDF(await salesInvoicesPdf80(
                  //   state.printModel.apiResponse.data as Map<String, dynamic>,
                  //   branchName: state.printModel.branchName,
                  //   paid: state.printModel.paid,
                  // ));
                  // await SunmiPrinter.lineWrap(4);
                  // await SunmiPrinter.cutPaper();
                } catch (e) {
                  debugPrint(' Sunmi print failed or not Android: $e');
                  if (state.printModel.madaReceipt != null) {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) {
                          return Scaffold(
                            appBar: AppBar(),
                            body: PdfPreview(build: (_) {
                              return state.printModel.madaReceipt!;
                            }),
                          );
                        },
                      ),
                    );
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) {
                        return Scaffold(
                          appBar: AppBar(),
                          body: PdfPreview(build: (_) {
                            return salesInvoicesPdf80(
                              state.printModel.apiResponse.data
                                  as Map<String, dynamic>,
                              branchName: state.printModel.branchName,
                              paid: state.printModel.paid,
                               size:'80'
                            );
                          }),
                        );
                      },
                    ),
                  );
                }

                //MyServiceLocator.getIt<SellingPointCubit>().getCategoryProduct();


              }
              else if (state is SellingPointProductFailing) {
               // debugPrint(' ==================== ${PrinterHelper.getSavedLocalPrinter().map((toElement)=>toElement.toJson([]))} ====================');

                if (context.mounted) {
                  if (state.message.shiftError != null &&
                      (state.message.shiftError ?? false)) {
                    /*showStartShiftDialog(
                      context,
                      branchescubit:
                          MyServiceLocator.getIt<GetAllBranchesCubit>(),
                      shiftcubit: MyServiceLocator.getIt<ShiftCubit>(),
                      currentBranch:
                          SellingPointProductCubit.get(context).repo.branch,
                    );*/

                    SellingPointProductCubit.get(context).startShift();
                  }
                 /* CustomPopUp.callMyToast(
                    context: context,
                    massage: mapStatusCodeToMessage(context, state.message),
                    state: PopUpState.ERROR,
                  );*/
                }
              }
            },
            builder: (context, state) {
              return state is SellingPointProductLoading
                  ? Align(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(),
                    )
                  : InkWell(
                      onTap: SellingPointProductCubit.get(context)
                              .products
                              .isEmpty
                          ? () {
                              CustomPopUp.callMyToast(
                                context: context,
                                massage: S.of(context).noItemInCart,
                                state: PopUpState.WARNING,
                              );
                            }
                          : SellingPointProductCubit.get(context)
                                      .paymentMethod ==
                                  null
                              ? () {
                                  CustomPopUp.callMyToast(
                                    context: context,
                                    massage: S.of(context).selectPaymentMethod,
                                    state: PopUpState.WARNING,
                                  );
                                }
                              : SellingPointProductCubit.get(context)
                                          .typeOfTakeOrder ==
                                      null
                                  ? () {
                                      CustomPopUp.callMyToast(
                                        context: context,
                                        massage:
                                            S.of(context).selectTypeOfTakeOrder,
                                        state: PopUpState.WARNING,
                                      );
                                    }
                                  : double.tryParse(
                                            SellingPointProductCubit.get(
                                                    context)
                                                .paidController
                                                .text,
                                          ) ==
                                          null
                                      ? () {
                                          SellingPointProductCubit.get(context)
                                              .confirmPayment();
                                        }
                                      : double.tryParse(
                                                SellingPointProductCubit.get(
                                                        context)
                                                    .paidController
                                                    .text,
                                              )! <
                                              SellingPointProductCubit.get(
                                                      context)
                                                  .roundTotolPrice()
                                          ? () {
                                              CustomPopUp.callMyToast(
                                                context: context,
                                                massage: S
                                                    .of(context)
                                                    .paidShouldBeMoreThanTotalPrice,
                                                state: PopUpState.WARNING,
                                              );
                                            }
                                          : () {
                                              SellingPointProductCubit.get(
                                                      context)
                                                  .confirmPayment();
                                            },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: AppColors.success,
                          border:
                              Border.all(color: AppColors.success, width: 1.5),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          S.of(context).payment,
                          textAlign: TextAlign.center,
                          style: AppFontStyle.itemsSubTitle(
                            context: context,
                            color: AppColors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    );
            },
          ),
        ),
      ],
    );
  }
}
