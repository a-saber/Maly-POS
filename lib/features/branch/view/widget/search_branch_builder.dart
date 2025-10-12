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
import 'package:pos_app/features/auth/login/data/model/branche_model.dart';
import 'package:pos_app/features/branch/manager/search_branch_cubit/search_branch_cubit.dart';

class SearchBranchBuilder extends StatelessWidget {
  const SearchBranchBuilder(
      {super.key, required this.onTap, required this.child, this.name = ''});
  final Function(BrancheModel) onTap;
  final Widget child;
  final String name;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: MyServiceLocator.getIt<SearchBranchCubit>()..init(),
      child: BlocConsumer<SearchBranchCubit, SearchBranchState>(
        listener: (context, state) {
          if (state is SearchBranchPaginationFailing) {
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
          if (state is SearchBranchFailing) {
            return CustomError(
                error: context.mounted
                    ? mapStatusCodeToMessage(context, state.errMessage)
                    : 'error',
                onPressed: () {
                  SearchBranchCubit.get(context).init();
                });
          } else if (state is SearchBranchLoading) {
            return const CustomLoading();
          } else if (state is SearchBranchSuccess) {
            if (SearchBranchCubit.get(context).searchBranches.isEmpty) {
              return CustomEmptyView(
                onPressed: () => SearchBranchCubit.get(context).searchBranch(
                  SearchBranchCubit.get(context).query,
                ),
              );
            }
            return ListView.builder(
              controller: SearchBranchCubit.get(context).scrollController,
              itemCount: SearchBranchCubit.get(context).canLoading()
                  ? SearchBranchCubit.get(context).searchBranches.length + 1
                  : SearchBranchCubit.get(context).searchBranches.length,
              itemBuilder: (context, index) {
                if (SearchBranchCubit.get(context).canLoading() &&
                    index ==
                        SearchBranchCubit.get(context).searchBranches.length) {
                  return const CustomLoading();
                }
                return TextButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  onPressed: () {
                    onTap(SearchBranchCubit.get(context).searchBranches[index]);
                  },
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: TextHighlight(
                      text: SearchBranchCubit.get(context)
                              .searchBranches[index]
                              .name ??
                          '',
                      words: {
                        SearchBranchCubit.get(context).query: HighlightedWord(
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
      ),
    );
  }
}
