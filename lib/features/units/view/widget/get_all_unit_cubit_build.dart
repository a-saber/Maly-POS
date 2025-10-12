import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/core/widget/custom_empty_view.dart';
import 'package:pos_app/core/widget/custom_error_view.dart';
import 'package:pos_app/core/widget/custom_pop_up.dart';
import 'package:pos_app/features/units/data/model/unit_model.dart';
import 'package:pos_app/features/units/manager/get_all_units_cubit/get_all_units_cubit.dart';

class GetAllUnitCubitBuild extends StatelessWidget {
  const GetAllUnitCubitBuild(
      {super.key, required this.unitsLoading, required this.unitsBuild});
  final Widget Function(BuildContext context) unitsLoading;
  final Widget Function(BuildContext context, List<UnitModel> units) unitsBuild;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GetAllUnitsCubit, GetAllUnitsState>(
      listener: (context, state) {
        if (state is GetAllUnitsPaginationFailing) {
          if (context.mounted) {
            CustomPopUp.callMyToast(
                context: context,
                massage: mapStatusCodeToMessage(context, state.errMessage),
                state: PopUpState.ERROR);
          }
        }
      },
      builder: (context, state) {
        if (state is GetAllUnitsFailing) {
          return CustomError(
            error: context.mounted
                ? mapStatusCodeToMessage(context, state.errMessage)
                : 'error',
            onPressed: () => GetAllUnitsCubit.get(context).getUnits(),
          );
        } else if (state is GetAllUnitsLoading) {
          return unitsLoading(context);
        }
        if (GetAllUnitsCubit.get(context).units.isEmpty) {
          return CustomEmptyView(
            onPressed: () => GetAllUnitsCubit.get(context).getUnits(),
          );
        } else {
          return unitsBuild(context, GetAllUnitsCubit.get(context).units);
        }
      },
    );
  }
}
