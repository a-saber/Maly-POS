

class UpdatePrinterResponseModel {
  bool? status;
  String? message;

  UpdatePrinterResponseModel({this.status, this.message});

  UpdatePrinterResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }

}

