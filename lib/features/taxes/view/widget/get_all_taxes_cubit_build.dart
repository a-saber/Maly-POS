import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/core/widget/custom_empty_view.dart';
import 'package:pos_app/core/widget/custom_error_view.dart';
import 'package:pos_app/core/widget/custom_pop_up.dart';
import 'package:pos_app/features/taxes/data/model/taxes_model.dart';
import 'package:pos_app/features/taxes/manager/get_all_taxes_cubit/get_all_taxes_cubit.dart';

class GetAllTaxesCubitBuild extends StatelessWidget {
  const GetAllTaxesCubitBuild(
      {super.key, required this.taxesLoading, required this.taxesBuild});
  final Widget Function(BuildContext context) taxesLoading;
  final Widget Function(BuildContext context, List<TaxesModel> units)
      taxesBuild;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GetAllTaxesCubit, GetAllTaxesState>(
      listener: (context, state) {
        if (state is GetAllTaxesPaginationFailing) {
          if (context.mounted) {
            CustomPopUp.callMyToast(
              context: context,
              massage: mapStatusCodeToMessage(context, state.errMessage),
              state: PopUpState.ERROR,
            );
          }
        }
      },
      builder: (context, state) {
        if (state is GetAllTaxesFailing) {
          return CustomError(
            error: context.mounted
                ? mapStatusCodeToMessage(context, state.errMessage)
                : 'error',
            onPressed: () => GetAllTaxesCubit.get(context).getTaxes(),
          );
        } else if (state is GetAllTaxesLoading) {
          return taxesLoading(context);
        }
        if (GetAllTaxesCubit.get(context).taxes.isEmpty) {
          return CustomEmptyView(
            onPressed: () => GetAllTaxesCubit.get(context).getTaxes(),
          );
        } else {
          return taxesBuild(context, GetAllTaxesCubit.get(context).taxes);
        }
      },
    );
  }
}
