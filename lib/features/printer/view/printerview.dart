// printers_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/constant/constant.dart';
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

class PrintersView extends StatelessWidget {
  const PrintersView({super.key});

  @override
  Widget build(BuildContext context) {
    // Provide Cubit above in widget tree (if not provided), otherwise get existing
    return BlocProvider(
      create: (_) => ScanPrintersCubit(),
      child: _PrintersViewBody(),
    );
  }
}

class _PrintersViewBody extends StatelessWidget {
  const _PrintersViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = ScanPrintersCubit.get(context);

    return Scaffold(
      floatingActionButton: CustomFloatingActionBtn(onPressed: (

      ) async {
        Navigator.pushNamed(context, AppRoutes.addPrinter);
      }),
      appBar: CustomAppBar(title: S.of(context).printer),
      body: CustomRefreshIndicator(
        onRefresh: () async {
          await cubit.refresh();
        },
        child: Padding(
          padding: AppPaddings.defaultView,
          child: BlocBuilder<ScanPrintersCubit, ScanPrintersState>(
            builder: (context, state) {
              // Loading screen (show same loading cards as Products)
              if (state is ScanPrintersLoading) {
                return CustomGridViewCard(
                  heightOfCard: MediaQuery.of(context).textScaler.scale(110),
                  itemBuilder: (context, index) {
                    return const Center(child: Text('Loading...'));
                  },
                  itemCount: AppConstant.numberOfCardLoading,
                );
              }

              // Failing -> show message and a retry button
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

              // Success (may be empty)
              final printers =
                  (state is ScanPrintersSuccess) ? state.printers : [];

              if (printers.isEmpty) {
                return SizedBox.expand(
                  child: Center(
                    child: Text(
                      S.of(context).youHaveNoData,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                );
              }

              return CustomGridViewCard(
                heightOfCard: MediaQuery.of(context).textScaler.scale(110),
                itemBuilder: (context, index) {
                  return PrinterItem(printer: printers[index]);
                },
                itemCount: printers.length,
              );
            },
          ),
        ),
      ),
    );
  }
}
