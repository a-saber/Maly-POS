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
import 'package:pos_app/features/auth/login/data/model/user_model.dart';
import 'package:pos_app/features/users/manager/search_user/search_user_cubit.dart';

class SearchUserBuild extends StatelessWidget {
  const SearchUserBuild(
      {super.key,
      required this.child,
      required this.onTap,
      required this.name});
  final Widget child;
  final String name;
  final Function(UserModel) onTap;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: MyServiceLocator.getIt<SearchUserCubit>()..init(),
      child: Builder(builder: (context) {
        return BlocConsumer<SearchUserCubit, SearchUserState>(
          builder: (context, state) {
            if (state is SearchUserLoading) {
              return const CustomLoading();
            } else if (state is SearchUserFailing) {
              CustomError(
                error: context.mounted
                    ? mapStatusCodeToMessage(context, state.errMessage)
                    : 'error',
                onPressed: () => SearchUserCubit.get(context).getUsers(),
              );
            } else if (state is SearchUserSuccess) {
              if (SearchUserCubit.get(context).users.isEmpty) {
                return CustomEmptyView(
                  onPressed: () => SearchUserCubit.get(context).getUsers(),
                );
              } else {
                return ListView.builder(
                  controller: SearchUserCubit.get(context).scrollController,
                  itemCount: SearchUserCubit.get(context).canLoading()
                      ? SearchUserCubit.get(context).users.length + 1
                      : SearchUserCubit.get(context).users.length,
                  itemBuilder: (context, index) {
                    if (SearchUserCubit.get(context).canLoading() &&
                        index == SearchUserCubit.get(context).users.length) {
                      return CustomLoading();
                    }
                    return TextButton(
                      onPressed: () {
                        onTap(SearchUserCubit.get(context).users[index]);
                      },
                      child: Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: TextHighlight(
                          text:
                              SearchUserCubit.get(context).users[index].name ??
                                  '',
                          words: {
                            SearchUserCubit.get(context).query: HighlightedWord(
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
            if (state is SearchUserPaginationFailing) {
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
