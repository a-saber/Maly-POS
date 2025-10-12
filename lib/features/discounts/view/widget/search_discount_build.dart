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
import 'package:pos_app/features/discounts/data/model/discount_model.dart';
import 'package:pos_app/features/discounts/manager/search_discount_cubit/search_discount_cubit.dart';

class SearchDiscountBuild extends StatelessWidget {
  const SearchDiscountBuild(
      {super.key, required this.onTap, required this.child, this.name = ""});

  final void Function(DiscountModel) onTap;
  final Widget child;
  final String name;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: MyServiceLocator.getIt<SearchDiscountCubit>()..init(),
      child: Builder(builder: (context) {
        return BlocConsumer<SearchDiscountCubit, SearchDiscountState>(
          builder: (context, state) {
            if (state is SearchDiscountLoading) {
              return const CustomLoading();
            } else if (state is SearchDiscountFailing) {
              CustomError(
                error: context.mounted
                    ? mapStatusCodeToMessage(context, state.errMessage)
                    : "error",
                onPressed: () =>
                    SearchDiscountCubit.get(context).getPagination(),
              );
            } else if (state is SearchDiscountSuccess) {
              if (SearchDiscountCubit.get(context).discounts.isEmpty) {
                return CustomEmptyView(
                  onPressed: () =>
                      SearchDiscountCubit.get(context).getDiscounts(),
                );
              } else {
                return ListView.builder(
                  controller: SearchDiscountCubit.get(context).scrollController,
                  itemCount: SearchDiscountCubit.get(context).canLoading()
                      ? SearchDiscountCubit.get(context).discounts.length + 1
                      : SearchDiscountCubit.get(context).discounts.length,
                  itemBuilder: (context, index) {
                    if (SearchDiscountCubit.get(context).canLoading() &&
                        index ==
                            SearchDiscountCubit.get(context).discounts.length) {
                      return CustomLoading();
                    }
                    return TextButton(
                      onPressed: () {
                        onTap(
                            SearchDiscountCubit.get(context).discounts[index]);
                      },
                      child: Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: TextHighlight(
                          text: SearchDiscountCubit.get(context)
                                  .discounts[index]
                                  .title ??
                              '',
                          words: {
                            SearchDiscountCubit.get(context).query:
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
                              // decoration: BoxDecoration(color: AppColors.success),
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
            if (state is SearchDiscountFailingPagination) {
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
