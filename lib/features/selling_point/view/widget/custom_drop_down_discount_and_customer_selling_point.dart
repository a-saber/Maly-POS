import 'package:flutter/material.dart';
import 'package:pos_app/core/utils/app_colors.dart';
import 'package:pos_app/core/widget/custom_reset_drop_down_button.dart';
import 'package:pos_app/features/clients/view/widget/custom_drop_down_client.dart';
import 'package:pos_app/features/discounts/view/widget/custom_drop_down_discount.dart';
import 'package:pos_app/features/selling_point/manager/selling_point_product_cubit/selling_point_product_cubit.dart';
import 'package:pos_app/features/selling_point/view/widget/select_branch_selling_point.dart';

class CustomDropDownDiscountAndCustomerSellingPoint extends StatelessWidget {
  const CustomDropDownDiscountAndCustomerSellingPoint({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 5,
        ),
        Row(
          spacing: 5,
          children: [
            Expanded(
              child: CustomDropDownClient(
                prefixIcon: CustomResetDropDownButton(
                  onPressed: () {
                    SellingPointProductCubit.get(context).changeUser(null);
                  },
                ),
                onChanged: SellingPointProductCubit.get(context).changeUser,
                value: SellingPointProductCubit.get(context).user,
              ),
            ),
            Expanded(
              child: CustomDropDownDiscount(
                onChanged: SellingPointProductCubit.get(context).changeDiscount,
                value: SellingPointProductCubit.get(context).discount,
                prefixIcon: CustomResetDropDownButton(
                  onPressed: () => SellingPointProductCubit.get(context)
                      .changeDiscount(null),
                ),
              ),
            ),
            IconButton(
              onPressed: () =>
                  selectBranch(context: context, selectBranch: true),
              icon: Icon(
                Icons.location_on_outlined,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
