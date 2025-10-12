import 'package:flutter/material.dart';
import 'package:pos_app/core/utils/app_colors.dart';
import 'package:pos_app/core/utils/app_font_style.dart';
import 'package:pos_app/features/selling_point/manager/selling_point_product_cubit/selling_point_product_cubit.dart';
import 'package:pos_app/generated/l10n.dart';

class CustomBodyOfPrice extends StatelessWidget {
  const CustomBodyOfPrice({
    super.key,
    this.payment,
    this.showAllData = true,
  });
  final double? payment;
  final bool showAllData;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        showAllData
            ? costItem(context, S.of(context).subTotal,
                SellingPointProductCubit.get(context).subTotalPrice())
            : SizedBox(),
        showAllData
            ? costItem(context, S.of(context).discounts,
                SellingPointProductCubit.get(context).discountPrice())
            : SizedBox(),
        showAllData
            ? costItem(context, S.of(context).totalafterdiscount,
                SellingPointProductCubit.get(context).totalAfterDiscount())
            : SizedBox(),
        showAllData
            ? costItem(
                context,
                S.of(context).taxestotal,
                SellingPointProductCubit.get(context).taxesPrice(),
              )
            : SizedBox(),
        showAllData
            ? costItem(context, S.of(context).totalaftertax,
                SellingPointProductCubit.get(context).totalAfterTax())
            : SizedBox(),
        costItem(context, S.of(context).total,
            SellingPointProductCubit.get(context).totalPrice()),
        payment == null
            ? SizedBox()
            : costItem(
                context,
                S.of(context).paid,
                payment!,
              ),
        payment == null
            ? SizedBox()
            : costItem(
                context,
                S.of(context).rest,
                ((payment! -
                                SellingPointProductCubit.get(context)
                                    .totalPrice()) *
                            100)
                        .truncateToDouble() /
                    100,
              ),
      ],
    );
  }

  Widget costItem(BuildContext context, String title, double price) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 2,
              child: Text(
                title,
                style: AppFontStyle.itemsSubTitle(
                  context: context,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              child: Text(
                // '\$${(price * 100).truncateToDouble() / 100}',
                SellingPointProductCubit.get(context).round2(price).toString(),
                style: AppFontStyle.itemsSubTitle(
                  context: context,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
