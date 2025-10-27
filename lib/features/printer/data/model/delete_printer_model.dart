
class DeletePrtinerResponseModel {
  bool? status;
  String? message;

  DeletePrtinerResponseModel({this.status, this.message, });

  DeletePrtinerResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }

}

