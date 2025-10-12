import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/core/widget/custom_empty_view.dart';
import 'package:pos_app/core/widget/custom_error_view.dart';
import 'package:pos_app/core/widget/custom_pop_up.dart';
import 'package:pos_app/features/products/data/model/product_model.dart';
import 'package:pos_app/features/products/manager/get_all_products_cubit/get_all_products_cubit.dart';

class ProductCubitBuild extends StatelessWidget {
  const ProductCubitBuild({
    super.key,
    required this.productsBuild,
    required this.productsLoading,
  });
  final Widget Function(BuildContext context, List<ProductModel> products)
      productsBuild;
  final Widget Function(BuildContext context) productsLoading;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GetAllProductsCubit, GetAllProductsState>(
      listener: (context, state) {
        if (state is GetAllProductsPaginationFailing) {
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
        if (state is GetAllProductsFailing) {
          return CustomError(
              error: context.mounted
                  ? mapStatusCodeToMessage(context, state.errMessage)
                  : 'error',
              onPressed: () {
                GetAllProductsCubit.get(context).getProducts();
              });
        } else if (state is GetAllProductsLoading) {
          return productsLoading(context);
        }
        if (GetAllProductsCubit.get(context).products.isEmpty) {
          return CustomEmptyView(
            onPressed: () => GetAllProductsCubit.get(context).getProducts(),
          );
        }
        return productsBuild(
            context, GetAllProductsCubit.get(context).products);
      },
    );
  }
}
