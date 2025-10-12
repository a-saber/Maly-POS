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
import 'package:pos_app/features/units/data/model/unit_model.dart';
import 'package:pos_app/features/units/manager/search_unit_cubit/search_unit_cubit.dart';

class SearchUnitBuild extends StatelessWidget {
  const SearchUnitBuild(
      {super.key, required this.onTap, required this.child, this.name = ''});
  final Function(UnitModel) onTap;
  final Widget child;
  final String name;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: MyServiceLocator.getIt<SearchUnitCubit>()..init(),
      child: Builder(builder: (context) {
        return BlocConsumer<SearchUnitCubit, SearchUnitState>(
          builder: (context, state) {
            if (state is SearchUnitLoading) {
              return CustomLoading();
            } else if (state is SearchUnitFailing) {
              return CustomError(
                error: context.mounted
                    ? mapStatusCodeToMessage(context, state.errMessage)
                    : 'error',
                onPressed: () =>
                    SearchUnitCubit.get(context).getSearchUnits(search: ''),
              );
            } else if (state is SearchUnitSuccess) {
              return ListView.builder(
                controller: SearchUnitCubit.get(context).scrollController,
                itemCount: SearchUnitCubit.get(context).canLoading()
                    ? SearchUnitCubit.get(context).units.length + 1
                    : SearchUnitCubit.get(context).units.length,
                itemBuilder: (context, index) {
                  if (SearchUnitCubit.get(context).canLoading() &&
                      index == SearchUnitCubit.get(context).units.length) {
                    return CustomLoading();
                  }
                  return TextButton(
                    onPressed: () {
                      onTap(SearchUnitCubit.get(context).units[index]);
                    },
                    child: Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: TextHighlight(
                        text: SearchUnitCubit.get(context).units[index].name ??
                            '',
                        words: {
                          SearchUnitCubit.get(context).query: HighlightedWord(
                            textStyle: AppFontStyle.formText(context: context),
                            decoration: BoxDecoration(color: AppColors.yellow),
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
            return child;
          },
          listener: (context, state) {
            if (state is SearchUnitPaginationFailing) {
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
