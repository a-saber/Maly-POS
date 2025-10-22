import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'printer_details_state.dart';
import '../../../categories/data/model/category_model.dart';

class CategoryRows {
  CategoryModel? category;
  TextEditingController copiesCount;

  CategoryRows({this.category, String? initialCopies})
      : copiesCount = TextEditingController(text: initialCopies ?? '1');
}

class PrinterDetailsCubit extends Cubit<PrinterDetailsState> {
  PrinterDetailsCubit() : super(PrinterDetailsInitial());

  static PrinterDetailsCubit get(BuildContext context) =>
      BlocProvider.of<PrinterDetailsCubit>(context);

  final List<CategoryRows> categoryRows = [];
  bool automatic = false;
  bool printReceipt = false;
  bool printCategories = false;

  void init() {
    if (categoryRows.isEmpty) addCategoryRow();
  }
void initWithSelectedCategories(
  List<CategoryModel> allCategories,
  List<int> selectedIds,
) {
  categoryRows.clear();

  for (final id in selectedIds) {
    final category = allCategories.firstWhere(
      (cat) => cat.id == id,
      orElse: () => allCategories.first,
    );

    categoryRows.add(CategoryRows(category: category));
  }

  if (selectedIds.isNotEmpty) {
    printCategories = true;
  }

  emit(PrinterDetailsUpdated());
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
    categoryRows.add(CategoryRows());
    emit(PrinterDetailsUpdated());
  }

  void removeCategoryRow(int index) {
    if (categoryRows.length > 1) {
      categoryRows.removeAt(index);
      emit(PrinterDetailsUpdated());
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

  List<int> getSelectedCategoryIds() {
    return categoryRows
        .where((row) => row.category != null)
        .map((row) => row.category!.id!)
        .toList();
  }

  List<Map<String, dynamic>> getSelectedCategoriesWithCopies() {
    return categoryRows
        .where((row) => row.category != null)
        .map((row) => {
              'id': row.category!.id,
              'copies_count': int.tryParse(row.copiesCount.text) ?? 1,
            })
        .toList();
  }

  void onChangeCategory(CategoryModel? value) {
    emit(PrinterDetailsUpdated());
  }
}
