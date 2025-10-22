class DeletePrtinerModel {
  bool? status;
  String? message;
  Printer? printer;

  DeletePrtinerModel({this.status, this.message, this.printer});

  DeletePrtinerModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    printer =
        json['printer'] != null ? new Printer.fromJson(json['printer']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.printer != null) {
      data['printer'] = this.printer!.toJson();
    }
    return data;
  }
}

class Printer {
  int? id;
  String? createdAt;
  String? updatedAt;
  String? printerName;
  String? printerType;
  String? communicationType;

  Printer(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.printerName,
      this.printerType,
      this.communicationType});

  Printer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    printerName = json['printer_name'];
    printerType = json['printer_type'];
    communicationType = json['communication_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['printer_name'] = this.printerName;
    data['printer_type'] = this.printerType;
    data['communication_type'] = this.communicationType;
    return data;
  }
}
