import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/features/printer/data/model/printer_model.dart';

class PrintModel {
  final ApiResponse apiResponse;
  final String branchName;
  final double paid;
  List<PrinterModel> printers = [];

  PrintModel(
      {required this.apiResponse,
      required this.branchName,
      required this.paid,
      required this.printers});
}
