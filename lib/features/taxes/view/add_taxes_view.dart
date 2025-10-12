import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/core/constant/constant.dart';
import 'package:pos_app/core/helper/my_service_locator.dart';
import 'package:pos_app/core/widget/custom_app_bar.dart';
import 'package:pos_app/core/widget/custom_pop_up.dart';
import 'package:pos_app/core/widget/cutsom_layout_builder.dart';
import 'package:pos_app/core/widget/my_custom_scroll_view.dart';
import 'package:pos_app/features/taxes/data/repo/taxes_repo.dart';
import 'package:pos_app/features/taxes/manager/add_taxes_cubit/add_taxes_cubit.dart';
import 'package:pos_app/features/taxes/manager/get_all_taxes_cubit/get_all_taxes_cubit.dart';
import 'package:pos_app/features/taxes/view/widget/taxes_data_build.dart';
import 'package:pos_app/generated/l10n.dart';

class AddTaxesView extends StatelessWidget {
  const AddTaxesView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AddTaxesCubit(MyServiceLocator.getSingleton<TaxesRepo>()),
      child: Scaffold(
        appBar: CustomAppBar(title: S.of(context).addTax),
        body: BlocConsumer<AddTaxesCubit, AddTaxesState>(
          listener: (context, state) {
            if (state is AddTaxesSuccess) {
              GetAllTaxesCubit.get(context).addTaxes(
                taxes: state.taxes,
              );
              CustomPopUp.callMyToast(
                  context: context,
                  massage: S.of(context).addedSuccess,
                  state: PopUpState.SUCCESS);
              Navigator.pop(context);
            } else if (state is AddTaxesFailing) {
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
                  MyCustomScrollView(child: AddTaxesMobileBody(state: state)),
              tablet: MyCustomScrollView(
                  child: AddTaxesTabletAndDesktopBody(state: state)),
              desktop: MyCustomScrollView(
                  child: AddTaxesTabletAndDesktopBody(state: state)),
            );
          },
        ),
      ),
    );
  }
}

class AddTaxesMobileBody extends StatelessWidget {
  const AddTaxesMobileBody({
    super.key,
    required this.state,
  });
  final AddTaxesState state;
  @override
  Widget build(BuildContext context) {
    return TaxesDataBuild(
        autovalidateMode: AddTaxesCubit.get(context).autovalidateMode,
        formKey: AddTaxesCubit.get(context).formKey,
        titleController: AddTaxesCubit.get(context).titleController,
        percentageController: AddTaxesCubit.get(context).percentageConroller,
        isLoading: state is AddTaxesLoading,
        onPressed: () => AddTaxesCubit.get(context).addTax(),
        isEdit: false);
  }
}

class AddTaxesTabletAndDesktopBody extends StatelessWidget {
  const AddTaxesTabletAndDesktopBody({super.key, required this.state});
  final AddTaxesState state;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: SizedBox()),
        Expanded(
          flex: AppConstant.formExpandedTableandMobile,
          child: AddTaxesMobileBody(state: state),
        ),
        Expanded(child: SizedBox()),
      ],
    );
  }
}
