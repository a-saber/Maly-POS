import 'package:flutter/material.dart';
import 'package:pos_app/core/helper/formate_date_time.dart';
import 'package:pos_app/core/widget/custom_app_bar.dart';
import 'package:pos_app/core/widget/custom_build_section_details_view.dart';
import 'package:pos_app/features/sales_returns/data/model/sales_return_model.dart';
import 'package:pos_app/generated/l10n.dart';

class SalesReturnDetailsView extends StatelessWidget {
  const SalesReturnDetailsView({super.key, required this.salesReturnModel});
  final SalesReturnModel salesReturnModel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: S.of(context).salesReturnDetails,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// --- Sales Return Info ---
            CustomBuildSectionDeatilsView(
              title: S.of(context).returnInfo,
              children: [
                CustomInfoRowDetailsView(
                  label: S.of(context).id,
                  value: salesReturnModel.id?.toString() ??
                      S.of(context).unknownId,
                ),
                CustomInfoRowDetailsView(
                  label: S.of(context).saleId,
                  value: salesReturnModel.saleId?.toString() ??
                      S.of(context).unknownId,
                ),
                CustomInfoRowDetailsView(
                  label: S.of(context).reason,
                  value: salesReturnModel.reason ?? S.of(context).unknown,
                ),
                CustomInfoRowDetailsView(
                  label: S.of(context).createdAt,
                  value: salesReturnModel.createdAt == null
                      ? S.of(context).unknownDate
                      : getLocalTimeFormate(salesReturnModel.createdAt!),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// --- Sale Info ---
            if (salesReturnModel.sale != null)
              CustomBuildSectionDeatilsView(
                title: S.of(context).saleInfo,
                children: [
                  CustomInfoRowDetailsView(
                    label: S.of(context).id,
                    value: salesReturnModel.sale?.id?.toString() ??
                        S.of(context).unknownId,
                  ),
                  CustomInfoRowDetailsView(
                    label: S.of(context).subTotal,
                    value:
                        "${salesReturnModel.sale?.subtotal ?? S.of(context).unKnownPrice} ",
                  ),
                  CustomInfoRowDetailsView(
                    label: S.of(context).discountTotal,
                    value:
                        "${salesReturnModel.sale?.discountTotal ?? S.of(context).unKnownPrice} ",
                  ),
                  CustomInfoRowDetailsView(
                    label: S.of(context).totalAfterDiscount,
                    value:
                        "${salesReturnModel.sale?.totalAfterDiscount ?? S.of(context).unKnownPrice} ",
                  ),
                  CustomInfoRowDetailsView(
                    label: S.of(context).taxestotal,
                    value:
                        "${salesReturnModel.sale?.taxTotal ?? S.of(context).unKnownPrice} ",
                  ),
                  CustomInfoRowDetailsView(
                    label: S.of(context).totalAfterTax,
                    value:
                        "${salesReturnModel.sale?.totalAfterTax ?? S.of(context).unKnownPrice} ",
                  ),
                  CustomInfoRowDetailsView(
                    label: S.of(context).paymentmethod,
                    value: salesReturnModel.sale?.paymentMethod ??
                        S.of(context).unknown,
                  ),
                  CustomInfoRowDetailsView(
                    label: S.of(context).orderType,
                    value: salesReturnModel.sale?.orderType ??
                        S.of(context).unknown,
                  ),
                  CustomInfoRowDetailsView(
                    label: S.of(context).createdAt,
                    value: salesReturnModel.sale?.createdAt == null
                        ? S.of(context).unknownDate
                        : getLocalTimeFormate(
                            salesReturnModel.sale!.createdAt!),
                  ),
                  CustomInfoRowDetailsView(
                    label: S.of(context).UpdatedAt,
                    value: salesReturnModel.sale?.updatedAt == null
                        ? S.of(context).unknownDate
                        : getLocalTimeFormate(
                            salesReturnModel.sale!.updatedAt!),
                  ),
                ],
              ),

            const SizedBox(height: 20),

            /// --- Return User Info ---
            if (salesReturnModel.user != null)
              CustomBuildSectionDeatilsView(
                title: S.of(context).returnUser,
                children: [
                  CustomInfoRowDetailsView(
                    label: S.of(context).id,
                    value: salesReturnModel.user?.id?.toString() ??
                        S.of(context).unknownId,
                  ),
                  CustomInfoRowDetailsView(
                    label: S.of(context).name,
                    value: salesReturnModel.user?.name ?? S.of(context).unknown,
                  ),
                  CustomInfoRowDetailsView(
                    label: S.of(context).email,
                    value:
                        salesReturnModel.user?.email ?? S.of(context).unknown,
                  ),
                ],
              ),

            const SizedBox(height: 20),

            /// --- Sale User Info ---
            if (salesReturnModel.sale?.user != null)
              CustomBuildSectionDeatilsView(
                title: S.of(context).saleUser,
                children: [
                  CustomInfoRowDetailsView(
                    label: S.of(context).id,
                    value: salesReturnModel.sale?.user?.id?.toString() ??
                        S.of(context).unknownId,
                  ),
                  CustomInfoRowDetailsView(
                    label: S.of(context).name,
                    value: salesReturnModel.sale?.user?.name ??
                        S.of(context).unknown,
                  ),
                ],
              ),

            const SizedBox(height: 20),

            /// --- Customer Info ---
            if (salesReturnModel.sale?.customer != null)
              CustomBuildSectionDeatilsView(
                title: S.of(context).customerInfo,
                children: [
                  CustomInfoRowDetailsView(
                    label: S.of(context).id,
                    value: salesReturnModel.sale?.customer?.id?.toString() ??
                        S.of(context).unknownId,
                  ),
                  CustomInfoRowDetailsView(
                    label: S.of(context).name,
                    value: salesReturnModel.sale?.customer?.name ??
                        S.of(context).unknown,
                  ),
                  CustomInfoRowDetailsView(
                    label: S.of(context).phone,
                    value: salesReturnModel.sale?.customer?.phone ??
                        S.of(context).unknown,
                  ),
                  CustomInfoRowDetailsView(
                    label: S.of(context).email,
                    value: salesReturnModel.sale?.customer?.email ??
                        S.of(context).unknown,
                  ),
                ],
              ),

            const SizedBox(height: 20),

            /// --- Discount Info ---
            if (salesReturnModel.sale?.discount != null)
              CustomBuildSectionDeatilsView(
                title: S.of(context).discountInfo,
                children: [
                  CustomInfoRowDetailsView(
                    label: S.of(context).id,
                    value: salesReturnModel.sale?.discount?.id?.toString() ??
                        S.of(context).unknownId,
                  ),
                  CustomInfoRowDetailsView(
                    label: S.of(context).title,
                    value: salesReturnModel.sale?.discount?.title ??
                        S.of(context).unknown,
                  ),
                  CustomInfoRowDetailsView(
                    label: S.of(context).type,
                    value: salesReturnModel.sale?.discount?.type?.name ??
                        S.of(context).unknown,
                  ),
                  CustomInfoRowDetailsView(
                    label: S.of(context).value,
                    value:
                        "${salesReturnModel.sale?.discount?.value ?? S.of(context).unKnownPrice} \$",
                  ),
                ],
              ),

            const SizedBox(height: 20),

            /// --- Branch Info ---
            if (salesReturnModel.sale?.branch != null)
              CustomBuildSectionDeatilsView(
                title: S.of(context).branchInfo,
                children: [
                  CustomInfoRowDetailsView(
                    label: S.of(context).id,
                    value: salesReturnModel.sale?.branch?.id?.toString() ??
                        S.of(context).unknownId,
                  ),
                  CustomInfoRowDetailsView(
                    label: S.of(context).name,
                    value: salesReturnModel.sale?.branch?.name ??
                        S.of(context).unknown,
                  ),
                  CustomInfoRowDetailsView(
                    label: S.of(context).address,
                    value: salesReturnModel.sale?.branch?.address ??
                        S.of(context).unknown,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
