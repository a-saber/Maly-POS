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
import 'package:pos_app/features/taxes/data/model/taxes_model.dart';
import 'package:pos_app/features/taxes/data/repo/taxes_repo.dart';
import 'package:pos_app/features/taxes/manager/edit_taxes_cubit/edit_taxes_cubit.dart';
import 'package:pos_app/features/taxes/manager/get_all_taxes_cubit/get_all_taxes_cubit.dart';
import 'package:pos_app/features/taxes/view/widget/show_delete_taxes_confirm_dialog.dart';
import 'package:pos_app/features/taxes/view/widget/taxes_data_build.dart';
import 'package:pos_app/generated/l10n.dart';

class EditTaxesView extends StatelessWidget {
  const EditTaxesView({super.key, required this.taxes});
  final TaxesModel taxes;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          EditTaxesCubit(MyServiceLocator.getSingleton<TaxesRepo>(), taxes),
      child: Scaffold(
        appBar: CustomAppBar(
          title: S.of(context).editTax,
          actions: [
            CustomTextBtn(
                text: S.of(context).delete,
                onPressed: () async {
                  await showDeleteTaxesConfirmDialog(
                      context: context, taxes: taxes, goBack: true);
                })
          ],
        ),
        body: BlocConsumer<EditTaxesCubit, EditTaxesState>(
          listener: (context, state) {
            if (state is EditTaxesSuccess) {
              GetAllTaxesCubit.get(context).updateTaxes(
                taxes: state.tax,
              );
              CustomPopUp.callMyToast(
                  context: context,
                  massage: S.of(context).updatedSuccess,
                  state: PopUpState.SUCCESS);
              Navigator.pop(context);
            } else if (state is EditTaxesFailing) {
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
                child: EditTaxesMobileBody(
                  state: state,
                ),
              ),
              tablet: MyCustomScrollView(
                child: EditTaxesTabletAndDesktopBody(
                  state: state,
                ),
              ),
              desktop: MyCustomScrollView(
                child: EditTaxesTabletAndDesktopBody(
                  state: state,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class EditTaxesMobileBody extends StatelessWidget {
  const EditTaxesMobileBody({
    super.key,
    required this.state,
  });
  final EditTaxesState state;
  @override
  Widget build(BuildContext context) {
    return TaxesDataBuild(
      autovalidateMode: EditTaxesCubit.get(context).autovalidateMode,
      formKey: EditTaxesCubit.get(context).formKey,
      titleController: EditTaxesCubit.get(context).titleController,
      percentageController: EditTaxesCubit.get(context).percentageController,
      isLoading: state is EditTaxesLoading,
      onPressed: () => EditTaxesCubit.get(context).editTax(),
      isEdit: true,
    );
  }
}

class EditTaxesTabletAndDesktopBody extends StatelessWidget {
  const EditTaxesTabletAndDesktopBody({super.key, required this.state});
  final EditTaxesState state;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: SizedBox()),
        Expanded(
          flex: AppConstant.formExpandedTableandMobile,
          child: EditTaxesMobileBody(state: state),
        ),
        Expanded(child: SizedBox()),
      ],
    );
  }
}
