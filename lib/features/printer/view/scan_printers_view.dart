import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/constant/constant.dart';
import 'package:pos_app/core/router/app_route.dart';
import 'package:pos_app/core/utils/app_padding.dart';
import 'package:pos_app/core/widget/custom_app_bar.dart';
import 'package:pos_app/core/widget/custom_btn.dart';
import 'package:pos_app/core/widget/custom_grid_view_card.dart';
import 'package:pos_app/core/widget/custom_refresh_indicator.dart';
import 'package:pos_app/features/printer/manager/scan_local_printers_cubit/scan_local_printers_state.dart';
import 'package:pos_app/features/printer/view/add_printer_view.dart';
import 'package:pos_app/features/printer/widget/print_item.dart';
import 'package:pos_app/generated/l10n.dart';
import '../manager/scan_local_printers_cubit/scan_local_printers_cubit.dart';

class ScanPrintersView extends StatelessWidget {
  const ScanPrintersView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ScanLocalPrintersCubit()..getDiscoveredPrinters(),
      child: const _AddPrinterViewBody(),
    );
  }
}

class _AddPrinterViewBody extends StatelessWidget {
  const _AddPrinterViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = ScanLocalPrintersCubit.get(context);

    return Scaffold(
      appBar: CustomAppBar(title: S.of(context).addPrinter,
          actions:(!kIsWeb&&(Platform.isAndroid||Platform.isIOS))
              ? [
              CustomTextBtn(
                text: S.of(context).addPrinterIp,
                onPressed:(){
                  Navigator.pushNamed(context, AppRoutes.addIpPrinter);
                } ,
              ),
            ]
              : []),
      body: Padding(
        padding: AppPaddings.defaultView,
        child: Column(
          children: [
            Expanded(
              child: CustomRefreshIndicator(
                onRefresh: () async => cubit.getDiscoveredPrinters(),
                child: BlocBuilder<ScanLocalPrintersCubit, ScanLocalPrintersState>(
                  builder: (context, state) {
                    if (state is ScanLocalPrintersLoading) {
                      return CustomGridViewCard(
                        heightOfCard: 140,
                        itemBuilder: (context, index) => const Center(
                          child: Text('Scanning for printers...'),
                        ),
                        itemCount: AppConstant.numberOfCardLoading, 
                      );
                    }

                    if (state is ScanLocalPrintersFailure) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Error: ${state.message}'),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: () => cubit.getDiscoveredPrinters(),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    }

                    if (state is ScanLocalPrintersSuccess) {
                      final printers = state.discoveredPrinters;
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
                                      AddPrinterView(discoveredPrinter: printer),
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
