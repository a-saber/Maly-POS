import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/helper/printer_helper.dart';
import 'package:pos_app/features/printer/manager/scan_local_printers_cubit/scan_local_printers_state.dart';

class ScanLocalPrintersCubit extends Cubit<ScanLocalPrintersState> {
  ScanLocalPrintersCubit( ) : super(ScanLocalPrintersInitial());
  static ScanLocalPrintersCubit get(context) => BlocProvider.of(context);
  
void getDiscoveredPrinters()async{
  emit(ScanLocalPrintersLoading());
  try{
    final PrinterHelper _helper = PrinterHelper();
    await _helper.startScan(
      onUpdate: () {
        emit(ScanLocalPrintersSuccess( _helper.discoveredDevices.values.toList()));
      },
    );
  }
  catch (e){
    emit(ScanLocalPrintersFailure('something went wrong'));
  }
}
}