// add_printer_cubit.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/features/printer/data/model/post_printers_model.dart';
import 'package:pos_app/features/printer/data/repo/printer_repo.dart';
import 'add_printers_state.dart';

class AddPrinterCubit extends Cubit<AddPrinterState> {
  AddPrinterCubit(this.repo) : super(AddPrinterInitial());
  static AddPrinterCubit get(context) => BlocProvider.of<AddPrinterCubit>(context);
  
  final PrinterRepo repo;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  final TextEditingController printerNameController = TextEditingController();
  final TextEditingController printerTypeController = TextEditingController();
  final TextEditingController communicationTypeController = TextEditingController();

  List<int> selectedCategoryIds = [];

  void onChangeCategories(List<int> newIds) {
    selectedCategoryIds = newIds;
    emit(AddPrinterChangeCategories());
  }

  Future<void> addPrinter(BuildContext context) async {
    emit(AddPrinterLoading());

    final formState = formKey.currentState;
    if (formState == null) {
      emit(AddPrinterFail(errMessage: "Form not initialized"));
      return;
    }

    if (!formState.validate()) {
      autovalidateMode = AutovalidateMode.always;
      emit(AddPrinterUnValidate());
      return;
    }

    if (selectedCategoryIds.isEmpty) {
      emit(AddPrinterFail(errMessage: "At least one category must be selected"));
      return;
    }

    final printer = AddPrinters(
      printer: Printer(
        printerName: printerNameController.text.trim(),
        printerType: printerTypeController.text.trim(),
        communicationType: communicationTypeController.text.trim(),
        categories: selectedCategoryIds.map((id) => {"category_id": id}).toList(),
      ),
    );

    final Either<ApiResponse, AddPrinters> response = await repo.addPrinter(printer: printer);

    response.fold(
      (error) {
        emit(AddPrinterFail(errMessage: error.message ?? "Unknown error"));
        debugPrint('Add Printer Error: ${error.message}');
      },
      (result) async{
        emit(AddPrinterSuccess(addPrinter: result));
        debugPrint('Added Printer: ${result.printer?.printerName}');
        debugPrint('Categories: ${result.printer?.categories}');
      },
    );
  }

  @override
  Future<void> close() {
    printerNameController.dispose();
    printerTypeController.dispose();
    communicationTypeController.dispose();
    return super.close();
  }
}
