import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/core/widget/custom_empty_view.dart';
import 'package:pos_app/core/widget/custom_error_view.dart';
import 'package:pos_app/core/widget/custom_pop_up.dart';
import 'package:pos_app/features/sales_returns/data/model/sales_return_model.dart';
import 'package:pos_app/features/sales_returns/manager/get_sales_return_cubit/get_sales_return_cubit.dart';

class CubitSalesReturnBuild extends StatelessWidget {
  const CubitSalesReturnBuild(
      {super.key,
      required this.salesReturnLoading,
      required this.salesReturnBuild});
  final Function(BuildContext context) salesReturnLoading;
  final Function(BuildContext context, List<SalesReturnModel> sales)
      salesReturnBuild;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GetSalesReturnCubit, GetSalesReturnState>(
      builder: (context, state) {
        if (state is GetSalesReturnLoading) {
          return salesReturnLoading(context);
        } else if (state is GetSalesReturnFailing) {
          return CustomError(
            error: context.mounted
                ? mapStatusCodeToMessage(context, state.errMessage)
                : "error",
            onPressed: () => GetSalesReturnCubit.get(context).getSalesReturn(),
          );
        }
        if (GetSalesReturnCubit.get(context).salesReturn.isEmpty) {
          return CustomEmptyView(
            onPressed: () => GetSalesReturnCubit.get(context).getSalesReturn(),
          );
        }

        return salesReturnBuild(
          context,
          GetSalesReturnCubit.get(context).salesReturn,
        );
      },
      listener: (context, state) {
        if (state is GetSalesReturnPaginationFailing) {
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
