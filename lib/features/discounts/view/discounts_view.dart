import 'package:flutter/material.dart';
import 'package:pos_app/core/constant/constant.dart';
import 'package:pos_app/core/router/app_route.dart';
import 'package:pos_app/core/utils/app_padding.dart';
import 'package:pos_app/core/widget/custom_app_bar.dart';
import 'package:pos_app/core/widget/custom_floating_action_btn.dart';
import 'package:pos_app/core/widget/custom_grid_view_card.dart';
import 'package:pos_app/core/widget/custom_refresh_indicator.dart';
import 'package:pos_app/features/discounts/manager/get_all_discounts_cubit/get_all_discounts_cubit.dart';
import 'package:pos_app/features/discounts/view/widget/discount_item_build.dart';
import 'package:pos_app/features/discounts/view/widget/get_all_discount_cubit_build.dart';
import 'package:pos_app/generated/l10n.dart';

class DiscountsView extends StatelessWidget {
  const DiscountsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: CustomFloatingActionBtn(onPressed: () {
        Navigator.pushNamed(context, AppRoutes.addDiscount);
      }),
      appBar: CustomAppBar(title: S.of(context).discounts),
      body: CustomRefreshIndicator(
        onRefresh: () async {
          GetAllDiscountsCubit.get(context).getDiscounts();
        },
        child: Padding(
          padding: AppPaddings.defaultView,
          child: GetAllDiscountCubitBuild(
            discountLoading: (context) {
              return CustomGridViewCard(
                itemBuilder: (context, index) {
                  return DiscountItemLoading();
                },
                itemCount: AppConstant.numberOfCardLoading,
              );
            },
            discountsBuild: (context, discounts) {
              return CustomGridViewCard(
                controller: GetAllDiscountsCubit.get(context).scrollController,
                canLaoding: GetAllDiscountsCubit.get(context).canLoading(),
                itemBuilder: (BuildContext context, int index) {
                  return DiscountItemBuild(discount: discounts[index]);
                },
                itemCount: discounts.length,
              );
            },
          ),
        ),
      ),
    );
  }
}
