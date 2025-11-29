import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/features/shop_setting/data/repo/shop_setting_repo.dart';

import '../../data/repo/csid_generation_repo.dart';

part 'csid_generation_setting_state.dart';

class ScidGenerationCubit extends Cubit<ScidGenerationState> {
  ScidGenerationCubit(this.repo) : super(ScidGenerationInitial());

  static ScidGenerationCubit get(context) => BlocProvider.of(context);
  final ScidGenerationRepo repo;
  CsidType? csidType;
  void changeCsidType({required CsidType type}) {
    csidType = type;
    if(type==CsidType.development){
      otpController.text='123456';
    }else{
      otpController.text='';
    }
    emit(ScidGenerationSelectCsidType());
  }
  void onTapGenerate() {
       serialNumberController.text='1-Engazat|2-Version3.0.2|3-7c12700e-9755-48c-9622-a43806a0a4e7';
     }


  late TextEditingController otpController,
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
    otpController = TextEditingController();
    addressController = TextEditingController();
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
    emit(ScidGenerationSelectUserName());
  }
  final List<String> invoiceTypes = ["Simplified Invoices الفواتير المبسطة", "Standard Invoices الفواتير الضريبية", "Standard & Simplified"];
   String? invoiceType;
  void changeInvoiceType(String? value) {
    if (value == null) return;
    invoiceType = value;
    emit(ScidGenerationSelectInvoiceType());
  }


  @override
  Future<void> close() {
    otpController.dispose();
    addressController.dispose();
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
enum CsidType { development, production, simulation }