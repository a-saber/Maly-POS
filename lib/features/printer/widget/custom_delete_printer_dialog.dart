import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/core/helper/my_service_locator.dart';
import 'package:pos_app/core/widget/show_delete_confirm_dialog.dart';
import 'package:pos_app/features/printer/data/model/printer_model.dart';
import 'package:pos_app/features/printer/data/repo/printer_repo.dart';
import 'package:pos_app/features/printer/manager/delete_printer/delete_printer_cubit.dart';
import 'package:pos_app/features/printer/manager/delete_printer/delete_printer_state.dart';
import 'package:pos_app/features/printer/manager/scan_printer/scan_printer_cubit.dart';
import 'package:pos_app/generated/l10n.dart';

Future<bool?> showDeletePrinterConfirmDialog({
  required BuildContext context,
  required PrinterModel printer,
  bool goBack = false,
}) async {
  return await showDeleteConfirmationDialog(
    context: context,
    title: S.of(context).deletePrinter, 
    content: printer.printerName ?? S.of(context).noName,
    deleteButtonBuilder: (ctx, button, loading) => BlocProvider(
      create: (context) =>
          DeletePrinterCubit(MyServiceLocator.getSingleton<PrinterRepo>()),
      child: BlocConsumer<DeletePrinterCubit, DeletePrinterState>(
        listener: (context, state) {
          if (state is DeletePrinterSuccess) {
            deleteConfirmationDialogSuccess(ctx);
            MyServiceLocator.getSingleton<ScanPrintersCubit>()
                .removePrinter(state.id);
            if (goBack) {
              Navigator.pop(context);
            }
          } else if (state is DeletePrinterFailing) {
            if (context.mounted) {
              deleteConfirmationDialogError(
                ctx,
                mapStatusCodeToMessage(context, state.errMessage),
              );
            }
          }
        },
        builder: (context, state) {
          if (state is DeletePrinterLoading) {
            return loading;
          }
          return button(
            context: context,
            onPressed: () =>
                DeletePrinterCubit.get(context).deletePrinter(printer: printer),
          );
        },
      ),
    ),
  );
}
