import 'package:flutter/material.dart';
import 'package:pos_app/core/constant/constant.dart';
import 'package:pos_app/core/router/app_route.dart';
import 'package:pos_app/core/utils/app_padding.dart';
import 'package:pos_app/core/widget/custom_app_bar.dart';
import 'package:pos_app/core/widget/custom_floating_action_btn.dart';
import 'package:pos_app/core/widget/custom_grid_view_card.dart';
import 'package:pos_app/core/widget/custom_refresh_indicator.dart';
import 'package:pos_app/features/units/manager/get_all_units_cubit/get_all_units_cubit.dart';
import 'package:pos_app/features/units/view/widget/get_all_unit_cubit_build.dart';
import 'package:pos_app/features/units/view/widget/unit_item_build.dart';
import 'package:pos_app/generated/l10n.dart';

class UnitsView extends StatelessWidget {
  const UnitsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: CustomFloatingActionBtn(onPressed: () {
        Navigator.pushNamed(context, AppRoutes.addUnit);
      }),
      appBar: CustomAppBar(title: S.of(context).units),
      body: CustomRefreshIndicator(
        onRefresh: () async {
          GetAllUnitsCubit.get(context).getUnits();
        },
        child: Padding(
          padding: AppPaddings.defaultView,
          child: GetAllUnitCubitBuild(unitsLoading: (context) {
            return CustomGridViewCard(
              itemBuilder: (context, index) {
                return UnitItemLoading();
              },
              itemCount: AppConstant.numberOfCardLoading,
            );
          }, unitsBuild: (context, units) {
            return CustomGridViewCard(
              controller: GetAllUnitsCubit.get(context).scrollController,
              canLaoding: GetAllUnitsCubit.get(context).canLoading(),
              itemBuilder: (BuildContext context, index) {
                return UnitItemBuild(
                  unit: units[index],
                );
              },
              itemCount: units.length,
            );
          }),
        ),
      ),
    );
  }
}
