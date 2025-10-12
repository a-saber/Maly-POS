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
import 'package:pos_app/features/suppliers/data/models/supplier_model.dart';
import 'package:pos_app/features/suppliers/data/repo/suppliers_repo.dart';
import 'package:pos_app/features/suppliers/manager/edit_supplier/edit_supplier_cubit.dart';
import 'package:pos_app/features/suppliers/manager/edit_supplier/edit_supplier_state.dart';
import 'package:pos_app/features/suppliers/manager/get_suppliers/get_suppliers_cubit.dart';
import 'package:pos_app/features/suppliers/views/widgets/delete_supplier_confirm_dialog.dart';
import 'package:pos_app/features/suppliers/views/widgets/supplier_data_builder.dart';
import 'package:pos_app/generated/l10n.dart';

class EditSupplierView extends StatelessWidget {
  const EditSupplierView({super.key, required this.supplier});
  final SupplierModel supplier;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditSupplierCubit(
          MyServiceLocator.getSingleton<SuppliersRepo>(), supplier),
      child: Scaffold(
        appBar: CustomAppBar(
          title: S.of(context).editSupplier,
          actions: [
            CustomTextBtn(
                text: S.of(context).delete,
                onPressed: () async {
                  await showDeleteSupplierConfirmDialog(
                      context: context, supplier: supplier, goBack: true);
                })
          ],
        ),
        body: BlocConsumer<EditSupplierCubit, EditSupplierState>(
          listener: (context, state) {
            if (state is EditSupplierSuccess) {
              GetSuppliersCubit.get(context).updateSupplier(state.supplier);
              CustomPopUp.callMyToast(
                  context: context,
                  massage: S.of(context).updatedSuccess,
                  state: PopUpState.SUCCESS);
              Navigator.pop(context);
            } else if (state is EditSupplierError) {
              if (context.mounted) {
                CustomPopUp.callMyToast(
                    context: context,
                    massage: mapStatusCodeToMessage(context, state.error),
                    state: PopUpState.ERROR);
              }
            }
          },
          builder: (context, state) {
            return CustomLayoutBuilder(
              mobile: MyCustomScrollView(
                  child:
                      EditSupplierMobileBody(state: state, supplier: supplier)),
              tablet: MyCustomScrollView(
                child: EditSupplierTabletAndDesktopBody(
                    state: state, supplier: supplier),
              ),
              desktop: MyCustomScrollView(
                child: EditSupplierTabletAndDesktopBody(
                    state: state, supplier: supplier),
              ),
            );
          },
        ),
      ),
    );
  }
}

class EditSupplierMobileBody extends StatelessWidget {
  const EditSupplierMobileBody({
    super.key,
    required this.supplier,
    required this.state,
  });
  final EditSupplierState state;
  final SupplierModel supplier;

  @override
  Widget build(BuildContext context) {
    return SupplierDataBuilder(
      // onSelectedImage: (image) => EditSupplierCubit.get(context).image = image,
      formKey: EditSupplierCubit.get(context).formKey,
      autovalidateMode: EditSupplierCubit.get(context).autovalidateMode,
      nameController: EditSupplierCubit.get(context).nameController,
      emailController: EditSupplierCubit.get(context).emailController,
      phoneController: EditSupplierCubit.get(context).phoneController,
      addressController: EditSupplierCubit.get(context).addressController,
      // commercialRegisterController:
      //     EditSupplierCubit.get(context).commercialRegisterController,
      // taxIdentificationNumberController:
      //     EditSupplierCubit.get(context).taxIdentificationNumberController,
      // noteController: EditSupplierCubit.get(context).noteController,
      isLoading: state is EditSupplierLoading,
      onPressed: () => EditSupplierCubit.get(context).editSupplier(),
      isEdit: true,
      // imageUrl: supplier.imagePath,
    );
  }
}

class EditSupplierTabletAndDesktopBody extends StatelessWidget {
  const EditSupplierTabletAndDesktopBody(
      {super.key, required this.state, required this.supplier});
  final EditSupplierState state;
  final SupplierModel supplier;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: SizedBox()),
        Expanded(
          flex: AppConstant.formExpandedTableandMobile,
          child: EditSupplierMobileBody(
            state: state,
            supplier: supplier,
          ),
        ),
        const Expanded(child: SizedBox()),
      ],
    );
  }
}
