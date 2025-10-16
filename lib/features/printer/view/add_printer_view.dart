import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/constant/constant.dart';
import 'package:pos_app/core/utils/app_padding.dart';
import 'package:pos_app/core/widget/custom_app_bar.dart';
import 'package:pos_app/core/widget/custom_grid_view_card.dart';
import 'package:pos_app/core/widget/custom_refresh_indicator.dart';
import 'package:pos_app/features/printer/manager/scan_printer/scan_printer_cubit.dart';
import 'package:pos_app/features/printer/manager/scan_printer/scan_printer_state.dart';
import 'package:pos_app/generated/l10n.dart';

class AddPrinterView extends StatelessWidget {
  const AddPrinterView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ScanPrintersCubit()..startScan(),
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
      body: CustomRefreshIndicator(
        onRefresh: () async {
          await cubit.refresh();
        },
        child: Padding(
          padding: AppPaddings.defaultView,
          child: BlocBuilder<ScanPrintersCubit, ScanPrintersState>(
            builder: (context, state) {
              // حالة التحميل
              if (state is ScanPrintersLoading) {
                return CustomGridViewCard(
                  heightOfCard: MediaQuery.of(context).textScaler.scale(110),
                  itemBuilder: (context, index) =>
                      const Center(child: Text('Scanning...')),
                  itemCount: AppConstant.numberOfCardLoading,
                );
              }

              // حالة الفشل
              if (state is ScanPrintersFailing) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Error: ${state.error}'),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () => cubit.startScan(force: true),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              if (state is ScanPrintersSuccess) {
                final printers = state.printers;
                return CustomGridViewCard(
                  heightOfCard: MediaQuery.of(context).textScaler.scale(140),
                  itemBuilder: (context, index) {
                    final printer = printers[index];
                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/printerDetails',
                            arguments: printer,
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.print, size: 36),
                              const SizedBox(height: 8),
                              Text(
                                printer.device.name ?? 'Unknown Printer',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                printer.device.address ?? '',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: printers.length,
                );
              }

              // fallback: لا تعرض شيء أثناء الانتظار
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
