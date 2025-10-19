abstract class EditPrinterState {}

class EditPrinterInitial extends EditPrinterState {}

class EditPrinterLoading extends EditPrinterState {}

class EditPrinterSuccess extends EditPrinterState {}

class EditPrinterError extends EditPrinterState {
  final String message;
  EditPrinterError(this.message);
}

class EditPrinterValidationFailed extends EditPrinterState {}
