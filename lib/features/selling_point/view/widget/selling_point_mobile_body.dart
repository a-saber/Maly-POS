import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/core/constant/constant.dart';
import 'package:pos_app/core/helper/is_mobile.dart';
import 'package:pos_app/core/helper/my_service_locator.dart';
import 'package:pos_app/core/utils/app_colors.dart';
import 'package:pos_app/core/utils/app_font_style.dart';
import 'package:pos_app/core/utils/app_padding.dart';
import 'package:pos_app/core/widget/custom_empty_view.dart';
import 'package:pos_app/core/widget/custom_error_view.dart';
import 'package:pos_app/core/widget/custom_form_field.dart';
import 'package:pos_app/core/widget/custom_loading.dart';
import 'package:pos_app/core/widget/custom_pop_up.dart';
import 'package:pos_app/core/widget/custom_refresh_indicator.dart';
import 'package:pos_app/features/categories/data/model/category_model.dart';
import 'package:pos_app/features/categories/manager/get_category/get_category_cubit.dart';
import 'package:pos_app/features/categories/view/widget/category_cubit_builder.dart';
import 'package:pos_app/features/selling_point/manager/selling_point_cubit/selling_point_cubit.dart';
import 'package:pos_app/features/selling_point/view/widget/category_item_build.dart';
import 'package:pos_app/features/selling_point/view/widget/product_item_selling_point_build.dart';
import 'package:pos_app/generated/l10n.dart';

class SellingPointMobileBody extends StatefulWidget {
  const SellingPointMobileBody({super.key});

  @override
  State<SellingPointMobileBody> createState() => _SellingPointMobileBodyState();
}

class _SellingPointMobileBodyState extends State<SellingPointMobileBody> {
  late TextEditingController _searchController;
  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(
      text: SellingPointCubit.get(context).query,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomRefreshIndicator(
      notificationPredicate: (_) =>
          SellingPointCubit.get(context).query.isEmpty,
      onRefresh: () async {
        SellingPointCubit.get(context).getCategoryProduct(
          newData: true,
        );
      },
      child: Padding(
        padding: isMobile(context: context)
            ? AppPaddings.defaultView
            : EdgeInsets.symmetric(
                horizontal: AppPaddingSizes.defaultViewH,
                // vertical: isMobile(context: context)
                //     ? 0.0
                //     : AppPaddingSizes.defaultViewV,
              ),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: CustomFormField(
                        suffixIcon: Icon(Icons.search),
                        controller: _searchController,
                        labelText: S.of(context).search,
                        onChanged: (value) =>
                            SellingPointCubit.get(context).onSearchChanged(
                          value,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        SellingPointCubit.get(context).getCategoryProduct(
                            newData: true, refreshAllData: true);
                      },
                      icon: Icon(
                        Icons.refresh_outlined,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                // SizedBox(
                //   height: 20,
                // ),
                BlocProvider.value(
                  value: MyServiceLocator.getSingleton<GetCategoryCubit>()
                    ..init(),
                  child: SizedBox(
                    height: MediaQuery.of(context).textScaler.scale(80),
                    child: CategoryCubitBuilder(
                      errAndLoadingRow: true,
                      categoriesBuilder: (context, categories) {
                        SellingPointCubit.get(context).getFirstTimeProduct();
                        return ListView.separated(
                          scrollDirection: Axis.horizontal,
                          controller:
                              GetCategoryCubit.get(context).scrollController,
                          itemCount: GetCategoryCubit.get(context).canLoading()
                              ? categories.length + 2
                              : categories.length + 1,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return CategoryItemBuild(
                                category: CategoryModel(
                                    id: -1,
                                    name: "All",
                                    description: null,
                                    imagePath: null,
                                    createdAt: null,
                                    updatedAt: null,
                                    imageUrl: null),
                              );
                            }
                            if (GetCategoryCubit.get(context).canLoading() &&
                                index == categories.length + 1) {
                              return CustomLoading();
                            }
                            return CategoryItemBuild(
                              category: categories[index - 1],
                            );
                          },
                          separatorBuilder: (context, index) => const SizedBox(
                            width: 10,
                          ),
                        );
                      },
                      categoiresLoading: (context) {
                        return ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: AppConstant.numberOfCardLoading,
                          itemBuilder: (context, index) {
                            return CategoryItemBuildLoading(
                              index: index,
                            );
                          },
                          separatorBuilder: (context, index) => const SizedBox(
                            width: 10,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                controller: SellingPointCubit.get(context).scrollController,
                slivers: [
                  BlocConsumer<SellingPointCubit, SellingPointState>(
                    listener: (context, state) {
                      if (state is SellingPointPaginationGetProductFailing) {
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
                    listenWhen: (previous, current) {
                      return current is SellingPointPaginationGetProductFailing;
                    },
                    buildWhen: (previous, current) {
                      return current is SellingPointInitial ||
                          current is SellingPointInitialGetProductSuccess ||
                          current is SellingPointInitialGetProductLoading ||
                          current is SellingPointPaginationGetProductSuccess ||
                          current is SellingPointInitialGetProductFailing;
                    },
                    builder: (context, state) {
                      if (state is SellingPointInitial) {
                        return SliverFillRemaining(
                          hasScrollBody: false,
                          child: Center(
                            child: Text(
                              S.of(context).selectCategory,
                              style: AppFontStyle.appBarTitleSmall(
                                context: context,
                              ),
                            ),
                          ),
                        );
                      } else if (state
                          is SellingPointInitialGetProductFailing) {
                        return SliverToBoxAdapter(
                          child: CustomError(
                            error: context.mounted
                                ? mapStatusCodeToMessage(
                                    context, state.errMessage)
                                : "error",
                            onPressed: () => SellingPointCubit.get(context)
                                .getCategoryProduct(
                              newData: true,
                            ),
                          ),
                        );
                      } else if (state
                          is SellingPointInitialGetProductLoading) {
                        return SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: getResponsiveSize(context,
                                size: 180), // responsive max width
                            mainAxisSpacing: 15,
                            crossAxisSpacing: 15,
                            mainAxisExtent:
                                getResponsiveSize(context, size: 240),
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) => ItemBuildLoading(),
                            childCount: 20,
                          ),
                        );
                      }
                      if (SellingPointCubit.get(context)
                          .getProducts()
                          .isEmpty) {
                        return SliverFillRemaining(
                          child: CustomEmptyView(
                            onPressed: () => SellingPointCubit.get(context)
                                .getCategoryProduct(
                              newData: true,
                            ),
                          ),
                        );
                      } else {
                        return SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: getResponsiveSize(context,
                                size: 180), // responsive max width
                            mainAxisSpacing: 15,
                            crossAxisSpacing: 15,
                            mainAxisExtent:
                                getResponsiveSize(context, size: 240),
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) => ProductItemSellingPointBuild(
                              product: SellingPointCubit.get(context)
                                  .getProducts()[index],
                            ),
                            childCount: SellingPointCubit.get(context)
                                .getProducts()
                                .length,
                          ),
                        );
                      }
                    },
                  ),
                  BlocBuilder<SellingPointCubit, SellingPointState>(
                    builder: (context, state) {
                      return SellingPointCubit.get(context).canLoading()
                          ? SliverToBoxAdapter(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: CustomLoading(),
                              ),
                            )
                          : SliverToBoxAdapter();
                    },
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 50,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
