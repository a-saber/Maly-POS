import 'package:flutter/material.dart';
import 'package:pos_app/core/constant/constant.dart';
import 'package:pos_app/core/router/app_route.dart';
import 'package:pos_app/core/utils/app_padding.dart';
import 'package:pos_app/core/widget/custom_app_bar.dart';
import 'package:pos_app/core/widget/custom_floating_action_btn.dart';
import 'package:pos_app/core/widget/custom_grid_view_card.dart';
import 'package:pos_app/core/widget/custom_refresh_indicator.dart';
import 'package:pos_app/features/taxes/manager/get_all_taxes_cubit/get_all_taxes_cubit.dart';
import 'package:pos_app/features/taxes/view/widget/get_all_taxes_cubit_build.dart';
import 'package:pos_app/features/taxes/view/widget/taxes_item_build.dart';
import 'package:pos_app/generated/l10n.dart';

class TaxesView extends StatelessWidget {
  const TaxesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: CustomFloatingActionBtn(onPressed: () {
        Navigator.pushNamed(context, AppRoutes.addTaxes);
      }),
      appBar: CustomAppBar(title: S.of(context).taxes),
      body: CustomRefreshIndicator(
        onRefresh: () async {
          GetAllTaxesCubit.get(context).getTaxes();
        },
        child: Padding(
          padding: AppPaddings.defaultView,
          child: GetAllTaxesCubitBuild(
            taxesLoading: (context) {
              return CustomGridViewCard(
                itemBuilder: (BuildContext context, int index) {
                  return TaxesItemLoading();
                },
                itemCount: AppConstant.numberOfCardLoading,
              );
            },
            taxesBuild: (context, taxes) {
              return CustomGridViewCard(
                controller: GetAllTaxesCubit.get(context).scrollController,
                canLaoding: GetAllTaxesCubit.get(context).canLoading(),
                itemBuilder: (BuildContext context, int index) {
                  return TaxesItemBuild(taxes: taxes[index]);
                },
                itemCount: taxes.length,
              );
            },
          ),
        ),
      ),
    );
  }
}
