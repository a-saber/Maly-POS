import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/features/printer/data/model/printers_search_model.dart';
import 'package:pos_app/features/printer/data/repo/printer_repo.dart';
import 'package:pos_app/features/printer/manager/delete_printer/delete_printer_state.dart';

class DeletePrinterCubit extends Cubit<DeletePrinterState> {
  DeletePrinterCubit(this.repo) : super(DeletePrinterInitial());

  static DeletePrinterCubit get(BuildContext context) => BlocProvider.of(context);

  final PrinterRepo repo;

  Future<void> deletePrinter({required Data printer}) async {
    emit(DeletePrinterLoading());
    final response = await repo.deletePrinter(
     id: printer.id!,
    );
    response.fold(
      (error) => emit(DeletePrinterFailing(errMessage: error)),
      (id) => emit(DeletePrinterSuccess(id: id)),
    );
  }
}
