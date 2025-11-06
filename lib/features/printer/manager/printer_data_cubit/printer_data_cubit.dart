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
  PrinterDataCubit(this._repo, { this.discoveredPrinter, this.printerModel}) : super(PrinterDataInitialState())
  {
    if(printerModel != null) {
      automatic = printerModel!.automatic??false;
      receiptCopies.text = printerModel!.printReceiptCount != null? printerModel!.printReceiptCount.toString() : '0';
      printerName.text = printerModel!.printerName??'';
      printCategories = printerModel!.categories?.isNotEmpty == true? true : false;
      if(printCategories)
      {
        categoryRows = printerModel!.categories!.map((e) => CategoryRowsModel(category: e, copiesCount: TextEditingController(
          text: e.pivot?.printReceiptCount != null? e.pivot!.printReceiptCount.toString() : '0'
        ))).toList();
      }

    }
  }
  static PrinterDataCubit get(context) => BlocProvider.of(context);
  final PrinterRepo _repo;
  final DiscoveredPrinter? discoveredPrinter;
  final PrinterModel? printerModel;


  bool automatic = false;
  void toggleAutomatic(bool value) {
    automatic = value;
    emit(PrinterDataToggleSwitchState());
  }
  bool printReceipt = false;
  var receiptCopies = TextEditingController(); 
  var printerName = TextEditingController();
  var printReceiptController= TextEditingController();
  final ipController = TextEditingController();
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
  void addCategoryRow() {
    categoryRows.add(CategoryRowsModel(copiesCount: TextEditingController()));
    emit(PrinterDataCategoryChanged());
  }
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
  final List<String> paperSizes = ["80mm", "58mm", "72mm"];
  String paperSize = "80mm";
void changePaperSize(String? value) {
  if(value == null) return;
  paperSize = value;
  emit(PrinterDetailsUpdatedState());
}



  void addPrinter()async{
    if(!formKey.currentState!.validate())return;
    emit(PrinterDataLoadingState());
    var result = await _repo.addPrinter( printer:PrinterModel(
      discoveredPrinter: discoveredPrinter,
      automatic: automatic,
      printReceiptCount: int.tryParse(printReceiptController.text),
      printerName: printerName.text,
    ), categoryRows: categoryRows);

    result.fold((l) => emit(PrinterDataErrorState(errMessage: l)), (r) => emit(PrinterDataSuccessState()));
  }
  void editPrinter()async{
    if(printerModel != null) {
      if (!formKey.currentState!.validate()) return;
      emit(PrinterDataLoadingState());
      printerModel?.automatic = automatic;
      printerModel?.printReceiptCount = int.tryParse(printReceiptController.text);
      printerModel?.printerName = printerName.text;
      var result = await _repo.updatePrinter(
          printer: printerModel!, categoryRows: categoryRows);

      result.fold((l) => emit(PrinterDataErrorState(errMessage: l)),
          (r) => emit(PrinterDataSuccessState()));
    }
  }


}