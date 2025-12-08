import 'dart:typed_data';

import 'package:pos_app/core/api/api_response.dart';

class PrintModel {
  final ApiResponse apiResponse;
  final String branchName;
  final double paid;
  final Uint8List? madaReceipt ;

  PrintModel(
      {required this.apiResponse,
      required this.branchName,
      required this.paid,
        required this.madaReceipt
      });
}
