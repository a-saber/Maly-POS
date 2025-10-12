import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/core/constant/constant.dart';
import 'package:pos_app/core/router/app_route.dart';
import 'package:pos_app/core/utils/app_padding.dart';
import 'package:pos_app/core/widget/custom_app_bar.dart';
import 'package:pos_app/core/widget/custom_empty_view.dart';
import 'package:pos_app/core/widget/custom_error_view.dart';
import 'package:pos_app/core/widget/custom_floating_action_btn.dart';
import 'package:pos_app/core/widget/custom_grid_view_card.dart';
import 'package:pos_app/core/widget/custom_pop_up.dart';
import 'package:pos_app/core/widget/custom_refresh_indicator.dart';
import 'package:pos_app/features/clients/manager/get_clients/get_clients_cubit.dart';
import 'package:pos_app/features/clients/view/widget/client_item_builder.dart';
import 'package:pos_app/generated/l10n.dart';

class ClientsView extends StatelessWidget {
  const ClientsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: CustomFloatingActionBtn(onPressed: () {
        Navigator.pushNamed(context, AppRoutes.addClient);
      }),
      appBar: CustomAppBar(title: S.of(context).clients),
      body: CustomRefreshIndicator(
        onRefresh: () =>
            GetClientsCubit.get(context).getClients(isRefresh: true),
        child: Padding(
          padding: AppPaddings.defaultView,
          child: BlocConsumer<GetClientsCubit, GetClientsState>(
            listener: (context, state) {
              if (state is GetClientsPaginationFailing) {
                if (context.mounted) {
                  CustomPopUp.callMyToast(
                      context: context,
                      massage:
                          mapStatusCodeToMessage(context, state.errMessage),
                      state: PopUpState.ERROR);
                }
              }
            },
            builder: (context, state) {
              return BlocBuilder<GetClientsCubit, GetClientsState>(
                builder: (context, state) {
                  if (state is GetClientsFailing) {
                    return CustomError(
                        error: context.mounted
                            ? mapStatusCodeToMessage(context, state.errMessage)
                            : 'error',
                        onPressed: () =>
                            GetClientsCubit.get(context).getClients(
                              isRefresh: true,
                            ));
                  } else if (state is GetClientsLoading) {
                    return CustomGridViewCard(
                      heightOfCard:
                          MediaQuery.of(context).textScaler.scale(110),
                      itemBuilder: (context, index) {
                        return ClientItemLoading();
                      },
                      itemCount: AppConstant.numberOfCardLoading,
                    );
                  }

                  if (GetClientsCubit.get(context).clients.isEmpty) {
                    return CustomEmptyView(
                        onPressed: () => GetClientsCubit.get(context)
                            .getClients(isRefresh: true));
                  } else {
                    return CustomGridViewCard(
                      controller: GetClientsCubit.get(context).scrollController,
                      canLaoding: GetClientsCubit.get(context).canLoading(),
                      heightOfCard:
                          MediaQuery.of(context).textScaler.scale(110),
                      itemBuilder: (context, index) {
                        return ClientItemBuilder(
                            client:
                                GetClientsCubit.get(context).clients[index]);
                      },
                      itemCount: GetClientsCubit.get(context).clients.length,
                    );
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
