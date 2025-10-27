// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter/material.dart';
// import 'package:pos_app/features/printer/data/repo/printer_repo.dart';
// import 'printer_details_state.dart';
// import '../../../categories/data/model/category_model.dart';
// import '../../data/model/post_printers_model.dart';
// import '../../manager/edit_printers/edit_printers_cubit.dart';

// class CategoryRows {
//   CategoryModel? category;
//   final TextEditingController copiesCount;

//   CategoryRows({this.category, required this.copiesCount});
// }

// class PrinterDetailsCubit extends Cubit<PrinterDetailsState> {
//   PrinterDetailsCubit(this._repo) : super(PrinterDetailsInitial());
//   final PrinterRepo _repo;

//   static PrinterDetailsCubit get(BuildContext context) =>
//       BlocProvider.of(context);


//   bool automatic = false;
//   bool printReceipt = false;
//   int receiptCopies = 1; 

//   bool printCategories = false;
//   List<CategoryRows> categoryRows = [];
  

//   void init() {
//     if (categoryRows.isEmpty) addCategoryRow();
//   }

//   void loadPrinterSettingsFromEdit(EditPrinterCubit editCubit) {
//     categoryRows.clear();

//     automatic = editCubit.printerData?.automatic?.toString() == "1";
//     printReceipt = editCubit.printerData?.printReceiptCount != null &&
//         editCubit.printerData!.printReceiptCount! > 0;
//     printCategories = editCubit.selectedCategories.isNotEmpty;
//     receiptCopies = editCubit.printerData?.printReceiptCount ?? 1;

//     for (var cat in editCubit.selectedCategories) {
//       categoryRows.add(CategoryRows(
//         category: CategoryModel(
//           id: cat.id,
//           name: cat.name,
//           description: cat.description,
//           imagePath: cat.imagePath,
//           createdAt: cat.createdAt,
//           updatedAt: cat.updatedAt,
//           imageUrl: cat.imageUrl,
//         ),
//         initialCopies: cat.pivot?.printReceiptCount ?? 1,
//         isSelected: true,
//       ));
//     }

//     emit(PrinterDetailsUpdated());
//   }

//   void toggleAutomatic(bool value) {
//     automatic = value;
//     emit(PrinterDetailsUpdated());
//   }

//   void togglePrintReceipt(bool value) {
//     printReceipt = value;
//     emit(PrinterDetailsUpdated());
//   }

//   void togglePrintCategories(bool value) {
//     printCategories = value;
//     emit(PrinterDetailsUpdated());
//   }

//   void addCategoryRow() {
//     final lastRow = categoryRows.isNotEmpty ? categoryRows.last : null;
//     categoryRows.add(
//       CategoryRows(
//         initialCopies:
//             lastRow != null ? int.tryParse(lastRow.copiesCount.text) ?? 1 : 1,
//         isSelected: lastRow?.isSelected ?? false,
//       ),
//     );
//     emit(PrinterDetailsUpdated());
//   }

//   void removeCategoryRow(int index) {
//     if (categoryRows.length > 1) {
//       categoryRows.removeAt(index);
//       emit(PrinterDetailsUpdated());
//     }
//   }

//   void incrementCopies(TextEditingController controller) {
//     final current = int.tryParse(controller.text) ?? 1;
//     controller.text = (current + 1).toString();
//     emit(PrinterDetailsUpdated());
//   }

//   void decrementCopies(TextEditingController controller) {
//     final current = int.tryParse(controller.text) ?? 1;
//     if (current > 1) {
//       controller.text = (current - 1).toString();
//       emit(PrinterDetailsUpdated());
//     }
//   }

//   List<int> getSelectedCategoryIds() {
//     return categoryRows
//         .where((row) => row.category != null && row.isSelected)
//         .map((row) => row.category!.id!)
//         .toList();
//   }
//   List<Categories> getSelectedCategoriesForApi() {
//     return categoryRows
//         .where((row) => row.category != null && row.isSelected)
//         .map((row) => Categories(
//               id: row.category!.id,
//               pivot: Pivot(
//                 categoryId: row.category!.id!,
//                 printerId: 0, 
//                 printReceiptCount:
//                     int.tryParse(row.copiesCount.text) ?? 1,
//               ),
//             ))
//         .toList();
//   }

//   void onChangeCategory(CategoryModel? value) {
//     emit(PrinterDetailsUpdated());
//   }

//   void toggleCategorySelection(int index, bool value) {
//     categoryRows[index].isSelected = value;
//     emit(PrinterDetailsUpdated());
//   }
// }
