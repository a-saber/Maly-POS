import 'package:pos_app/core/api/api_response.dart';

import '../repo/selling_point_repo.dart';

class PrintModel {
  final ApiResponse apiResponse;
  final String branchName;
  final double paid;
  List<ProductsPrinters> productsPrinters = [];

  PrintModel(
      {required this.apiResponse,
      required this.branchName,
      required this.paid,
      required this.productsPrinters});
}
