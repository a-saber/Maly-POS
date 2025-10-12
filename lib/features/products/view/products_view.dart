import 'package:flutter/material.dart';
import 'package:pos_app/core/constant/constant.dart';
import 'package:pos_app/core/router/app_route.dart';
import 'package:pos_app/core/utils/app_padding.dart';
import 'package:pos_app/core/widget/custom_app_bar.dart';
import 'package:pos_app/core/widget/custom_floating_action_btn.dart';
import 'package:pos_app/core/widget/custom_grid_view_card.dart';
import 'package:pos_app/core/widget/custom_refresh_indicator.dart';
import 'package:pos_app/features/products/manager/get_all_products_cubit/get_all_products_cubit.dart';
import 'package:pos_app/features/products/view/widget/product_cubit_build.dart';
import 'package:pos_app/features/products/view/widget/product_item_builder.dart';
import 'package:pos_app/generated/l10n.dart';

class ProductsView extends StatelessWidget {
  const ProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: CustomFloatingActionBtn(onPressed: () {
        Navigator.pushNamed(context, AppRoutes.addProduct);
      }),
      appBar: CustomAppBar(title: S.of(context).products),
      body: CustomRefreshIndicator(
        onRefresh: () {
          return GetAllProductsCubit.get(context).getProducts();
        },
        child: Padding(
          padding: AppPaddings.defaultView,
          child: ProductCubitBuild(
            productsLoading: (context) {
              return CustomGridViewCard(
                heightOfCard: MediaQuery.of(context).textScaler.scale(110),
                itemBuilder: (context, index) {
                  return ProductCardLoading();
                },
                itemCount: AppConstant.numberOfCardLoading,
              );
            },
            productsBuild: (context, products) {
              return CustomGridViewCard(
                controller: GetAllProductsCubit.get(context).scrollController,
                canLaoding: GetAllProductsCubit.get(context).canLoading(),
                heightOfCard: MediaQuery.of(context).textScaler.scale(110),
                itemBuilder: (BuildContext context, int index) {
                  return ProductItemBuilder(product: products[index]);
                },
                itemCount: products.length,
              );
            },
          ),
        ),
      ),
    );
  }
}
