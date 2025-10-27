// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:pos_app/features/printer/data/model/update_printers_model.dart';
// import 'package:pos_app/features/printer/data/model/printers_search_model.dart' hide Pivot;
// import 'package:pos_app/features/printer/data/repo/printer_repo.dart';
// import 'package:pos_app/features/printer/manager/edit_printers/edit_printers_state.dart';

// class EditPrinterCubit extends Cubit<EditPrinterState> {
//   final PrinterRepo repo;
//   EditPrinterCubit(this.repo) : super(EditPrinterInitial());

//   static EditPrinterCubit get(BuildContext context) =>
//       BlocProvider.of(context);
//   final formKey = GlobalKey<FormState>();
//   AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
//   final TextEditingController printerNameController = TextEditingController();
//   final TextEditingController printerTypeController = TextEditingController();
//   final TextEditingController communicationTypeController = TextEditingController();
//   final TextEditingController portController = TextEditingController();
//   final TextEditingController ipAddressController = TextEditingController();
//   final TextEditingController printReceiptCountController = TextEditingController(text: "1");

//   List<Categories> selectedCategories = [];
//   Data? printerData; // model from PrintersModel
//  void initPrinter(Data printer) {
//   printerData = printer;

//   printerNameController.text = printer.printerName ?? '';
//   printerTypeController.text = printer.printerType ?? '';
//   communicationTypeController.text = printer.communicationType ?? '';
//   portController.text = printer.port ?? '';
//   ipAddressController.text = printer.ipAccress ?? '';
//   printReceiptCountController.text = printer.printReceiptCount?.toString() ?? '1';
//   selectedCategories = (printer.categories ?? []).map((cat) {
//     return Categoriess(
//       id: cat.id,
//       name: cat.name,
//       pivot: Pivot(
//         printerId: printer.id,
//         categoryId: cat.id,
//         printReceiptCount: cat.pivot?.printReceiptCount ?? 0,
//       ),
//     );
//   }).toList();

//   emit(EditPrinterSuccess());
// }

//   void onChangeCategories(List<Categoriess> newCategories) {
//     selectedCategories = newCategories;
//     emit(EditPrinterSuccess());
//   }

//   Future<void> updatePrinter(BuildContext context) async {
//     if (!formKey.currentState!.validate()) {
//       autovalidateMode = AutovalidateMode.always;
//       emit(EditPrinterValidationFailed());
//       return;
//     }

//     if (printerData == null) {
//       emit(EditPrinterError("Printer data not loaded"));
//       return;
//     }

//     emit(EditPrinterLoading());
//     final updatedPrinter = Printerss(
//       id: printerData!.id,
//       printerName: printerNameController.text.trim(),
//       printerType: printerTypeController.text.trim(),
//       communicationType: communicationTypeController.text.trim(),
//       port: portController.text.trim(),
//       ipAccress: ipAddressController.text.trim(),
//       printReceiptCount: printReceiptCountController.text.trim(),
//       categories: selectedCategories.map((c) {
//         return Categoriess(
//           id: c.id,
//           name: c.name,
//           pivot: Pivot(
//             printerId: printerData!.id,
//             categoryId: c.id,
//             printReceiptCount:
//                 int.tryParse(printReceiptCountController.text) ?? 1,
//           ),
//         );
//       }).toList(),
//     );

//     final result = await repo.updatePrinter(
//       id: printerData!.id!,
//       printer: updatedPrinter,
//     );

//     result.fold(
//       (error) => emit(EditPrinterError(error.message ?? "Unknown error")),
//       (_) => emit(EditPrinterSuccess()),
//     );
//   }
//   @override
//   Future<void> close() {
//     printerNameController.dispose();
//     printerTypeController.dispose();
//     communicationTypeController.dispose();
//     portController.dispose();
//     ipAddressController.dispose();
//     printReceiptCountController.dispose();
//     return super.close();
//   }
// }
