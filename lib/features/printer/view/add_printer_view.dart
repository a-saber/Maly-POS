import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_helper.dart';
import 'package:pos_app/core/constant/constant.dart';
import 'package:pos_app/core/helper/my_service_locator.dart';
import 'package:pos_app/core/utils/app_padding.dart';
import 'package:pos_app/core/widget/custom_app_bar.dart';
import 'package:pos_app/core/widget/custom_grid_view_card.dart';
import 'package:pos_app/core/widget/custom_refresh_indicator.dart';
import 'package:pos_app/features/printer/data/repo/printer_repo.dart';
import 'package:pos_app/features/printer/manager/scan_printer/scan_printer_cubit.dart';
import 'package:pos_app/features/printer/manager/scan_printer/scan_printer_state.dart';
import 'package:pos_app/features/printer/view/printer_detailes.dart';
import 'package:pos_app/features/printer/widget/print_item.dart';
import 'package:pos_app/generated/l10n.dart';

class AddPrinterView extends StatelessWidget {
  const AddPrinterView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ScanPrintersCubit(MyServiceLocator.getSingleton<PrinterRepo>())..startLocalScan(),
      child: const _AddPrinterViewBody(),
    );
  }
}

class _AddPrinterViewBody extends StatelessWidget {
  const _AddPrinterViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = ScanPrintersCubit.get(context);

    return Scaffold(
      appBar: CustomAppBar(title: S.of(context).addPrinter),
      body: Padding(
        padding: AppPaddings.defaultView,
        child: Column(
          children: [
            Expanded(
              child: CustomRefreshIndicator(
                onRefresh: () async => cubit.refreshLocalScan(),
                child: BlocBuilder<ScanPrintersCubit, ScanPrintersState>(
                  builder: (context, state) {
                    if (state is ScanPrintersLoading) {
                      return CustomGridViewCard(
                        heightOfCard: 140,
                        itemBuilder: (context, index) => const Center(
                          child: Text('Scanning for printers...'),
                        ),
                        itemCount: AppConstant.numberOfCardLoading, // أو AppConstant.numberOfCardLoading
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
                              onPressed: () => cubit.startLocalScan(),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    }

                    if (state is ScanPrintersSuccess) {
                      final printers = state.printers;
                      if (printers.isEmpty) {
                        return const Center(
                            child: Text('No local printers found.'));
                      }

                      return CustomGridViewCard(
                        heightOfCard: 140,
                        itemBuilder: (context, index) {
                          final printer = printers[index];
                          return PrinterItem(
                            printer: printer,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      PrinterDetailsView(printer: printer),
                                ),
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
          ],
        ),
      ),
    );
  }
}
