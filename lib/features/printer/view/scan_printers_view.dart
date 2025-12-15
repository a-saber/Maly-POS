import 'dart:io' show Platform;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pos_app/core/constant/constant.dart';
import 'package:pos_app/core/router/app_route.dart';
import 'package:pos_app/core/utils/app_padding.dart';
import 'package:pos_app/core/widget/custom_app_bar.dart';
import 'package:pos_app/core/widget/custom_btn.dart';
import 'package:pos_app/core/widget/custom_grid_view_card.dart';
import 'package:pos_app/core/widget/custom_refresh_indicator.dart';
import 'package:pos_app/features/printer/manager/scan_local_printers_cubit/scan_local_printers_state.dart';
import 'package:pos_app/features/printer/widget/print_item.dart';
import 'package:pos_app/generated/l10n.dart';
import '../manager/scan_local_printers_cubit/scan_local_printers_cubit.dart';

class ScanPrintersView extends StatefulWidget {
  const ScanPrintersView({super.key});

  @override
  State<ScanPrintersView> createState() => _ScanPrintersViewState();
}

class _ScanPrintersViewState extends State<ScanPrintersView> {
   @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

Future<void> _requestPermissions() async {
  if (!kIsWeb && Platform.isAndroid) {
    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;
    final sdkInt = androidInfo.version.sdkInt;

    if (sdkInt >= 31) {
      // Android 12+
      await Permission.bluetoothScan.request();
      await Permission.bluetoothConnect.request();
      await Permission.bluetoothAdvertise.request();
      
      // Some devices still need location
      await Permission.location.request();

      final scanStatus = await Permission.bluetoothScan.status;
      final connectStatus = await Permission.bluetoothConnect.status;
      if (!scanStatus.isGranted || !connectStatus.isGranted) {
        _showPermissionDialog();
        return;
      }
    } else {
      // Android 10-11
      await Permission.bluetooth.request();
      await Permission.location.request();

      final serviceStatus = await Permission.location.serviceStatus;
      if (serviceStatus != ServiceStatus.enabled) {
        _showPermissionDialog();
        return;
      }

      final locStatus = await Permission.location.status;
      if (!locStatus.isGranted) {
        _showPermissionDialog();
        return;
      }
    }
  }
}

void _showPermissionDialog() {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Permissions Required'),
      content: const Text(
        'This app needs the following permissions:\n\n'
        '• Bluetooth (to scan for printers)\n'
        '• Location (required by Android for Bluetooth scanning)\n'
        '• Nearby Devices (Android 13+)\n\n'
        'Please enable all permissions in app settings.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            openAppSettings();
          },
          child: const Text('Open Settings'),
        ),
      ],
    ),
  );
}  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ScanLocalPrintersCubit()..getDiscoveredPrinters(),
      child: const _AddPrinterViewBody(),
    );
  }
}

class _AddPrinterViewBody extends StatelessWidget {
  const _AddPrinterViewBody();
  
  @override
  Widget build(BuildContext context) {
    final cubit = ScanLocalPrintersCubit.get(context);

    return Scaffold(
      appBar: CustomAppBar(
          title: S.of(context).addPrinter,
          actions: (!kIsWeb && (Platform.isAndroid || Platform.isIOS))
              ? [
                  CustomTextBtn(
                    text: S.of(context).addPrinterIp,
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.addIpPrinterView,
                      );
                    },
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
                child:
                    BlocBuilder<ScanLocalPrintersCubit, ScanLocalPrintersState>(
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
                              // TODO : Add Printer Screen

                              Navigator.pushNamed(
                                context,
                                AppRoutes.addPrinterView,
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
          ],
        ),
      ),
    );
  }
}
