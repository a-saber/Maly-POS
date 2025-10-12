import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/core/helper/is_mobile.dart';
import 'package:pos_app/core/invoice/sales_invoices_pdf_80.dart';
import 'package:pos_app/core/utils/app_colors.dart';
import 'package:pos_app/core/utils/app_font_style.dart';
import 'package:pos_app/core/widget/custom_pop_up.dart';
import 'package:pos_app/features/selling_point/manager/selling_point_cubit/selling_point_cubit.dart';
import 'package:pos_app/features/selling_point/manager/selling_point_product_cubit/selling_point_product_cubit.dart';
import 'package:pos_app/generated/l10n.dart';
import 'package:printing/printing.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';

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
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                }
                try {
                  if (!Platform.isAndroid) {
                    throw 'not android';
                  }
                  await printSunmiPDF(await salesInvoicesPdf80(
                    state.printModel.apiResponse.data as Map<String, dynamic>,
                    branchName: state.printModel.branchName,
                    paid: state.printModel.paid,
                  ));
                  await SunmiPrinter.lineWrap(4);
                  await SunmiPrinter.cutPaper();
                } catch (e) {
                  Navigator.push(
                    // ignore: use_build_context_synchronously
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
                            );
                          }),
                        );
                      },
                    ),
                  );
                }

                // ignore: use_build_context_synchronously
                SellingPointCubit.get(context).getCategoryProduct();

                CustomPopUp.callMyToast(
                  // ignore: use_build_context_synchronously
                  context: context,
                  // ignore: use_build_context_synchronously
                  massage: S.of(context).confirmPaymentSuccess,
                  state: PopUpState.SUCCESS,
                );
              } else if (state is SellingPointProductFailing) {
                if (context.mounted) {
                  CustomPopUp.callMyToast(
                    context: context,
                    massage: mapStatusCodeToMessage(context, state.message),
                    state: PopUpState.ERROR,
                  );
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
