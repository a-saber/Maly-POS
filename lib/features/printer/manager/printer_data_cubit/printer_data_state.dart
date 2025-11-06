import 'package:pos_app/core/api/api_response.dart';

abstract class PrinterDataState {}

class PrinterDataInitialState extends PrinterDataState {}

class PrinterDataLoadingState extends PrinterDataState {}

class PrinterDataSuccessState extends PrinterDataState {}

class PrinterDataErrorState extends PrinterDataState {
  final ApiResponse errMessage;
  PrinterDataErrorState({required this.errMessage});
}

class PrinterDataEmptyState extends PrinterDataState {}

class PrinterDataToggleSwitchState extends PrinterDataState {}

class PrinterDataCategoryChanged extends PrinterDataState {}
class PrinterDetailsUpdatedState extends PrinterDataState {}
