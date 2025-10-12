import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/core/helper/my_service_locator.dart';
import 'package:pos_app/core/utils/app_padding.dart';
import 'package:pos_app/core/widget/custom_app_bar.dart';
import 'package:pos_app/core/widget/custom_btn.dart';
import 'package:pos_app/core/widget/custom_form_field.dart';
import 'package:pos_app/core/widget/custom_loading.dart';
import 'package:pos_app/core/widget/custom_pop_up.dart';
import 'package:pos_app/core/widget/cutsom_layout_builder.dart';
import 'package:pos_app/features/sales/data/model/sales_model.dart';
import 'package:pos_app/features/sales/data/repo/sales_repo.dart';
import 'package:pos_app/features/sales/manager/get_sales_cubit/get_sales_cubit.dart';
import 'package:pos_app/features/sales/manager/return_sales_cubit/return_sales_cubit.dart';
import 'package:pos_app/generated/l10n.dart';

class ReturnSalesConfirmView extends StatelessWidget {
  const ReturnSalesConfirmView({super.key, required this.salesModel});
  final SalesModel salesModel;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReturnSalesCubit(
        MyServiceLocator.getSingleton<SalesRepo>(),
      ),
      child: Scaffold(
        appBar: CustomAppBar(
          title: S.of(context).returnSalesConfirm,
        ),
        body: BlocConsumer<ReturnSalesCubit, ReturnSalesState>(
          listener: (context, state) {
            if (state is ReturnSalesSuccess) {
              MyServiceLocator.getSingleton<GetSalesCubit>().getSales();
              Navigator.pop(context);
              Navigator.pop(context);
            } else if (state is ReturnSalesFailing) {
              if (context.mounted) {
                CustomPopUp.callMyToast(
                  context: context,
                  massage: mapStatusCodeToMessage(context, state.message),
                  state: PopUpState.ERROR,
                );
              }
            }
          },
          builder: (context, state) {
            return Padding(
              padding: AppPaddings.defaultView,
              child: CustomLayoutBuilder(
                mobile: ReturnSalesConfirmMobileBody(
                  salesModel: salesModel,
                  state: state,
                ),
                tablet: ReturnSalesConfirmTabletAndDesktopeBody(
                  salesModel: salesModel,
                  state: state,
                ),
                desktop: ReturnSalesConfirmTabletAndDesktopeBody(
                  salesModel: salesModel,
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

class ReturnSalesConfirmMobileBody extends StatelessWidget {
  const ReturnSalesConfirmMobileBody({
    super.key,
    required this.salesModel,
    required this.state,
  });

  final ReturnSalesState state;

  final SalesModel salesModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                CustomFormField(
                  controller: ReturnSalesCubit.get(context).reasonController,
                  labelText: S.of(context).reason,
                ),
              ],
            ),
          ),
        ),
        state is ReturnSalesLoading
            ? const CustomLoading()
            : CustomFilledBtn(
                text: S.of(context).Return,
                onPressed: () {
                  ReturnSalesCubit.get(context).returnSales(
                    id: salesModel.id ?? -1,
                  );
                },
              ),
        SizedBox(
          height: 5,
        ),
      ],
    );
  }
}

class ReturnSalesConfirmTabletAndDesktopeBody extends StatelessWidget {
  const ReturnSalesConfirmTabletAndDesktopeBody({
    super.key,
    required this.salesModel,
    required this.state,
  });

  final ReturnSalesState state;

  final SalesModel salesModel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: SizedBox()),
        Expanded(
          flex: 2,
          child: ReturnSalesConfirmMobileBody(
            salesModel: salesModel,
            state: state,
          ),
        ),
        const Expanded(child: SizedBox()),
      ],
    );
  }
}
