
import 'package:pos_app/core/api/api_response.dart';

abstract class DeletePrinterState {}

final class DeletePrinterInitial extends DeletePrinterState {}

final class DeletePrinterLoading extends DeletePrinterState {}

final class DeletePrinterSuccess extends DeletePrinterState {
  final int id;
  DeletePrinterSuccess({required this.id});
}

final class DeletePrinterFailing extends DeletePrinterState {
  final ApiResponse errMessage;
  DeletePrinterFailing({required this.errMessage});
}
