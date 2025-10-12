import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/core/helper/my_service_locator.dart';
import 'package:pos_app/core/utils/app_colors.dart';
import 'package:pos_app/core/utils/app_font_style.dart';
import 'package:pos_app/core/widget/custom_error_view.dart';
import 'package:pos_app/core/widget/custom_loading.dart';
import 'package:pos_app/core/widget/custom_pop_up.dart';
import 'package:pos_app/features/categories/data/model/category_model.dart';
import 'package:pos_app/features/categories/manager/search_category/search_category_cubit.dart';

class SearchCategoryBuild extends StatelessWidget {
  const SearchCategoryBuild(
      {super.key, required this.onTap, required this.child, this.name = ''});
  final Function(CategoryModel) onTap;
  final Widget child;
  final String name;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: MyServiceLocator.getIt<SearchCategoryCubit>()..init(),
      child: Builder(builder: (context) {
        return BlocConsumer<SearchCategoryCubit, SearchCategoryState>(
          listener: (context, state) {
            if (state is SearchCategoryPaginationFailing) {
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
            if (state is SearchCategoryLoading) {
              return CustomLoading();
            } else if (state is SearchCategoryFailing) {
              return CustomError(
                error: context.mounted
                    ? mapStatusCodeToMessage(context, state.errMessage)
                    : 'error',
                onPressed: () =>
                    SearchCategoryCubit.get(context).getSearchCategories(
                  search: SearchCategoryCubit.get(context).query,
                ),
              );
            } else if (state is SearchCategorySuccess) {
              return ListView.builder(
                  controller: SearchCategoryCubit.get(context).scrollController,
                  itemCount: SearchCategoryCubit.get(context).canLoading()
                      ? SearchCategoryCubit.get(context).categories.length + 1
                      : SearchCategoryCubit.get(context).categories.length,
                  itemBuilder: (context, index) {
                    if (SearchCategoryCubit.get(context).canLoading() &&
                        index ==
                            SearchCategoryCubit.get(context)
                                .categories
                                .length) {
                      return CustomLoading();
                    }
                    return TextButton(
                      onPressed: () {
                        onTap(
                            SearchCategoryCubit.get(context).categories[index]);
                      },
                      child: Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: TextHighlight(
                          text: SearchCategoryCubit.get(context)
                                  .categories[index]
                                  .name ??
                              '',
                          words: {
                            SearchCategoryCubit.get(context).query:
                                HighlightedWord(
                              textStyle:
                                  AppFontStyle.formText(context: context),
                              decoration:
                                  BoxDecoration(color: AppColors.yellow),
                            ),
                            name: HighlightedWord(
                              textStyle: AppFontStyle.formText(
                                  context: context, color: AppColors.success),
                            ),
                          }, // Your dictionary words
                          textStyle: AppFontStyle.formText(context: context),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                        ),
                      ),
                    );
                  });
            }
            return child;
          },
        );
      }),
    );
  }
}
