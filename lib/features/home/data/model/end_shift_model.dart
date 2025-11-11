import 'package:pos_app/features/home/data/model/shifts_model.dart';

class EndShiftModel {
  bool? status;
  String? message;
  ShiftData? shift;
  Summary? summary;
  Setting? setting;

  EndShiftModel(
      {this.status, this.message, this.shift, this.summary, this.setting});

  EndShiftModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    shift = json['shift'] != null ? ShiftData.fromJson(json['shift']) : null;
    summary =
        json['summary'] != null ? new Summary.fromJson(json['summary']) : null;
    setting =
        json['setting'] != null ? new Setting.fromJson(json['setting']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.summary != null) {
      data['summary'] = this.summary!.toJson();
    }
    if (this.setting != null) {
      data['setting'] = this.setting!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? name;
  String? email;
  String? phone;
  Null? address;
  int? status;
  Null? imagePath;
  Null? emailVerifiedAt;
  String? createdAt;
  String? updatedAt;
  int? centralUserId;
  int? roleId;
  Null? imageUrl;

  User(
      {this.id,
      this.name,
      this.email,
      this.phone,
      this.address,
      this.status,
      this.imagePath,
      this.emailVerifiedAt,
      this.createdAt,
      this.updatedAt,
      this.centralUserId,
      this.roleId,
      this.imageUrl});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    address = json['address'];
    status = json['status'];
    imagePath = json['image_path'];
    emailVerifiedAt = json['email_verified_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    centralUserId = json['central_user_id'];
    roleId = json['role_id'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['address'] = this.address;
    data['status'] = this.status;
    data['image_path'] = this.imagePath;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['central_user_id'] = this.centralUserId;
    data['role_id'] = this.roleId;
    data['image_url'] = this.imageUrl;
    return data;
  }
}

class Branch {
  int? id;
  String? name;
  Null? address;
  Null? phone;
  Null? email;
  String? createdAt;
  String? updatedAt;

  Branch(
      {this.id,
      this.name,
      this.address,
      this.phone,
      this.email,
      this.createdAt,
      this.updatedAt});

  Branch.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    phone = json['phone'];
    email = json['email'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['address'] = this.address;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Summary {
  int? count;
  String? subtotal;
  String? discountTotal;
  String? totalAfterDiscount;
  String? taxTotal;
  String? totalAfterTax;
  String? cashTotal;
  String? onlineTotal;

  Summary(
      {this.count,
      this.subtotal,
      this.discountTotal,
      this.totalAfterDiscount,
      this.taxTotal,
      this.totalAfterTax,
      this.cashTotal,
      this.onlineTotal});

  Summary.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    subtotal = json['subtotal'];
    discountTotal = json['discount_total'];
    totalAfterDiscount = json['total_after_discount'];
    taxTotal = json['tax_total'];
    totalAfterTax = json['total_after_tax'];
    cashTotal = json['cash_total'];
    onlineTotal = json['online_total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['subtotal'] = this.subtotal;
    data['discount_total'] = this.discountTotal;
    data['total_after_discount'] = this.totalAfterDiscount;
    data['tax_total'] = this.taxTotal;
    data['total_after_tax'] = this.totalAfterTax;
    data['cash_total'] = this.cashTotal;
    data['online_total'] = this.onlineTotal;
    return data;
  }
}

class Setting {
  int? id;
  String? shopName;
  String? address;
  String? postalCode;
  String? taxNo;
  String? commercialNo;
  String? phone;
  String? email;
  Null? logoUrl;
  String? createdAt;
  String? updatedAt;
  Null? street;
  Null? building;
  Null? city;
  Null? district;
  Null? country;
  Null? imageUrl;

  Setting(
      {this.id,
      this.shopName,
      this.address,
      this.postalCode,
      this.taxNo,
      this.commercialNo,
      this.phone,
      this.email,
      this.logoUrl,
      this.createdAt,
      this.updatedAt,
      this.street,
      this.building,
      this.city,
      this.district,
      this.country,
      this.imageUrl});

  Setting.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    shopName = json['shop_name'];
    address = json['address'];
    postalCode = json['postal_code'];
    taxNo = json['tax_no'];
    commercialNo = json['commercial_no'];
    phone = json['phone'];
    email = json['email'];
    logoUrl = json['logo_url'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    street = json['street'];
    building = json['building'];
    city = json['city'];
    district = json['district'];
    country = json['country'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['shop_name'] = this.shopName;
    data['address'] = this.address;
    data['postal_code'] = this.postalCode;
    data['tax_no'] = this.taxNo;
    data['commercial_no'] = this.commercialNo;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['logo_url'] = this.logoUrl;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['street'] = this.street;
    data['building'] = this.building;
    data['city'] = this.city;
    data['district'] = this.district;
    data['country'] = this.country;
    data['image_url'] = this.imageUrl;
    return data;
  }
}
