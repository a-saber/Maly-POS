

import 'package:pos_app/features/printer/data/model/post_printers_model.dart';

abstract class AddPrinterState {}

class AddPrinterInitial extends AddPrinterState {}

class AddPrinterLoading extends AddPrinterState {}

class AddPrinterSuccess extends AddPrinterState {
  final AddPrinters addPrinter;
  AddPrinterSuccess({required this.addPrinter});
}

class AddPrinterFail extends AddPrinterState {
  final String errMessage;
  AddPrinterFail({required this.errMessage});
}

class AddPrinterUnValidate extends AddPrinterState {}

class AddPrinterChangeCategories extends AddPrinterState {}
