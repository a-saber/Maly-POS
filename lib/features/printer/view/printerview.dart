import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_helper.dart';
import 'package:pos_app/core/constant/constant.dart';
import 'package:pos_app/core/helper/my_service_locator.dart';
import 'package:pos_app/core/router/app_route.dart';
import 'package:pos_app/core/utils/app_padding.dart';
import 'package:pos_app/core/widget/custom_app_bar.dart';
import 'package:pos_app/core/widget/custom_floating_action_btn.dart';
import 'package:pos_app/core/widget/custom_grid_view_card.dart';
import 'package:pos_app/core/widget/custom_refresh_indicator.dart';
import 'package:pos_app/features/printer/data/model/printers_search_model.dart';
import 'package:pos_app/features/printer/data/repo/printer_repo.dart';
import 'package:pos_app/features/printer/manager/scan_printer/scan_printer_cubit.dart';
import 'package:pos_app/features/printer/manager/scan_printer/scan_printer_state.dart';
import 'package:pos_app/features/printer/widget/print_item.dart';
import 'package:pos_app/generated/l10n.dart';

class PrintersView extends StatelessWidget {
  const PrintersView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(

      create: (_) => ScanPrintersCubit(MyServiceLocator.getSingleton<PrinterRepo>())..fetchPrintersFromApi(),
      child: const _PrintersViewBody(),
    );
  }
}

class _PrintersViewBody extends StatelessWidget {
  const _PrintersViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = ScanPrintersCubit.get(context);

    return Scaffold(
      appBar: CustomAppBar(title: S.of(context).printer),
      floatingActionButton: CustomFloatingActionBtn(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.addPrinter);
        },
      ),
      body: CustomRefreshIndicator(
        onRefresh: () async {
          await cubit.fetchPrintersFromApi();
        },
        child: Padding(
          padding: AppPaddings.defaultView,
          child: BlocBuilder<ScanPrintersCubit, ScanPrintersState>(
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
                      Text('Error: ${state.error}'),
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
               print(printers);


                if (printers.isEmpty) {
                  return Center(
                    child: Text(
                      S.of(context).youHaveNoData,
                      style: const TextStyle(fontSize: 16),
                    ),
                  );
                }

                return CustomGridViewCard(
                  heightOfCard: MediaQuery.of(context).textScaler.scale(110),
                  itemBuilder: (context, index) {
                    final printer = printers[index];
                    return PrinterItem(
                      printer: printer,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.printerDetails,
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
