import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/constant/constant.dart';
import 'package:pos_app/core/router/app_route.dart';
import 'package:pos_app/core/utils/app_padding.dart';
import 'package:pos_app/core/widget/custom_app_bar.dart';
import 'package:pos_app/core/widget/custom_floating_action_btn.dart';
import 'package:pos_app/core/widget/custom_grid_view_card.dart';
import 'package:pos_app/core/widget/custom_refresh_indicator.dart';
import 'package:pos_app/features/products/manager/get_all_products_cubit/get_all_products_cubit.dart';
import 'package:pos_app/features/products/view/widget/custom_drop_down_product.dart';
import 'package:pos_app/features/products/view/widget/product_cubit_build.dart';
import 'package:pos_app/features/products/view/widget/product_item_builder.dart';
import 'package:pos_app/generated/l10n.dart';

import '../../../core/helper/is_mobile.dart';
import '../../../core/widget/custom_form_field.dart';
import '../../categories/view/widget/custom_drop_down_category.dart';


class ProductsView extends StatefulWidget {
  const ProductsView({super.key});

  @override
  State<ProductsView> createState() => _ProductsViewState();
}


class _ProductsViewState extends State<ProductsView> {
  @override
  void initState() {
   Future.delayed(Duration.zero, () {
      GetAllProductsCubit.get(context).getSearchUnit(context);
    });
    super.initState();
  }
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
          child: BlocConsumer<GetAllProductsCubit,GetAllProductsState>(
            listener: (context,state){},
         builder: (context,state){
           return Column(
             children: [
               Flex(
                 direction: isMobile(context: context) ? Axis.vertical : Axis.horizontal,
                 spacing: 20,
                 mainAxisSize: MainAxisSize.min,
                 children: [
                   Flexible(
                     flex: 1,
                     // fit: isMobile(context: context) ? FlexFit.loose : FlexFit.tight,
                     child:  CustomFormField(
                         suffixIcon: Icon(Icons.search),
                         controller:GetAllProductsCubit.get(context).searchController,
                         labelText: S.of(context).search,
                         onChanged: GetAllProductsCubit.get(context).onSearchChanged,
                       prefixIcon:  GetAllProductsCubit.get(context).searchController.text.isNotEmpty?
                       IconButton(onPressed: GetAllProductsCubit.get(context).clearSearch
                           , icon: Icon(CupertinoIcons.xmark)):null

                     ),
                   ),
                   Flexible(
                     flex: 1,

                     //   fit: isMobile(context: context) ? FlexFit.loose : FlexFit.tight,
                     child:  Stack(
                       children: [
                         CustomDropDownCategory(
                           value: GetAllProductsCubit.get(context).category,
                           onChangedCategory: (category) => GetAllProductsCubit.get(context).onChangeCategory(category),
                           onClear:  GetAllProductsCubit.get(context).clearCategory,
                         ),

                       ],
                     ),
                   ),
                 ],
               ),



               const SizedBox(
                 height: 10,
               ),
               Expanded(
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
             ],
           );
         },
          ),
        ),
      ),
    );
  }
}
