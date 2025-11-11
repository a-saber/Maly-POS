import 'package:pos_app/features/home/data/model/shifts_model.dart';

class StartShiftModel {
  bool? status;
  String? message;
  ShiftData? shift; 

  StartShiftModel({this.status, this.message, this.shift});

  StartShiftModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    shift = json['shift'] != null ? ShiftData.fromJson(json['shift']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['status'] = status;
    data['message'] = message;
    return data;
  }
}