import 'package:flutter/material.dart';
import 'package:pos_app/core/helper/formate_date_time.dart';
import 'package:pos_app/core/router/app_route.dart';
import 'package:pos_app/core/utils/app_font_style.dart';
import 'package:pos_app/core/widget/custom_app_bar.dart';
import 'package:pos_app/core/widget/custom_btn.dart';
import 'package:pos_app/core/widget/custom_build_section_details_view.dart';
import 'package:pos_app/core/widget/custom_pop_up.dart';
import 'package:pos_app/features/sales/data/model/sales_model.dart';
import 'package:pos_app/generated/l10n.dart';

class SalesDetailsView extends StatelessWidget {
  const SalesDetailsView({super.key, required this.salesModel});
  final SalesModel salesModel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: S.of(context).salesDetails,
        actions: [
          TextButton(
            onPressed: salesModel.salesReturnId == null
                ? () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(
                            S.of(context).areYouSureWantToReturn,
                            style: AppFontStyle.itemsTitle(
                              context: context,
                              color: Colors.black,
                            ),
                          ),
                          actions: [
                            CustomTextBtn(
                              text: S.of(context).sure,
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.returnSalesConfirm,
                                  arguments: salesModel,
                                );
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                : () {
                    CustomPopUp.callMyToast(
                      context: context,
                      massage: S.of(context).isReturnedAlready,
                      state: PopUpState.ERROR,
                    );
                  },
            child: Text(
              S.of(context).Return,
              style: AppFontStyle.deleteBtnText(context: context).copyWith(
                fontSize: FontSize.fs18(context),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// --- Sale Info ---
            CustomBuildSectionDeatilsView(
                title: S.of(context).saleInfo,
                children: [
                  CustomInfoRowDetailsView(
                    label: S.of(context).saleId,
                    value: salesModel.id?.toString() ?? S.of(context).unknownId,
                  ),
                  CustomInfoRowDetailsView(
                    label: S.of(context).subTotal,
                    value:
                        "${salesModel.subtotal?.toString() ?? S.of(context).unKnownPrice} ",
                  ),
                  CustomInfoRowDetailsView(
                    label: S.of(context).discountTotal,
                    value:
                        "${salesModel.discountTotal?.toString() ?? S.of(context).unKnownPrice} ",
                  ),
                  CustomInfoRowDetailsView(
                    label: S.of(context).totalAfterDiscount,
                    value:
                        "${salesModel.totalAfterDiscount?.toString() ?? S.of(context).unKnownPrice} ",
                  ),
                  CustomInfoRowDetailsView(
                    label: S.of(context).taxestotal,
                    value:
                        "${salesModel.taxTotal?.toString() ?? S.of(context).unKnownPrice} ",
                  ),
                  CustomInfoRowDetailsView(
                    label: S.of(context).totalAfterTax,
                    value:
                        "${salesModel.totalAfterTax?.toString() ?? S.of(context).unKnownPrice} ",
                  ),
                  CustomInfoRowDetailsView(
                    label: S.of(context).paymentmethod,
                    value: salesModel.paymentMethod ?? S.of(context).unknown,
                  ),
                  CustomInfoRowDetailsView(
                    label: S.of(context).orderType,
                    value: salesModel.orderType ?? S.of(context).unknown,
                  ),
                  CustomInfoRowDetailsView(
                    label: S.of(context).createdAt,
                    value: salesModel.createdAt == null
                        ? S.of(context).unknownDate
                        : getLocalTimeFormate(salesModel.createdAt!),
                  ),
                  CustomInfoRowDetailsView(
                    label: S.of(context).UpdatedAt,
                    value: salesModel.updatedAt == null
                        ? S.of(context).unknownDate
                        : getLocalTimeFormate(salesModel.updatedAt!),
                  ),
                ]),

            const SizedBox(height: 20),

            /// --- User Info ---
            if (salesModel.user != null)
              CustomBuildSectionDeatilsView(
                  title: S.of(context).userInfo,
                  children: [
                    CustomInfoRowDetailsView(
                      label: S.of(context).id,
                      value: salesModel.user?.id?.toString() ??
                          S.of(context).unknownId,
                    ),
                    CustomInfoRowDetailsView(
                      label: S.of(context).name,
                      value: salesModel.user?.name ?? S.of(context).unknown,
                    ),
                    CustomInfoRowDetailsView(
                      label: S.of(context).email,
                      value: salesModel.user?.email ?? S.of(context).unknown,
                    ),
                    CustomInfoRowDetailsView(
                      label: S.of(context).phone,
                      value: salesModel.user?.phone ?? S.of(context).unknown,
                    ),
                    CustomInfoRowDetailsView(
                      label: S.of(context).roleId,
                      value: salesModel.user?.roleId?.toString() ??
                          S.of(context).unknown,
                    ),
                  ]),

            const SizedBox(height: 20),

            /// --- Branch Info ---
            if (salesModel.branch != null)
              CustomBuildSectionDeatilsView(
                  title: S.of(context).branchInfo,
                  children: [
                    CustomInfoRowDetailsView(
                      label: S.of(context).id,
                      value: salesModel.branch?.id?.toString() ??
                          S.of(context).unknownId,
                    ),
                    CustomInfoRowDetailsView(
                      label: S.of(context).name,
                      value: salesModel.branch?.name ?? S.of(context).unknown,
                    ),
                    CustomInfoRowDetailsView(
                      label: S.of(context).address,
                      value:
                          salesModel.branch?.address ?? S.of(context).unknown,
                    ),
                    CustomInfoRowDetailsView(
                      label: S.of(context).phone,
                      value: salesModel.branch?.phone ?? S.of(context).unknown,
                    ),
                  ]),

            const SizedBox(height: 20),

            /// --- Products List ---
            Text(S.of(context).products,
                style: AppFontStyle.itemsTitle(
                  context: context,
                  color: Colors.black,
                ).copyWith(
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: salesModel.saleProducts?.length ?? 0,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            salesModel.saleProducts?[index].product?.name ??
                                S.of(context).unknown,
                            style: AppFontStyle.itemsTitle(
                              context: context,
                              color: Colors.black,
                            )),
                        const SizedBox(height: 6),
                        CustomInfoRowDetailsView(
                          label: S.of(context).Quantity,
                          value: salesModel.saleProducts?[index].quantity
                                  .toString() ??
                              S.of(context).unknown,
                        ),
                        CustomInfoRowDetailsView(
                          label: S.of(context).unitPrice,
                          value:
                              "${salesModel.saleProducts?[index].product?.price.toString() ?? S.of(context).unKnownPrice} ",
                        ),
                        CustomInfoRowDetailsView(
                          label: S.of(context).lineTotalBeforeDiscount,
                          value:
                              "${salesModel.saleProducts?[index].lineTotalBeforeDiscount.toString() ?? S.of(context).unKnownPrice} ",
                        ),
                        CustomInfoRowDetailsView(
                          label: S.of(context).lineTotalAfterTax,
                          value:
                              "${salesModel.saleProducts?[index].lineTotalAfterTax.toString() ?? S.of(context).unKnownPrice} ",
                        ),
                        CustomInfoRowDetailsView(
                          label: S.of(context).unit,
                          value: salesModel
                                  .saleProducts?[index].product?.unit?.name ??
                              S.of(context).unknown,
                        ),
                        CustomInfoRowDetailsView(
                          label: S.of(context).productType,
                          value:
                              salesModel.saleProducts?[index].product?.type ??
                                  S.of(context).unknown,
                        ),
                        CustomInfoRowDetailsView(
                          label: S.of(context).brand,
                          value:
                              salesModel.saleProducts?[index].product?.brand ??
                                  S.of(context).unknown,
                        ),
                        if (salesModel.saleProducts?[index].product?.tax !=
                            null)
                          CustomInfoRowDetailsView(
                            label: S.of(context).taxes,
                            value:
                                "${salesModel.saleProducts?[index].product?.tax?.title ?? S.of(context).unknown} (${salesModel.saleProducts?[index].product?.tax?.percentage ?? S.of(context).unknownPercentage}%)",
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
