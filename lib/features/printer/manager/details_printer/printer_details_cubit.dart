import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:pos_app/features/printer/manager/details_printer/printer_details_state.dart';


class PrinterDetailsCubit extends Cubit<PrinterDetailsState> {
  PrinterDetailsCubit() : super(PrinterDetailsInitial());

  static PrinterDetailsCubit get(BuildContext context) =>
      BlocProvider.of<PrinterDetailsCubit>(context);

  final List<String> categories = ['cat1', 'cat2', 'cat3', 'cat4'];
  final List<Map<String, dynamic>> categoryRows = [];

  bool automatic = false;
  bool printReceipt = false;
  bool printCategories = false;

  void init() {
    if (categoryRows.isEmpty) {
      addCategoryRow();
    }
  }

  void toggleAutomatic(bool value) {
    automatic = value;
    emit(PrinterDetailsUpdated());
  }

  void togglePrintReceipt(bool value) {
    printReceipt = value;
    emit(PrinterDetailsUpdated());
  }

  void togglePrintCategories(bool value) {
    printCategories = value;
    emit(PrinterDetailsUpdated());
  }

  void addCategoryRow() {
    categoryRows.add({
      'category': null,
      'copiesController': TextEditingController(text: '1'),
    });
    emit(PrinterDetailsUpdated());
  }

  void removeCategoryRow(int index) {
    if (categoryRows.length > 1) {
      categoryRows.removeAt(index);
      emit(PrinterDetailsUpdated());
    }
  }

  void updateCategory(int index, String? value) {
    categoryRows[index]['category'] = value;
    emit(PrinterDetailsUpdated());
  }

  void incrementCopies(TextEditingController controller) {
    final current = int.tryParse(controller.text) ?? 1;
    controller.text = (current + 1).toString();
    emit(PrinterDetailsUpdated());
  }

  void decrementCopies(TextEditingController controller) {
    final current = int.tryParse(controller.text) ?? 1;
    if (current > 1) {
      controller.text = (current - 1).toString();
      emit(PrinterDetailsUpdated());
    }
  }
}
