import 'printer_model.dart';

class AddPrinterResponseModel {
  bool? status;
  String? message;

  AddPrinterResponseModel({this.status, this.message, });

  AddPrinterResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }
}


