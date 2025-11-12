import 'package:pos_app/features/shifts/data/model/shifts_model.dart';

class EndShiftModel {
  bool? status;
  String? message;
  ShiftData? shift;
  Summary? summary;
  Setting? setting;

  EndShiftModel({status, message, shift, summary, setting});

  EndShiftModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    shift = json['shift'] != null ? ShiftData.fromJson(json['shift']) : null;
    summary =
        json['summary'] != null ? Summary.fromJson(json['summary']) : null;
    setting =
        json['setting'] != null ? Setting.fromJson(json['setting']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (summary != null) {
      data['summary'] = summary!.toJson();
    }
    if (setting != null) {
      data['setting'] = setting!.toJson();
    }
    return data;
  }
}

class Shift {
  int? id;
  int? openingQuantity;
  String? createdAt;
  String? updatedAt;
  int? userId;
  String? startAt;
  String? endAt;
  int? branchId;
  int? ordersCount;
  User? user;
  Branch? branch;

  Shift(
      {id,
      openingQuantity,
      createdAt,
      updatedAt,
      userId,
      startAt,
      endAt,
      branchId,
      ordersCount,
      user,
      branch});

  Shift.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    openingQuantity = json['opening_quantity'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    userId = json['user_id'];
    startAt = json['start_at'];
    endAt = json['end_at'];
    branchId = json['branch_id'];
    ordersCount = json['orders_count'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    branch = json['branch'] != null ? Branch.fromJson(json['branch']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['opening_quantity'] = openingQuantity;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['user_id'] = userId;
    data['start_at'] = startAt;
    data['end_at'] = endAt;
    data['branch_id'] = branchId;
    data['orders_count'] = ordersCount;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (branch != null) {
      data['branch'] = branch!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? address;
  int? status;
  String? imagePath;
  String? emailVerifiedAt;
  String? createdAt;
  String? updatedAt;
  int? centralUserId;
  int? roleId;
  String? imageUrl;

  User(
      {id,
      name,
      email,
      phone,
      address,
      status,
      imagePath,
      emailVerifiedAt,
      createdAt,
      updatedAt,
      centralUserId,
      roleId,
      imageUrl});

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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['address'] = address;
    data['status'] = status;
    data['image_path'] = imagePath;
    data['email_verified_at'] = emailVerifiedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['central_user_id'] = centralUserId;
    data['role_id'] = roleId;
    data['image_url'] = imageUrl;
    return data;
  }
}

class Branch {
  int? id;
  String? name;
  String? address;
  String? phone;
  String? email;
  String? createdAt;
  String? updatedAt;

  Branch({id, name, address, phone, email, createdAt, updatedAt});

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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['address'] = address;
    data['phone'] = phone;
    data['email'] = email;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
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
      {count,
      subtotal,
      discountTotal,
      totalAfterDiscount,
      taxTotal,
      totalAfterTax,
      cashTotal,
      onlineTotal});

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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    data['subtotal'] = subtotal;
    data['discount_total'] = discountTotal;
    data['total_after_discount'] = totalAfterDiscount;
    data['tax_total'] = taxTotal;
    data['total_after_tax'] = totalAfterTax;
    data['cash_total'] = cashTotal;
    data['online_total'] = onlineTotal;
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
  String? logoUrl;
  String? createdAt;
  String? updatedAt;
  String? street;
  String? building;
  String? city;
  String? district;
  String? country;
  String? imageUrl;

  Setting(
      {id,
      shopName,
      address,
      postalCode,
      taxNo,
      commercialNo,
      phone,
      email,
      logoUrl,
      createdAt,
      updatedAt,
      street,
      building,
      city,
      district,
      country,
      imageUrl});

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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['shop_name'] = shopName;
    data['address'] = address;
    data['postal_code'] = postalCode;
    data['tax_no'] = taxNo;
    data['commercial_no'] = commercialNo;
    data['phone'] = phone;
    data['email'] = email;
    data['logo_url'] = logoUrl;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['street'] = street;
    data['building'] = building;
    data['city'] = city;
    data['district'] = district;
    data['country'] = country;
    data['image_url'] = imageUrl;
    return data;
  }
}
