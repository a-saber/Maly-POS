import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:pos_app/features/printer/manager/details_printer/printer_details_state.dart';

import '../../../categories/data/model/category_model.dart';

class CategoryRows
{
  CategoryModel? category;
  TextEditingController? copiesCount;

  CategoryRows({this.category, this.copiesCount});
}
class PrinterDetailsCubit extends Cubit<PrinterDetailsState> {
  PrinterDetailsCubit() : super(PrinterDetailsInitial());

  static PrinterDetailsCubit get(BuildContext context) =>
      BlocProvider.of<PrinterDetailsCubit>(context);
  final List<CategoryModel> categories = [];
  final List<CategoryRows> categoryRows = [];
  CategoryModel? category;

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
  categoryRows.add(CategoryRows(
    category: null,
    copiesCount: TextEditingController(text: '1'),
  ));
  emit(PrinterDetailsUpdated());
}

void removeCategoryRow(int index) {
  if (categoryRows.length > 1) {
    categoryRows.removeAt(index);
    emit(PrinterDetailsUpdated());
  }
}

 void onChangeCategory(CategoryModel? newCategory) {
    if (category?.id != newCategory?.id) {
      category = newCategory;
      emit(AddChangeCategory());
    }
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
