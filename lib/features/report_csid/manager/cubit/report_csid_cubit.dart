
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/features/report_csid/manager/cubit/rebort_csid_state.dart';

import '../../../../core/helper/formate_date_time.dart';
import '../../data/report_scid_repo.dart';


class ReportScidCubit extends Cubit<ReportScidState> {
  ReportScidCubit(this.repo) : super(ReportScidInitial());

  static ReportScidCubit get(context) => BlocProvider.of(context);
  final ReportScidRepo repo;
  CsidType? csidType;
  void changeCsidType({required CsidType type}) {
    csidType = type;
    emit(ReportScidSelectInvoiceType());

  }
  void onTapGenerate() {
    serialNumberController.text='1-Engazat|2-Version3.0.2|3-7c12700e-9755-48c-9622-a43806a0a4e7';
  }
  void setFromDate(DateTime date){
    fromDateController.text= formatedmy(date);
    emit(ReportScidSelectDate());
  }
  void setToDate(DateTime date){
    toDateController.text=formatedmy(date);
    emit(ReportScidSelectDate());

  }

  late TextEditingController fromDateController,
      toDateController,
      addressController,
      commonNameController,
      taxNoController,
      organizationNameController,
      organizationUnitNameController,
      countryNameController,
      industryController,
      locationController,
      serialNumberController,
      csrController,
      privateKeyController,
      secretKeyController,
      publicKeyController;



  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late AutovalidateMode autovalidateMode;

  void init() async {
    fromDateController = TextEditingController();
    addressController = TextEditingController();
    toDateController = TextEditingController();
    commonNameController = TextEditingController();
    taxNoController = TextEditingController();
    organizationNameController = TextEditingController();
    organizationUnitNameController = TextEditingController();
    countryNameController = TextEditingController(text: 'SA');
    industryController = TextEditingController();
    locationController = TextEditingController();
    serialNumberController = TextEditingController();
    csrController = TextEditingController();
    privateKeyController = TextEditingController();
    secretKeyController = TextEditingController();
    publicKeyController = TextEditingController();

    autovalidateMode = AutovalidateMode.disabled;

  }




  final List<String> userNames = ["admin", "mahmoud", "ahmed"];
  String? userName;
  void changePaperSize(String? value) {
    if (value == null) return;
    userName = value;
   // emit(ScidGenerationSelectUserName());
  }
  final List<String> invoiceTypes = ["Simplified Invoices الفواتير المبسطة", "Standard Invoices الفواتير الضريبية", "Standard & Simplified"];
  String? invoiceType;
  void changeInvoiceType(String? value) {
    if (value == null) return;
    invoiceType = value;
   // emit(ScidGenerationSelectInvoiceType());
  }


  @override
  Future<void> close() {
    fromDateController.dispose();
    addressController.dispose();
    toDateController.dispose();
    commonNameController.dispose();
    taxNoController.dispose();
    organizationNameController.dispose();
    organizationUnitNameController.dispose();
    countryNameController.dispose();
    industryController.dispose();
    locationController.dispose();
    serialNumberController.dispose();
    csrController.dispose();
    privateKeyController.dispose();
    secretKeyController.dispose();
    publicKeyController.dispose();

    return super.close();
  }
}
enum CsidType { all, withInvoices, withoutInvoices }