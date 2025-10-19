class ShiftsModel {
  bool? status;
  String? message;
  List<Shifts>? shifts;

  ShiftsModel({this.status, this.message, this.shifts});

  ShiftsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['shifts'] != null) {
      shifts = <Shifts>[];
      json['shifts'].forEach((v) {
        shifts!.add(new Shifts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.shifts != null) {
      data['shifts'] = this.shifts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Shifts {
  int? id;
  String? createdAt;
  String? updatedAt;
  int? userId;
  String? startAt;
  String? endAt;
  int? ordersCount;

  Shifts(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.userId,
      this.startAt,
      this.endAt,
      this.ordersCount});

  Shifts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    userId = json['user_id'];
    startAt = json['start_at'];
    endAt = json['end_at'];
    ordersCount = json['orders_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['user_id'] = this.userId;
    data['start_at'] = this.startAt;
    data['end_at'] = this.endAt;
    data['orders_count'] = this.ordersCount;
    return data;
  }
}
