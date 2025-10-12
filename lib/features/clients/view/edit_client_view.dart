import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/core/constant/constant.dart';
import 'package:pos_app/core/helper/my_service_locator.dart';
import 'package:pos_app/core/widget/custom_app_bar.dart';
import 'package:pos_app/core/widget/custom_btn.dart';
import 'package:pos_app/core/widget/custom_pop_up.dart';
import 'package:pos_app/core/widget/cutsom_layout_builder.dart';
import 'package:pos_app/core/widget/my_custom_scroll_view.dart';
import 'package:pos_app/features/clients/data/model/customer_model.dart';
import 'package:pos_app/features/clients/data/repo/clients_repo.dart';
import 'package:pos_app/features/clients/manager/edit_client/edit_client_cubit.dart';
import 'package:pos_app/features/clients/manager/get_clients/get_clients_cubit.dart';
import 'package:pos_app/features/clients/view/widget/client_data_build.dart';
import 'package:pos_app/features/clients/view/widget/show_delete_client_confirm_dialog.dart';
import 'package:pos_app/generated/l10n.dart';

class EditClientView extends StatelessWidget {
  const EditClientView({super.key, required this.client});
  final CustomerModel client;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          EditClientCubit(MyServiceLocator.getSingleton<ClientsRepo>(), client),
      child: Scaffold(
        appBar: CustomAppBar(
          title: S.of(context).editClient,
          actions: [
            CustomTextBtn(
                text: S.of(context).delete,
                onPressed: () async {
                  await showDeleteClientConfirmDialog(
                      context: context, client: client, goBack: true);
                })
          ],
        ),
        body: BlocConsumer<EditClientCubit, EditClientState>(
          listener: (context, state) {
            if (state is EditClientSuccess) {
              GetClientsCubit.get(context).editClient(state.customer);

              CustomPopUp.callMyToast(
                  context: context,
                  massage: S.of(context).updatedSuccess,
                  state: PopUpState.SUCCESS);
              Navigator.pop(context);
            } else if (state is EditClientFailing) {
              if (context.mounted) {
                CustomPopUp.callMyToast(
                    context: context,
                    massage: mapStatusCodeToMessage(context, state.errMessage),
                    state: PopUpState.ERROR);
              }
            }
          },
          builder: (context, state) {
            return CustomLayoutBuilder(
              mobile: MyCustomScrollView(
                  child: EditClientMobileBody(client: client, state: state)),
              tablet: MyCustomScrollView(
                  child: EditClientTableteDesktopBody(
                      client: client, state: state)),
              desktop: MyCustomScrollView(
                  child: EditClientTableteDesktopBody(
                      client: client, state: state)),
            );
          },
        ),
      ),
    );
  }
}

class EditClientMobileBody extends StatelessWidget {
  const EditClientMobileBody({
    super.key,
    required this.client,
    required this.state,
  });

  final CustomerModel client;

  final EditClientState state;

  @override
  Widget build(BuildContext context) {
    return ClientDataBuilder(
      onSelectedImage: (image) => EditClientCubit.get(context).image = image,
      formKey: EditClientCubit.get(context).formKey,
      autovalidateMode: EditClientCubit.get(context).autovalidateMode,
      nameController: EditClientCubit.get(context).nameController,
      emailController: EditClientCubit.get(context).emailController,
      phoneController: EditClientCubit.get(context).phoneController,
      addressController: EditClientCubit.get(context).addressController,
      // commercialRegisterController:
      //     EditClientCubit.get(context).commercialRegisterController,
      // taxIdentificationNumberController:
      //     EditClientCubit.get(context).taxIdentificationNumberController,
      // noteController: EditClientCubit.get(context).noteController,
      isLoading: state is EditClientLoading,
      onPressed: () => EditClientCubit.get(context).editClient(),
      isEdit: true,
      // imageUrl: client.imagePath,
    );
  }
}

class EditClientTableteDesktopBody extends StatelessWidget {
  const EditClientTableteDesktopBody(
      {super.key, required this.client, required this.state});
  final CustomerModel client;

  final EditClientState state;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: SizedBox()),
        Expanded(
            flex: AppConstant.formExpandedTableandMobile,
            child: EditClientMobileBody(
              state: state,
              client: client,
            )),
        const Expanded(child: SizedBox()),
      ],
    );
  }
}
