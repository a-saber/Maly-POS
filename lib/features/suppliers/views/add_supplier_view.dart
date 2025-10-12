import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/core/constant/constant.dart';
import 'package:pos_app/core/helper/my_service_locator.dart';
import 'package:pos_app/core/widget/custom_app_bar.dart';
import 'package:pos_app/core/widget/custom_pop_up.dart';
import 'package:pos_app/core/widget/cutsom_layout_builder.dart';
import 'package:pos_app/core/widget/my_custom_scroll_view.dart';
import 'package:pos_app/features/suppliers/data/repo/suppliers_repo.dart';
import 'package:pos_app/features/suppliers/manager/add_supplier/add_supplier_cubit.dart';
import 'package:pos_app/features/suppliers/manager/add_supplier/add_supplier_state.dart';
import 'package:pos_app/features/suppliers/manager/get_suppliers/get_suppliers_cubit.dart';
import 'package:pos_app/features/suppliers/views/widgets/supplier_data_builder.dart';
import 'package:pos_app/generated/l10n.dart';

class AddSupplierView extends StatelessWidget {
  const AddSupplierView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AddSupplierCubit(MyServiceLocator.getSingleton<SuppliersRepo>()),
      child: Scaffold(
        appBar: CustomAppBar(title: S.of(context).addSupplier),
        body: BlocConsumer<AddSupplierCubit, AddSupplierState>(
          listener: (context, state) {
            if (state is AddSupplierSuccess) {
              GetSuppliersCubit.get(context).addSupplier(
                state.supplier,
              );
              CustomPopUp.callMyToast(
                  context: context,
                  massage: S.of(context).addedSuccess,
                  state: PopUpState.SUCCESS);
              Navigator.pop(context);
            } else if (state is AddSupplierError) {
              if (context.mounted) {
                CustomPopUp.callMyToast(
                    context: context,
                    massage: mapStatusCodeToMessage(
                      context,
                      state.error,
                    ),
                    state: PopUpState.ERROR);
              }
            }
          },
          builder: (context, state) {
            return CustomLayoutBuilder(
              mobile: MyCustomScrollView(
                  child: AddSupplierMobileBody(state: state)),
              tablet: MyCustomScrollView(
                  child: AddSupplierTabletAndDesktopBody(state: state)),
              desktop: MyCustomScrollView(
                  child: AddSupplierTabletAndDesktopBody(state: state)),
            );
          },
        ),
      ),
    );
  }
}

class AddSupplierMobileBody extends StatelessWidget {
  const AddSupplierMobileBody({
    super.key,
    required this.state,
  });
  final AddSupplierState state;
  @override
  Widget build(BuildContext context) {
    return SupplierDataBuilder(
      // onSelectedImage: (image) => AddSupplierCubit.get(context).image = image,
      formKey: AddSupplierCubit.get(context).formKey,
      autovalidateMode: AddSupplierCubit.get(context).autovalidateMode,
      nameController: AddSupplierCubit.get(context).nameController,
      emailController: AddSupplierCubit.get(context).emailController,
      phoneController: AddSupplierCubit.get(context).phoneController,
      addressController: AddSupplierCubit.get(context).addressController,
      // commercialRegisterController:
      //     AddSupplierCubit.get(context).commercialRegisterController,
      // taxIdentificationNumberController:
      //     AddSupplierCubit.get(context).taxIdentificationNumberController,
      // noteController: AddSupplierCubit.get(context).noteController,
      isLoading: state is AddSupplierLoading,
      onPressed: () => AddSupplierCubit.get(context).addSupplier(),
      isEdit: false,
      // imageUrl: null,
    );
  }
}

class AddSupplierTabletAndDesktopBody extends StatelessWidget {
  const AddSupplierTabletAndDesktopBody({super.key, required this.state});
  final AddSupplierState state;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: SizedBox()),
        Expanded(
          flex: AppConstant.formExpandedTableandMobile,
          child: AddSupplierMobileBody(state: state),
        ),
        const Expanded(child: SizedBox()),
      ],
    );
  }
}
