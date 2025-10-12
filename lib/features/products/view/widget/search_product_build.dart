import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/core/helper/my_service_locator.dart';
import 'package:pos_app/core/utils/app_colors.dart';
import 'package:pos_app/core/utils/app_font_style.dart';
import 'package:pos_app/core/widget/custom_empty_view.dart';
import 'package:pos_app/core/widget/custom_error_view.dart';
import 'package:pos_app/core/widget/custom_loading.dart';
import 'package:pos_app/core/widget/custom_pop_up.dart';
import 'package:pos_app/features/products/data/model/product_model.dart';
import 'package:pos_app/features/products/manager/search_product_cubit/search_product_cubit.dart';

class SearchProductBuild extends StatelessWidget {
  const SearchProductBuild(
      {super.key,
      required this.onTap,
      required this.child,
      required this.name});

  final void Function(ProductModel) onTap;
  final Widget child;
  final String name;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: MyServiceLocator.getIt<SearchProductCubit>()..init(),
      child: Builder(builder: (context) {
        return BlocConsumer<SearchProductCubit, SearchProductState>(
          builder: (context, state) {
            if (state is SearchProductLoading) {
              return const CustomLoading();
            } else if (state is SearchProductFailing) {
              CustomError(
                error: context.mounted
                    ? mapStatusCodeToMessage(context, state.errMessage)
                    : 'error',
                onPressed: () =>
                    SearchProductCubit.get(context).getSearchProducts(),
              );
            } else if (state is SearchProductSuccess) {
              if (SearchProductCubit.get(context).products.isEmpty) {
                return CustomEmptyView(
                  onPressed: () =>
                      SearchProductCubit.get(context).getSearchProducts(),
                );
              } else {
                return ListView.builder(
                  controller: SearchProductCubit.get(context).scrollController,
                  itemCount: SearchProductCubit.get(context).canLoading()
                      ? SearchProductCubit.get(context).products.length + 1
                      : SearchProductCubit.get(context).products.length,
                  itemBuilder: (context, index) {
                    if (SearchProductCubit.get(context).canLoading() &&
                        index ==
                            SearchProductCubit.get(context).products.length) {
                      return CustomLoading();
                    }
                    return TextButton(
                      onPressed: () {
                        onTap(SearchProductCubit.get(context).products[index]);
                      },
                      child: Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: TextHighlight(
                          text: SearchProductCubit.get(context)
                                  .products[index]
                                  .name ??
                              '',
                          words: {
                            SearchProductCubit.get(context).query:
                                HighlightedWord(
                              textStyle:
                                  AppFontStyle.formText(context: context),
                              decoration:
                                  BoxDecoration(color: AppColors.yellow),
                            ),
                            name: HighlightedWord(
                              textStyle: AppFontStyle.formText(
                                context: context,
                                color: AppColors.success,
                              ),
                            ),
                          }, // Your dictionary words
                          textStyle: AppFontStyle.formText(context: context),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                        ),
                      ),
                    );
                  },
                );
              }
            }
            return child;
          },
          listener: (context, state) {
            if (state is SearchProductFailingPagination) {
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
      }),
    );
  }
}
