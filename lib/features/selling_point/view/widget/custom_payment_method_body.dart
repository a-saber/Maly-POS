import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/constant/constant.dart';
import 'package:pos_app/core/utils/app_colors.dart';
import 'package:pos_app/core/utils/app_font_style.dart';
import 'package:pos_app/features/selling_point/manager/selling_point_product_cubit/selling_point_product_cubit.dart';

class CustomPaymentMethodBody extends StatelessWidget {
  const CustomPaymentMethodBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SellingPointProductCubit, SellingPointProductState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            AppConstant.paymentMethods(context).length,
            (index) => InkWell(
              onTap: () => SellingPointProductCubit.get(context)
                  .changePaymentMethod(
                      AppConstant.paymentMethods(context)[index]),
              child: CustomCardPaymentMethod(
                icon: AppConstant.paymentMethods(context)[index].icon,
                title: AppConstant.paymentMethods(context)[index].name,
                isActive:
                    (SellingPointProductCubit.get(context).paymentMethod?.id ??
                            -1) ==
                        AppConstant.paymentMethods(context)[index].id,
              ),
            ),
          ),
        );
      },
    );
  }
}

class CustomCardPaymentMethod extends StatelessWidget {
  const CustomCardPaymentMethod({
    super.key,
    required this.icon,
    required this.title,
    required this.isActive,
  });
  final IconData icon;
  final String title;
  final bool isActive;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(end: 10),
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.grey),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              children: [
                Icon(
                  icon,
                  color: AppColors.black,
                ),
                Text(
                  title,
                  style: AppFontStyle.itemssmallTitle(
                    context: context,
                    color: AppColors.black,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Positioned(
            right: 1,
            top: 1,
            child: isActive
                ? Container(
                    decoration: BoxDecoration(
                      color: AppColors.success,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.success),
                    ),
                    child: Icon(
                      Icons.check,
                      color: AppColors.white,
                      size: 12,
                    ),
                  )
                : SizedBox(),
          ),
        ],
      ),
    );
  }
}
