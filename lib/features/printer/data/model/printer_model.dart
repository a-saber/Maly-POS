import 'package:pos_app/core/helper/printer_helper.dart';
import 'package:pos_app/features/categories/data/model/category_model.dart';
import 'package:thermal_printer/thermal_printer.dart';

import '../../manager/printer_data_cubit/printer_data_cubit.dart';

class PrinterModel {
  String? printerType;
  String? printerName;
  String? communicationType;
  String? vendor;
  String? product;
  String? address;
  String? isble;
  String? port;
  String? ipAccress;
  bool? automatic;
  String? printReceiptCount;
  String? updatedAt;
  String? createdAt;
  int? id;
  List<CategoryModel>? categories;
  DiscoveredPrinter? discoveredPrinter;

  PrinterModel(
      {this.printerType,
      this.printerName,
      this.communicationType,
      this.vendor,
      this.product,
      this.address,
      this.isble,
      this.port,
      this.ipAccress,
      this.automatic,
      this.printReceiptCount,
      this.updatedAt,
      this.createdAt,
      this.id,
      this.categories,
      this.discoveredPrinter,
      });

  PrinterModel.fromJson(Map<String, dynamic> json) {
    printerType = json['printer_type'];
    printerName = json['printer_name'];
    communicationType = json['communication_type'];

    switch (json['communication_type']) {
      case 'usb':
        discoveredPrinter = DiscoveredPrinter(
          device: PrinterDevice(
            name: json['printer_type']??'',
            vendorId: json['vendor'],
            productId: json['product'],
          ),
          type: PrinterType.usb,
          isBle: json['isble'] == '1' ? true : false,
        );
        case 'bluetooth':
        discoveredPrinter = DiscoveredPrinter(
          device: PrinterDevice(
            name: json['printer_type']??'',
            address: json['address'],
          ),
          type: PrinterType.bluetooth,
          isBle: json['isble'] == '1' ? true : false,
        );
        case 'wifi':
        discoveredPrinter = DiscoveredPrinter(
          device: PrinterDevice(
            name: json['printer_type']??'',
            address: json['ip_accress'],
          ),
          type: PrinterType.network,
          isBle: json['isble'] == '1' ? true : false,
        );
    }
    vendor = json['vendor'];
    product = json['product'];
    address = json['address'];
    isble = json['isble'];
    port = json['port'];
    ipAccress = json['ip_accress'];
    automatic = json['automatic']=='1'?true:false;
    printReceiptCount = json['print_receipt_count'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
    if (json['categories'] != null) {
      categories = <CategoryModel>[];
      json['categories'].forEach((v) {
        categories!.add(new CategoryModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson(List<CategoryRowsModel> categoryRows) {
    Map<String, dynamic> discoverdPrinerData ={};
    if(discoveredPrinter != null){
      switch (discoveredPrinter!.type) {
        case PrinterType.usb:
          discoverdPrinerData = {
            'printer_type': discoveredPrinter?.device.name.trim(),
            'vendor': discoveredPrinter?.device.vendorId?.trim(),
            'product': discoveredPrinter?.device.productId?.trim(),
            'communication_type': 'usb',
          };
        case PrinterType.bluetooth:
          discoverdPrinerData = {
            'printer_type': discoveredPrinter?.device.name.trim(),
            'address': discoveredPrinter?.device.address?.trim(),
            'isble': discoveredPrinter?.isBle==true ? '1' : '0',
            'communication_type': 'bluetooth',
          };
        case PrinterType.network:
          discoverdPrinerData = {
            'ip_accress': discoveredPrinter?.device.address?.trim(),
            'communication_type': 'wifi',
          };
      }
    }
    Map<String, dynamic> categoryRowsData ={};
    for(int i=0;i<categoryRows.length;i++){
      categoryRowsData['categories[$i][id]'] = categoryRows[i].category?.id;
      categoryRowsData['categories[$i][print_receipt_count]'] = categoryRows[i].copiesCount.text;
    }

    final Map<String, dynamic> data = {
      'printer_name': printerName?.trim(),
      'automatic': automatic == true ? '1' : '0',
      'print_receipt_count': '2',
      ...discoverdPrinerData,
      ...categoryRowsData
    };
    return data;
  }
}
