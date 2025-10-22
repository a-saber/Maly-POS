import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/features/printer/data/model/printers_search_model.dart';
import 'package:pos_app/features/printer/data/repo/printer_repo.dart';
import 'package:pos_app/features/printer/manager/edit_printers/edit_printers_state.dart';

class EditPrinterCubit extends Cubit<EditPrinterState> {
  final PrinterRepo repo;
  EditPrinterCubit(this.repo) : super(EditPrinterInitial());

  static EditPrinterCubit get(BuildContext context) =>
      BlocProvider.of(context);

  final formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  final TextEditingController printerNameController = TextEditingController();

  List<int> selectedCategoryIds = [];
  dynamic printerData;

 void initPrinter(Data printer) {
  printerData = printer;
  printerNameController.text = printer.printerName ?? '';
  if (printer.categories != null && printer.categories!.isNotEmpty) {
    selectedCategoryIds = printer.categories!
        .map((cat) => cat.id ?? cat.id ?? 0)
        .where((id) => id != 0)
        .toList();
  } else {
    selectedCategoryIds = [];
  }
  emit(EditPrinterSuccess());
}



  void onChangeCategories(List<int> ids) {
    selectedCategoryIds = ids;
  }
Future<void> updatePrinter(BuildContext context) async {
  if (!formKey.currentState!.validate()) {
    autovalidateMode = AutovalidateMode.always;
    emit(EditPrinterValidationFailed());
    return;
  }

  emit(EditPrinterLoading());
  final result = await repo.updatePrinter(
    id: printerData.id!,
    printerName: printerNameController.text,
    categoryIds: selectedCategoryIds,
  );

  result.fold(
    (error) => emit(EditPrinterError(error.message ?? "Unknown error")),
    (_) => emit(EditPrinterSuccess()),
  );
}

}
