import 'package:flutter/material.dart';
import 'package:pos_app/features/printer/data/model/printers_search_model.dart';
import 'package:pos_app/core/helper/printer_helper.dart';

class PrinterItem extends StatelessWidget {
  final dynamic printer; 
   final VoidCallback? onTap;
  const PrinterItem({super.key, required this.printer, this.onTap});

  @override
  Widget build(BuildContext context) {
    String title = '';
    String subtitle = '';
    String? type;
    if (printer is Data) {
      final apiPrinter = printer as Data;
      title = apiPrinter.printerName ?? 'Unnamed Printer';
      type = apiPrinter.printerType;
      subtitle = 'Type: ${apiPrinter.printerType ?? 'Unknown'}';
    }
    else if (printer is DiscoveredPrinter) {
      final localPrinter = printer as DiscoveredPrinter;
      title = localPrinter.device.name ?? 'Discovered Printer';
      type = 'Local';
      subtitle = localPrinter.device.address ?? 'Unknown address';
    }
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        leading: Icon(
          Icons.print,
          color: Colors.blueAccent,
          size: 32,
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
        trailing: Text(
          type ?? '',
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
       onTap: onTap
      ),
    );
  }
}
