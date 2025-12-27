import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/widget/custom_pop_up.dart';
import 'package:pos_app/features/selling_point/manager/selling_point_product_cubit/selling_point_product_cubit.dart';
import 'package:pos_app/features/selling_point/view/widget/custom_item_drawer_card.dart';
import 'package:pos_app/features/selling_point/view/widget/productquantity.dart';
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
        final cubit = SellingPointProductCubit.get(context);
        final product = cubit.products[index]; 
        final productId = product.product.id!;
        final productUnitId = product.productUnit?.unitId;
        
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
            product: product,
            onTapAdd: () => cubit.increaseCount(
                productId: productId, productUnitId: productUnitId, index: index),
            onTapRemove: () => cubit.decreaseCount(
                productId: productId, productUnitId: productUnitId, index: index),
            onTapDelete: () => cubit.removeProduct(
                productId: productId, productUnitId: productUnitId, index: index),
            onChangePrice: () => cubit.changePrice(
                productId: productId, productUnitId: productUnitId),
            onToggleShowEditPrice: () => cubit.toggleShowEditPrice(
                productId: productId, productUnitId: productUnitId),
                onChangeQuantity: () => cubit.updateQuantity(
                productId: productId, productUnitId: productUnitId, newQuantity: product.count, index: index),
            onTapQuantity: () {
              showDialog(
                context: context,
                builder: (dialogContext) => ProductQuantityDialog(
                  currentQuantity: product.count, // Use product.count instead of productItem.count
                  onQuantityChanged: (newQuantity) {
                    cubit.updateQuantity(
                      productId: productId,
                      productUnitId: productUnitId,
                      newQuantity: newQuantity,
                      index: index
                    );
                  },
                ),
              );
            },
          ),
        );
      },
      separatorBuilder: (context, index) => Divider(),
      itemCount: SellingPointProductCubit.get(context).products.length,
    );
  }
}