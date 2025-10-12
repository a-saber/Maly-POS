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
import 'package:pos_app/features/suppliers/manager/get_suppliers/get_supplier_state.dart';
import 'package:pos_app/features/suppliers/manager/get_suppliers/get_suppliers_cubit.dart';
import 'package:pos_app/generated/l10n.dart';

import 'widgets/supplier_item_builder.dart';

class SuppliersView extends StatelessWidget {
  const SuppliersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: CustomFloatingActionBtn(onPressed: () {
        Navigator.pushNamed(context, AppRoutes.addSupplier);
      }),
      appBar: CustomAppBar(title: S.of(context).suppliers),
      body: CustomRefreshIndicator(
        onRefresh: () async {
          GetSuppliersCubit.get(context).getSuppliers();
        },
        child: Padding(
            padding: AppPaddings.defaultView,
            child: BlocConsumer<GetSuppliersCubit, GetSuppliersState>(
              listener: (context, state) {
                if (state is GetSuppliersErrorPagination) {
                  if (context.mounted) {
                    CustomPopUp.callMyToast(
                      context: context,
                      massage:
                          mapStatusCodeToMessage(context, state.errMessage),
                      state: PopUpState.ERROR,
                    );
                  }
                }
              },
              builder: (context, state) {
                if (state is GetSuppliersError) {
                  return CustomError(
                    error: context.mounted
                        ? mapStatusCodeToMessage(context, state.error)
                        : 'error',
                    onPressed: () =>
                        GetSuppliersCubit.get(context).getSuppliers(),
                  );
                } else if (state is GetSuppliersLoading) {
                  return CustomGridViewCard(
                    heightOfCard: MediaQuery.of(context).textScaler.scale(110),
                    itemBuilder: (context, index) {
                      return CardSupplierLoading();
                    },
                    itemCount: AppConstant.numberOfCardLoading,
                  );
                }
                if (GetSuppliersCubit.get(context).suppliers.isEmpty) {
                  return CustomEmptyView(
                    onPressed: () =>
                        GetSuppliersCubit.get(context).getSuppliers(),
                  );
                }
                return CustomGridViewCard(
                  controller: GetSuppliersCubit.get(context).scrollController,
                  canLaoding: GetSuppliersCubit.get(context).canLoading(),
                  heightOfCard: MediaQuery.of(context).textScaler.scale(110),
                  itemBuilder: (context, index) {
                    return SupplierItemBuilder(
                        supplier:
                            GetSuppliersCubit.get(context).suppliers[index]);
                  },
                  itemCount: GetSuppliersCubit.get(context).suppliers.length,
                );
              },
            )),
      ),
    );
  }
}
