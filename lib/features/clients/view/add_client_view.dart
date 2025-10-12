import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/core/constant/constant.dart';
import 'package:pos_app/core/helper/my_service_locator.dart';
import 'package:pos_app/core/widget/custom_app_bar.dart';
import 'package:pos_app/core/widget/custom_pop_up.dart';
import 'package:pos_app/core/widget/cutsom_layout_builder.dart';
import 'package:pos_app/core/widget/my_custom_scroll_view.dart';
import 'package:pos_app/features/clients/data/repo/clients_repo.dart';
import 'package:pos_app/features/clients/manager/add_client/add_client_cubit.dart';
import 'package:pos_app/features/clients/manager/get_clients/get_clients_cubit.dart';
import 'package:pos_app/features/clients/view/widget/client_data_build.dart';
import 'package:pos_app/generated/l10n.dart';

class AddClientView extends StatelessWidget {
  const AddClientView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AddClientCubit(MyServiceLocator.getSingleton<ClientsRepo>()),
      child: Scaffold(
        appBar: CustomAppBar(title: S.of(context).addClient),
        body: BlocConsumer<AddClientCubit, AddClientState>(
          listener: (context, state) {
            if (state is AddClientSuccess) {
              GetClientsCubit.get(context).addClient(
                state.customer,
              );
              CustomPopUp.callMyToast(
                  context: context,
                  massage: S.of(context).addedSuccess,
                  state: PopUpState.SUCCESS);
              Navigator.pop(context);
            } else if (state is AddClientFailing) {
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
              mobile:
                  MyCustomScrollView(child: AddClientMobileBody(state: state)),
              tablet: MyCustomScrollView(
                  child: AddClientTableteAndDisctopBody(state: state)),
              desktop: MyCustomScrollView(
                  child: AddClientTableteAndDisctopBody(state: state)),
            );
          },
        ),
      ),
    );
  }
}

class AddClientMobileBody extends StatelessWidget {
  const AddClientMobileBody({
    super.key,
    required this.state,
  });

  final AddClientState state;

  @override
  Widget build(BuildContext context) {
    return ClientDataBuilder(
      onSelectedImage: (image) => AddClientCubit.get(context).image = image,
      formKey: AddClientCubit.get(context).formKey,
      autovalidateMode: AddClientCubit.get(context).autovalidateMode,
      nameController: AddClientCubit.get(context).nameController,
      emailController: AddClientCubit.get(context).emailController,
      phoneController: AddClientCubit.get(context).phoneController,
      addressController: AddClientCubit.get(context).addressController,
      // commercialRegisterController:
      //     AddClientCubit.get(context).commercialRegisterController,
      // taxIdentificationNumberController:
      //     AddClientCubit.get(context).taxIdentificationNumberController,
      // noteController: AddClientCubit.get(context).noteController,
      isLoading: state is AddClientLoading,
      onPressed: () => AddClientCubit.get(context).addClient(),
      isEdit: false,
      imageUrl: null,
    );
  }
}

class AddClientTableteAndDisctopBody extends StatelessWidget {
  const AddClientTableteAndDisctopBody({super.key, required this.state});
  final AddClientState state;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: SizedBox()),
        Expanded(
            flex: AppConstant.formExpandedTableandMobile,
            child: AddClientMobileBody(
              state: state,
            )),
        const Expanded(child: SizedBox()),
      ],
    );
  }
}
