import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/widget/custom_pop_up.dart';
import 'package:pos_app/features/selling_point/manager/selling_point_product_cubit/selling_point_product_cubit.dart';
import 'package:pos_app/features/selling_point/view/widget/custom_item_drawer_card.dart';
import 'package:pos_app/generated/l10n.dart';

class CustomBodyOfItems extends StatelessWidget {
  const CustomBodyOfItems({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      reverse: true,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return BlocListener<SellingPointProductCubit, SellingPointProductState>(
          listener: (context, state) {
            if (state is SellingPointProductIncreaseCountFailing) {
              CustomPopUp.callMyToast(
                context: context,
                massage: S.of(context).quantityOfProductIsFinished,
                state: PopUpState.ERROR,
              );
            }
          },
          child: CustomItemDrawerCard(
            product: SellingPointProductCubit.get(context).products[index],
            onTapAdd: () => SellingPointProductCubit.get(context).increaseCount(
                SellingPointProductCubit.get(context)
                    .products[index]
                    .product
                    .id!),
            onTapRemove: () => SellingPointProductCubit.get(context)
                .decreaseCount(SellingPointProductCubit.get(context)
                    .products[index]
                    .product
                    .id!),
            onTapDelete: () => SellingPointProductCubit.get(context)
                .removeProduct(SellingPointProductCubit.get(context)
                    .products[index]
                    .product
                    .id!),
          ),
        );
      },
      separatorBuilder: (context, index) => Divider(),
      itemCount: SellingPointProductCubit.get(context).products.length,
    );
  }
}
