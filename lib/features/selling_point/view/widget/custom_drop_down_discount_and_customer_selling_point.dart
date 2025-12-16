import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/utils/app_colors.dart';
import 'package:pos_app/core/widget/custom_reset_drop_down_button.dart';
import 'package:pos_app/features/clients/view/widget/custom_drop_down_client.dart';
import 'package:pos_app/features/discounts/view/widget/custom_drop_down_discount.dart';
import 'package:pos_app/features/selling_point/manager/selling_point_product_cubit/selling_point_product_cubit.dart';
import 'package:pos_app/features/selling_point/view/widget/customdiscountdialog.dart';
import 'package:pos_app/features/selling_point/view/widget/select_branch_selling_point.dart';

class CustomDropDownDiscountAndCustomerSellingPoint extends StatelessWidget {
  const CustomDropDownDiscountAndCustomerSellingPoint({
    super.key,
  });

  void _showCustomDiscountDialog(BuildContext context) async {
    final cubit = SellingPointProductCubit.get(context);
    
    final result = await showDialog(
      context: context,
      builder: (context) => CustomDiscountDialog(
        currentDiscount: cubit.discount,
      ),
    );

    if (result != null) {
      if (result == 'DELETE') {
        cubit.changeDiscount(null);
      } else {
        cubit.changeDiscount(result);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SellingPointProductCubit, SellingPointProductState>(
      builder: (context, state) {
        final cubit = SellingPointProductCubit.get(context);
        final hasCustomDiscount = cubit.discount != null && cubit.discount!.id == -1;

        return Column(
          children: [
            SizedBox(height: 5),
            Row(
              spacing: 5,
              children: [
                Expanded(
                  child: CustomDropDownClient(
                    prefixIcon: CustomResetDropDownButton(
                      onPressed: () {
                        cubit.changeUser(null);
                      },
                    ),
                    onChanged: cubit.changeUser,
                    value: cubit.user,
                  ),
                ),
                Expanded(
                  child: CustomDropDownDiscount(
                    onChanged: cubit.changeDiscount,
                    value: cubit.discount,
                    prefixIcon: CustomResetDropDownButton(
                      onPressed: () => cubit.changeDiscount(null),
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
            
            SizedBox(height: 8),
            
            if (!hasCustomDiscount)
              Material(
                color: AppColors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
                child: InkWell(
                  onTap: () => _showCustomDiscountDialog(context),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 200,
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.percent, color: Colors.black, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'خصم مخصص',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
             
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.primary, width: 2),
                ),
                child: Row(
                  children: [
                 
                    CustomResetDropDownButton(
                      onPressed: () => cubit.changeDiscount(null),
                    ),
                    SizedBox(width: 8),
                    
                 
                    Expanded(
                      child: InkWell(
                        onTap: () => _showCustomDiscountDialog(context),
                        child: Row(
                          children: [
                            Icon(
                              Icons.discount,
                              color: AppColors.primary,
                              size: 16,
                            ),
                            SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                'خصم مخصص: ${cubit.discount!.value}${cubit.discount!.type!.name == 'percentage' ? '%' : ' ريال'}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Icon(
                              Icons.edit,
                              color: Colors.grey,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}