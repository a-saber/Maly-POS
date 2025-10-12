import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/core/widget/custom_empty_view.dart';
import 'package:pos_app/core/widget/custom_error_view.dart';
import 'package:pos_app/core/widget/custom_pop_up.dart';
import 'package:pos_app/features/sales/data/model/sales_model.dart';
import 'package:pos_app/features/sales/manager/get_sales_cubit/get_sales_cubit.dart';

class CubitSalesBuild extends StatelessWidget {
  const CubitSalesBuild(
      {super.key, required this.salesLoading, required this.salesBuild});
  final Function(BuildContext) salesLoading;
  final Function(BuildContext, List<SalesModel>) salesBuild;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GetSalesCubit, GetSalesState>(
      builder: (context, state) {
        if (state is GetSalesFailing) {
          return CustomError(
            error: context.mounted
                ? mapStatusCodeToMessage(context, state.errMessage)
                : 'error',
            onPressed: () => GetSalesCubit.get(context).getSales(),
          );
        } else if (state is GetSalesLoading) {
          return salesLoading(context);
        }
        if (GetSalesCubit.get(context).sales.isEmpty) {
          return CustomEmptyView(
            onPressed: () => GetSalesCubit.get(context).getSales(),
          );
        }
        return salesBuild(
          context,
          GetSalesCubit.get(context).sales,
        );
      },
      listener: (context, state) {
        if (state is GetSalesPaginationFailing) {
          if (context.mounted) {
            CustomPopUp.callMyToast(
              context: context,
              massage: mapStatusCodeToMessage(context, state.errMessage),
              state: PopUpState.ERROR,
            );
          }
        }
      },
    );
  }
}
