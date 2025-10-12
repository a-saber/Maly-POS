import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/core/widget/custom_empty_view.dart';
import 'package:pos_app/core/widget/custom_error_view.dart';
import 'package:pos_app/core/widget/custom_pop_up.dart';
import 'package:pos_app/features/discounts/data/model/discount_model.dart';
import 'package:pos_app/features/discounts/manager/get_all_discounts_cubit/get_all_discounts_cubit.dart';

class GetAllDiscountCubitBuild extends StatelessWidget {
  const GetAllDiscountCubitBuild(
      {super.key, required this.discountLoading, required this.discountsBuild});
  final Widget Function(BuildContext context) discountLoading;
  final Widget Function(BuildContext context, List<DiscountModel> units)
      discountsBuild;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GetAllDiscountsCubit, GetAllDiscountsState>(
      listener: (context, state) {
        if (state is GetAllDiscountsPaginationFailing) {
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
        if (state is GetAllDiscountsFailing) {
          return CustomError(
            error: context.mounted
                ? mapStatusCodeToMessage(context, state.errMessage)
                : 'error',
            onPressed: () => GetAllDiscountsCubit.get(context).getDiscounts(),
          );
        } else if (state is GetAllDiscountsLoading) {
          return discountLoading(context);
        }
        if (GetAllDiscountsCubit.get(context).discounts.isEmpty) {
          return CustomEmptyView(
            onPressed: () => GetAllDiscountsCubit.get(context).getDiscounts(),
          );
        } else {
          return discountsBuild(
              context, GetAllDiscountsCubit.get(context).discounts);
        }
      },
    );
  }
}
