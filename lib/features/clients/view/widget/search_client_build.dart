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
import 'package:pos_app/features/clients/data/model/customer_model.dart';
import 'package:pos_app/features/clients/manager/search_client/search_client_cubit.dart';

class SearchClientBuild extends StatelessWidget {
  const SearchClientBuild(
      {super.key, required this.onTap, required this.child, this.name = ''});

  final void Function(CustomerModel) onTap;
  final Widget child;
  final String name;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: MyServiceLocator.getIt<SearchClientCubit>()..init(),
      child: Builder(builder: (context) {
        return BlocConsumer<SearchClientCubit, SearchClientState>(
          builder: (context, state) {
            if (state is SearchClientLoading) {
              return const CustomLoading();
            } else if (state is SearchClientFailing) {
              CustomError(
                error: context.mounted
                    ? mapStatusCodeToMessage(context, state.errMessage)
                    : 'error',
                onPressed: () =>
                    SearchClientCubit.get(context).getSearchCustomer(),
              );
            } else if (state is SearchClientSuccess) {
              if (SearchClientCubit.get(context).clients.isEmpty) {
                return CustomEmptyView(
                  onPressed: () =>
                      SearchClientCubit.get(context).getSearchCustomer(),
                );
              } else {
                return ListView.builder(
                  controller: SearchClientCubit.get(context).scrollController,
                  itemCount: SearchClientCubit.get(context).canLoading()
                      ? SearchClientCubit.get(context).clients.length + 1
                      : SearchClientCubit.get(context).clients.length,
                  itemBuilder: (context, index) {
                    if (SearchClientCubit.get(context).canLoading() &&
                        index ==
                            SearchClientCubit.get(context).clients.length) {
                      return CustomLoading();
                    }
                    return TextButton(
                      onPressed: () {
                        onTap(SearchClientCubit.get(context).clients[index]);
                      },
                      child: Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: TextHighlight(
                          text: SearchClientCubit.get(context)
                                  .clients[index]
                                  .name ??
                              '',
                          words: {
                            SearchClientCubit.get(context).query:
                                HighlightedWord(
                              textStyle:
                                  AppFontStyle.formText(context: context),
                              decoration:
                                  BoxDecoration(color: AppColors.yellow),
                            ),
                            name: HighlightedWord(
                              textStyle: AppFontStyle.formText(
                                  context: context, color: AppColors.success),
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
            if (state is SearchClientFailingPagination) {
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
