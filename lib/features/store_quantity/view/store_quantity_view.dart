import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/core/constant/constant.dart';
import 'package:pos_app/core/utils/app_font_style.dart';
import 'package:pos_app/core/utils/app_padding.dart';
import 'package:pos_app/core/widget/custom_app_bar.dart';
import 'package:pos_app/core/widget/custom_empty_view.dart';
import 'package:pos_app/core/widget/custom_error_view.dart';
import 'package:pos_app/core/widget/custom_form_field.dart';
import 'package:pos_app/core/widget/custom_grid_view_card.dart';
import 'package:pos_app/core/widget/custom_pop_up.dart';
import 'package:pos_app/core/widget/custom_refresh_indicator.dart';
import 'package:pos_app/features/store_quantity/manager/filter_store_quantity_cubit/filter_store_quantity_cubit.dart';
import 'package:pos_app/features/store_quantity/manager/store_quantity_cubit/store_quantity_cubit.dart';
import 'package:pos_app/features/store_quantity/view/widget/custom_branch_and_product_filter.dart';
import 'package:pos_app/features/store_quantity/view/widget/product_item_search_build.dart';
import 'package:pos_app/generated/l10n.dart';

class StoreQuantityView extends StatefulWidget {
  const StoreQuantityView({super.key});

  @override
  State<StoreQuantityView> createState() => _StoreQuantityViewState();
}

class _StoreQuantityViewState extends State<StoreQuantityView> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  late StoreQuantityCubit cubit;

  @override
  void didChangeDependencies() {
    cubit = StoreQuantityCubit.get(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    cubit.reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FilterStoreQuantityCubit(),
      child: Scaffold(
        // key: scaffoldKey,
        appBar: CustomAppBar(
          leading: BackButton(),
          title: S.of(context).storeQuantity,
          // actions: [
          //   IconButton(
          //     onPressed: () {
          //       scaffoldKey.currentState?.openDrawer();
          //     },
          //     icon: Icon(
          //       Icons.tune_outlined,
          //     ),
          //   )
          // ],
        ),
        // drawer: CustomFilterStoreQuantityDrawer(),
        body: CustomRefreshIndicator(
          onRefresh: () async {
            StoreQuantityCubit.get(context).getProducts();
          },
          child: Padding(
            padding: AppPaddings.defaultView,
            child: Column(
              children: [
                CustomFormField(
                  controller: TextEditingController(
                    text: StoreQuantityCubit.get(context).query,
                  ),
                  onChanged: (value) =>
                      StoreQuantityCubit.get(context).onSearchChanged(
                    value,
                  ),
                  suffixIcon: Icon(Icons.search),
                  hintText: S.of(context).search,
                ),
                SizedBox(
                  height: 10,
                ),
                CustomBranchAndProductFilter(),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: BlocConsumer<StoreQuantityCubit, StoreQuantityState>(
                    listener: (context, state) {
                      if (state is StoreQunatityPaginationFailing) {
                        if (context.mounted) {
                          CustomPopUp.callMyToast(
                            context: context,
                            massage: mapStatusCodeToMessage(
                                context, state.errMessage),
                            state: PopUpState.ERROR,
                          );
                        }
                      }
                    },
                    builder: (context, state) {
                      if (state is StoreQunatityFailing) {
                        return CustomError(
                          error: context.mounted
                              ? mapStatusCodeToMessage(
                                  context, state.errMessage)
                              : "error",
                          onPressed: () {
                            StoreQuantityCubit.get(context).getProducts();
                          },
                        );
                      } else if (state is StoreQunatityLoading) {
                        return CustomGridViewCard(
                          widthOfCard: 450,
                          heightOfCard: getResponsiveSize(context, size: 140),
                          itemBuilder: (p0, p1) {
                            return ProductItemSearchLoading();
                          },
                          itemCount: AppConstant.numberOfCardLoading,
                        );
                      }
                      if (StoreQuantityCubit.get(context).products.isEmpty) {
                        return CustomEmptyView(onPressed: () {
                          log("getProducts");
                          StoreQuantityCubit.get(context).getProducts();
                        });
                      }

                      return CustomGridViewCard(
                        widthOfCard: 450,
                        controller:
                            StoreQuantityCubit.get(context).scrollController,
                        canLaoding:
                            StoreQuantityCubit.get(context).canLoading(),
                        heightOfCard: getResponsiveSize(context, size: 140),
                        itemBuilder: (context, index) {
                          return ProductItemSearchBuild(
                              storeQuantityProductModel:
                                  StoreQuantityCubit.get(context)
                                      .products[index]);
                        },
                        itemCount:
                            StoreQuantityCubit.get(context).products.length,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
