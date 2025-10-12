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
import 'package:pos_app/features/auth/login/data/model/role_model.dart';
import 'package:pos_app/features/permissions/manager/search_permission/search_permission_cubit.dart';

class SearchPermissionBuild extends StatelessWidget {
  const SearchPermissionBuild(
      {super.key, required this.child, required this.onTap, this.name = ''});
  final Widget child;
  final Function(RoleModel) onTap;
  final String name;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: MyServiceLocator.getSingleton<SearchPermissionCubit>()..init(),
      child: Builder(builder: (context) {
        return BlocConsumer<SearchPermissionCubit, SearchPermissionState>(
          listener: (context, state) {
            if (state is SearchPermissionPaginationFailing) {
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
            if (state is SearchPermissionLoading) {
              return const CustomLoading();
            } else if (state is SearchPermissionSuccess) {
              if (SearchPermissionCubit.get(context).roleSearch.isEmpty) {
                return CustomEmptyView(
                    onPressed: () =>
                        SearchPermissionCubit.get(context).searchPermission(
                          SearchPermissionCubit.get(context).query,
                        ));
              }
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  controller:
                      SearchPermissionCubit.get(context).scrollController,
                  itemCount: SearchPermissionCubit.get(context).canLoading()
                      ? SearchPermissionCubit.get(context).roleSearch.length + 1
                      : SearchPermissionCubit.get(context).roleSearch.length,
                  itemBuilder: (context, index) {
                    if (SearchPermissionCubit.get(context).canLoading() &&
                        index ==
                            SearchPermissionCubit.get(context)
                                .roleSearch
                                .length) {
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
                        onTap(SearchPermissionCubit.get(context)
                            .roleSearch[index]);
                      },
                      child: Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: TextHighlight(
                          text: SearchPermissionCubit.get(context)
                                  .roleSearch[index]
                                  .name ??
                              '',
                          words: {
                            SearchPermissionCubit.get(context).query:
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
                ),
              );
            } else if (state is SearchPermissionFailing) {
              return CustomError(
                error: context.mounted
                    ? mapStatusCodeToMessage(context, state.errMessage)
                    : "error",
                onPressed: () =>
                    SearchPermissionCubit.get(context).searchPermission(
                  SearchPermissionCubit.get(context).query,
                ),
              );
            }
            return child;
          },
        );
      }),
    );
  }
}
