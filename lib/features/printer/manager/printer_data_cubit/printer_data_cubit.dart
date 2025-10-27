import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/helper/printer_helper.dart';
import 'package:pos_app/features/categories/data/model/category_model.dart';
import 'package:pos_app/features/printer/data/model/printer_model.dart';
import 'package:pos_app/features/printer/data/repo/printer_repo.dart';

import 'printer_data_state.dart';
class CategoryRowsModel {
  CategoryModel? category;
  final TextEditingController copiesCount;

  CategoryRowsModel({this.category, required this.copiesCount});
}
class PrinterDataCubit extends Cubit<PrinterDataState>{
  PrinterDataCubit(this._repo, {required this.printer}) : super(PrinterDataInitialState());
  static PrinterDataCubit get(context) => BlocProvider.of(context);
  final PrinterRepo _repo;
  final DiscoveredPrinter printer;


  bool automatic = false;
  void toggleAutomatic(bool value) {
    automatic = value;
    emit(PrinterDataToggleSwitchState());
  }
  bool printReceipt = false;
  void togglePrintReceipt(bool value) {
    printReceipt = value;
    emit(PrinterDataToggleSwitchState());
  }
  var receiptCopies = TextEditingController(); 
  var printerName = TextEditingController();
  var formKey = GlobalKey<FormState>();

  bool printCategories = false;
  void togglePrintCategories(bool value) {
    printCategories = value;
    if (value) {
      categoryRows.add(CategoryRowsModel(copiesCount: TextEditingController()));
    }
    else {
      categoryRows.clear();
    }
    emit(PrinterDataToggleSwitchState());
  }
  List<CategoryRowsModel> categoryRows = [];
  void assignCategories({required CategoryModel model, required int index}) {
    categoryRows[index].category = CategoryModel.copyWith(model); // call by vlaue
    emit(PrinterDataCategoryChanged());
  }

  void removeCategoryRow(int index) {
    if (categoryRows.length > 1) {
      categoryRows.removeAt(index);
      emit(PrinterDataCategoryChanged());
    }
  }


void savePrinter()async{
  if(!formKey.currentState!.validate())return;
  emit(PrinterDataLoadingState());
  var result = await _repo.addPrinter(
    printer: PrinterModel(
      discoveredPrinter: printer,
      automatic: automatic,
      printReceiptCount: printReceipt ? receiptCopies.text : null,
      printerName: printerName.text,
    ), categoryRows: categoryRows);

  result.fold((l) => emit(PrinterDataErrorState(errMessage: l)), (r) => emit(PrinterDataSuccessState()));
}


}