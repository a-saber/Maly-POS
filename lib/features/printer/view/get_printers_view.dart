import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/constant/constant.dart';
import 'package:pos_app/core/helper/my_service_locator.dart';
import 'package:pos_app/core/router/app_route.dart';
import 'package:pos_app/core/utils/app_padding.dart';
import 'package:pos_app/core/widget/custom_app_bar.dart';
import 'package:pos_app/core/widget/custom_floating_action_btn.dart';
import 'package:pos_app/core/widget/custom_grid_view_card.dart';
import 'package:pos_app/core/widget/custom_refresh_indicator.dart';
import 'package:pos_app/features/printer/manager/scan_printer/scan_printer_cubit.dart';
import 'package:pos_app/features/printer/manager/scan_printer/scan_printer_state.dart';
import 'package:pos_app/features/printer/widget/print_item.dart';
import 'package:pos_app/generated/l10n.dart';

import '../../../core/api/api_response.dart';

class GetPrintersView extends StatelessWidget {
  const GetPrintersView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: MyServiceLocator.getSingleton<GetPrintersCubit>()..init(),
      child: const _PrintersViewBody(),
    );
  }
}

class _PrintersViewBody extends StatelessWidget {
  const _PrintersViewBody();

  @override
  Widget build(BuildContext context) {
    final cubit = GetPrintersCubit.get(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: S.of(context).printer,
      ),
      floatingActionButton: CustomFloatingActionBtn(
        onPressed: () async {
          final result =
              await Navigator.pushNamed(context, AppRoutes.scanPrinterView);
          if (result == true) {
            cubit.fetchPrintersFromApi(isFresh: true);
          }
        },
      ),
      body: CustomRefreshIndicator(
        onRefresh: () async {
          await cubit.fetchPrintersFromApi();
        },
        child: Padding(
          padding: AppPaddings.defaultView,
          child: BlocBuilder<GetPrintersCubit, GetPrintersState>(
            builder: (context, state) {
              if (state is ScanPrintersLoading) {
                return CustomGridViewCard(
                  heightOfCard: MediaQuery.of(context).textScaler.scale(110),
                  itemBuilder: (context, index) =>
                      const Center(child: Text('Loading...')),
                  itemCount: AppConstant.numberOfCardLoading,
                );
              }

              if (state is ScanPrintersFailing) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                          'Error: ${state.errMessage != null ? mapStatusCodeToMessage(context, state.errMessage!) : state.message ?? 'error'}'),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () => cubit.fetchPrintersFromApi(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              if (state is ScanPrintersSuccess) {
                final printers = state.printers;
                // print(printers);

                if (printers.isEmpty) {
                  return Center(
                    child: Text(
                      S.of(context).youHaveNoData,
                      style: const TextStyle(fontSize: 16),
                    ),
                  );
                }

                return CustomGridViewCard(
                  controller: cubit.scrollController,
                  heightOfCard: MediaQuery.of(context).textScaler.scale(110),
                  itemBuilder: (context, index) {
                    final printer = printers[index];
                    return PrinterItem(
                      printer: printer,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.editPrinterView,
                          arguments: printer,
                        );
                      },
                    );
                  },
                  itemCount: printers.length,
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
