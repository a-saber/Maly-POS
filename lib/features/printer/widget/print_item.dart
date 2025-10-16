// printer_item.dart
import 'package:flutter/material.dart';
import 'package:pos_app/core/helper/printer_helper.dart';
import 'package:pos_app/core/router/app_route.dart';
import 'package:pos_app/features/printer/manager/scan_printer/scan_printer_cubit.dart';

class PrinterItem extends StatelessWidget {
  final DiscoveredPrinter printer;
  const PrinterItem({super.key, required this.printer});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutes.printerDetails,
            arguments: printer,
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.print, size: 36),
                const SizedBox(height: 8),
                Text(
                  printer.device.name ?? 'Unknown',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                const SizedBox(height: 4),
                Text(
                  printer.device.address ?? '',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // void _showActions(BuildContext context, ScanPrintersCubit cubit) {
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (ctx) {
  //       return SafeArea(
  //         child: Wrap(
  //           children: [
  //             ListTile(
  //               leading: const Icon(Icons.usb),
  //               title: const Text('Test Print'),
  //               onTap: () async {
  //                 Navigator.pop(ctx);
  //                 try {
  //                   await cubit.printTest(printer);
  //                   ScaffoldMessenger.of(context).showSnackBar(
  //                     const SnackBar(content: Text('Test print sent')),
  //                   );
  //                 } catch (e) {
  //                   ScaffoldMessenger.of(context).showSnackBar(
  //                     SnackBar(content: Text('Print error: $e')),
  //                   );
  //                 }
  //               },
  //             ),
  //             ListTile(
  //               leading: const Icon(Icons.check),
  //               title: const Text('Select / Save'),
  //               onTap: () {
  //                 Navigator.pop(ctx);

  //                 ScaffoldMessenger.of(context).showSnackBar(
  //                   const SnackBar(content: Text('Printer selected')),
  //                 );
  //               },
  //             ),
  //             ListTile(
  //               leading: const Icon(Icons.close),
  //               title: const Text('Cancel'),
  //               onTap: () => Navigator.pop(ctx),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }
}
