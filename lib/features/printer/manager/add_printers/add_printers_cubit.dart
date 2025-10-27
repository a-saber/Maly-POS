// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:dartz/dartz.dart';
// import 'package:pos_app/core/api/api_response.dart';
// import 'package:pos_app/features/printer/data/model/post_printers_model.dart';
// import 'package:pos_app/features/printer/data/repo/printer_repo.dart';
// import 'add_printers_state.dart';

// class AddPrinterCubit extends Cubit<AddPrinterState> {
//   AddPrinterCubit(this._repo) : super(AddPrinterInitial());
//   static AddPrinterCubit get(context) => BlocProvider.of(context);
//   final PrinterRepo _repo;

//   final GlobalKey<FormState> formKey = GlobalKey<FormState>();
//   AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

//   var printerNameController = TextEditingController();
//   var printerTypeController = TextEditingController();
//   var communicationTypeController = TextEditingController();
//   List<int> selectedCategoryIds = [];

//   void onChangeCategories(List<int> newIds) {
//     selectedCategoryIds = newIds;
//     emit(AddPrinterChangeCategories());
//   }
//   Future<void> addPrinterWithCategories(
//     BuildContext context,
//     List<Categories> categories,
//     bool automatic,
//     bool printReceipt,
//     int printerCopies,
//   ) async {
//     emit(AddPrinterLoading());

//     final formState = formKey.currentState;
//     if (formState == null) {
//       emit(AddPrinterFail(errMessage: "Form not initialized"));
//       return;
//     }

//     if (!formState.validate()) {
//       autovalidateMode = AutovalidateMode.always;
//       emit(AddPrinterUnValidate());
//       return;
//     }
//     final updatedCategories = categories.map((c) {
//       final copies = int.tryParse(c.pivot?.printReceiptCount.toString() ?? '1') ?? 1;
//       return Categories(
//         id: c.id,
//         pivot: Pivot(
//           categoryId: c.id,
//           printerId: 0, 
//           printReceiptCount: copies,
//         ),
//       );
//     }).toList();
//     final printer = AddPrinterResponseModel(
//       printer: Printer(
//         printerName: printerNameController.text.trim(),
//         printerType: printerTypeController.text.trim(),
//         communicationType: communicationTypeController.text.trim(),
//         automatic: automatic ? "1" : "0",
//         printReceiptCount: printReceipt ? "1" : "0",
//         categories: updatedCategories,
//       ),
//     );

//     debugPrint('Printer Data (to send to API): ${printer.toJson()}');

//     final Either<ApiResponse, AddPrinterResponseModel> response =
//         await _repo.addPrinter(printer: printer);

//     response.fold(
//       (error) {
//         emit(AddPrinterFail(errMessage: error.message ?? "Unknown error"));
//         debugPrint('Add Printer Error: ${error.message}');
//       },
//       (result) {
//         emit(AddPrinterSuccess(addPrinter: result));
//         debugPrint('Added Printer: ${result.printer?.printerName}');
//         debugPrint('Categories: ${result.printer?.categories}');
//       },
//     );
//   }

//   @override
//   Future<void> close() {
//     printerNameController.dispose();
//     printerTypeController.dispose();
//     communicationTypeController.dispose();
//     return super.close();
//   }
// }
