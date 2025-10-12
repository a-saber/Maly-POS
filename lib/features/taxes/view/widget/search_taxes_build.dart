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
import 'package:pos_app/features/taxes/data/model/taxes_model.dart';
import 'package:pos_app/features/taxes/manager/search_taxes/search_taxes_cubit.dart';

class SearchTaxesBuild extends StatelessWidget {
  const SearchTaxesBuild(
      {super.key,
      required this.onTap,
      required this.child,
      required this.name});
  final void Function(TaxesModel) onTap;
  final Widget child;
  final String name;
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: MyServiceLocator.getIt<SearchTaxesCubit>()..init(),
      child: Builder(builder: (context) {
        return BlocConsumer<SearchTaxesCubit, SearchTaxesState>(
          builder: (context, state) {
            if (state is SearchTaxesLoading) {
              return CustomLoading();
            } else if (state is SearchTaxesFailing) {
              return CustomError(
                  error: context.mounted
                      ? mapStatusCodeToMessage(context, state.errMessage)
                      : 'error',
                  onPressed: () =>
                      SearchTaxesCubit.get(context).getSearchTaxes());
            }
            if (state is SearchTaxesSuccess) {
              if (SearchTaxesCubit.get(context).searchTaxes.isEmpty) {
                return CustomEmptyView(
                    onPressed: () =>
                        SearchTaxesCubit.get(context).getSearchTaxes());
              } else {
                return ListView.builder(
                  controller: SearchTaxesCubit.get(context).scrollController,
                  itemCount: SearchTaxesCubit.get(context).canLoading()
                      ? SearchTaxesCubit.get(context).searchTaxes.length + 1
                      : SearchTaxesCubit.get(context).searchTaxes.length,
                  itemBuilder: (context, index) {
                    if (SearchTaxesCubit.get(context).canLoading() &&
                        index ==
                            SearchTaxesCubit.get(context).searchTaxes.length) {
                      return CustomLoading();
                    }
                    return TextButton(
                      onPressed: () {
                        onTap(SearchTaxesCubit.get(context).searchTaxes[index]);
                      },
                      child: Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: TextHighlight(
                          text: SearchTaxesCubit.get(context)
                                  .searchTaxes[index]
                                  .title ??
                              '',
                          words: {
                            SearchTaxesCubit.get(context).query:
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
                  },
                );
              }
            }
            return child;
          },
          listener: (context, state) {
            if (context.mounted) {
              if (state is SearchTaxesPaginationFailing) {
                CustomPopUp.callMyPopUp(
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
