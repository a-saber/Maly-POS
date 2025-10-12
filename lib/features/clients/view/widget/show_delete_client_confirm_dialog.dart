import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/core/helper/my_service_locator.dart';
import 'package:pos_app/core/widget/show_delete_confirm_dialog.dart';
import 'package:pos_app/features/clients/data/model/customer_model.dart';
import 'package:pos_app/features/clients/data/repo/clients_repo.dart';
import 'package:pos_app/features/clients/manager/delete_client/delete_client_cubit.dart';
import 'package:pos_app/features/clients/manager/get_clients/get_clients_cubit.dart';
import 'package:pos_app/generated/l10n.dart';

Future<bool?> showDeleteClientConfirmDialog(
    {required BuildContext context,
    required CustomerModel client,
    bool goBack = false}) async {
  return await showDeleteConfirmationDialog(
      context: context,
      title: S.of(context).deleteClient,
      content: client.name ?? '',
      deleteButtonBuilder: (ctx, button, loading) => BlocProvider(
            create: (context) =>
                DeleteClientCubit(MyServiceLocator.getSingleton<ClientsRepo>()),
            child: BlocConsumer<DeleteClientCubit, DeleteClientState>(
              listener: (context, state) {
                if (state is DeleteClientSuccess) {
                  deleteConfirmationDialogSuccess(ctx);

                  MyServiceLocator.getSingleton<GetClientsCubit>()
                      .deleteClient(state.id);
                  if (goBack) {
                    Navigator.pop(context);
                  }
                } else if (state is DeleteClientFailing) {
                  if (context.mounted) {
                    deleteConfirmationDialogError(
                      ctx,
                      mapStatusCodeToMessage(context, state.errMessage),
                    );
                  }
                }
              },
              builder: (context, state) {
                if (state is DeleteClientLoading) {
                  return loading;
                }
                return button(
                    context: context,
                    onPressed: () =>
                        DeleteClientCubit.get(context).deleteClient(
                          id: client.id ?? -1,
                        ));
              },
            ),
          ));
}
