import 'package:pos_app/features/shifts/data/model/shifts_model.dart';

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
    shift = json['shift'] != null ? new ShiftData.fromJson(json['shift']) : null;
    summary =
        json['summary'] != null ? new Summary.fromJson(json['summary']) : null;
    setting =
        json['setting'] != null ? new Setting.fromJson(json['setting']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    // if (this.shift != null) {
    //   data['shift'] = this.shift!.toJson();
    // }
    if (this.summary != null) {
      data['summary'] = this.summary!.toJson();
    }
    if (this.setting != null) {
      data['setting'] = this.setting!.toJson();
    }
    return data;
  }
}
class PaymentMethodsModel {
  final String? cash;
  final String? malypay;

  PaymentMethodsModel({
    this.cash,
    this.malypay,
  });

  factory PaymentMethodsModel.fromJson(Map<String, dynamic> json) {
    return PaymentMethodsModel(
      cash: json['cash'] as String?,
      malypay: json['malypay'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cash': cash,
      'malypay': malypay,
    };
  }
}



class Shift {
  int? id;
  int? userId;
  int? branchId;
  String? openingQuantity;
  int? count;
  String? subtotal;
  String? discountTotal;
  String? totalAfterDiscount;
  String? taxTotal;
  String? totalAfterTax;
  String? closingQuantity;
  String? startAt;
  String? endAt;
  String? createdAt;
  String? updatedAt;
  User? user;
  Branch? branch;

  Shift(
      {this.id,
      this.userId,
      this.branchId,
      this.openingQuantity,
      this.count,
      this.subtotal,
      this.discountTotal,
      this.totalAfterDiscount,
      this.taxTotal,
      this.totalAfterTax,
      this.closingQuantity,
      this.startAt,
      this.endAt,
      this.createdAt,
      this.updatedAt,
      this.user,
      this.branch});

  Shift.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    branchId = json['branch_id'];
    openingQuantity = json['opening_quantity'];
    count = json['count'];
    subtotal = json['subtotal'];
    discountTotal = json['discount_total'];
    totalAfterDiscount = json['total_after_discount'];
    taxTotal = json['tax_total'];
    totalAfterTax = json['total_after_tax'];
    closingQuantity = json['closing_quantity'];
    startAt = json['start_at'];
    endAt = json['end_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    branch =
        json['branch'] != null ? new Branch.fromJson(json['branch']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['branch_id'] = this.branchId;
    data['opening_quantity'] = this.openingQuantity;
    data['count'] = this.count;
    data['subtotal'] = this.subtotal;
    data['discount_total'] = this.discountTotal;
    data['total_after_discount'] = this.totalAfterDiscount;
    data['tax_total'] = this.taxTotal;
    data['total_after_tax'] = this.totalAfterTax;
    data['closing_quantity'] = this.closingQuantity;
    data['start_at'] = this.startAt;
    data['end_at'] = this.endAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.branch != null) {
      data['branch'] = this.branch!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? name;
  String? email;
  String? emailVerifiedAt;
  String? phone;
  String? address;
  int? status;
  String? imagePath;
  int? roleId;
  int? centralUserId;
  String? createdAt;
  String? updatedAt;
  String? imageUrl;

  User(
      {this.id,
      this.name,
      this.email,
      this.emailVerifiedAt,
      this.phone,
      this.address,
      this.status,
      this.imagePath,
      this.roleId,
      this.centralUserId,
      this.createdAt,
      this.updatedAt,
      this.imageUrl});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    phone = json['phone'];
    address = json['address'];
    status = json['status'];
    imagePath = json['image_path'];
    roleId = json['role_id'];
    centralUserId = json['central_user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['phone'] = this.phone;
    data['address'] = this.address;
    data['status'] = this.status;
    data['image_path'] = this.imagePath;
    data['role_id'] = this.roleId;
    data['central_user_id'] = this.centralUserId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['image_url'] = this.imageUrl;
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
  String? totalCollected;
  Map<String, String>? paymentMethods;

  Summary(
      {this.count,
      this.subtotal,
      this.discountTotal,
      this.totalAfterDiscount,
      this.taxTotal,
      this.totalAfterTax,
      this.totalCollected,
      this.paymentMethods});

  Summary.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    subtotal = json['subtotal'];
    discountTotal = json['discount_total'];
    totalAfterDiscount = json['total_after_discount'];
    taxTotal = json['tax_total'];
    totalAfterTax = json['total_after_tax'];
    totalCollected = json['total_collected'];
    if (json['payment_methods'] != null) {
      paymentMethods = Map<String, String>.from(
        json['payment_methods'],
      );
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['subtotal'] = this.subtotal;
    data['discount_total'] = this.discountTotal;
    data['total_after_discount'] = this.totalAfterDiscount;
    data['tax_total'] = this.taxTotal;
    data['total_after_tax'] = this.totalAfterTax;
    data['total_collected'] = this.totalCollected;
    if (this.paymentMethods != null) {
      data['payment_methods'] = this.paymentMethods;
    }
    return data;
  }
}


class Setting {
  int? id;
  String? shopName;
  String? address;
  String? postalCode;
  String? taxNo;
  Null? commercialNo;
  String? phone;
  Null? email;
  String? logoUrl;
  String? street;
  String? building;
  String? city;
  String? district;
  String? country;
  bool? allowLowerPrices;
  bool? enableNearpay;
  String? createdAt;
  String? updatedAt;
  String? imageUrl;

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
      this.street,
      this.building,
      this.city,
      this.district,
      this.country,
      this.allowLowerPrices,
      this.enableNearpay,
      this.createdAt,
      this.updatedAt,
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
    street = json['street'];
    building = json['building'];
    city = json['city'];
    district = json['district'];
    country = json['country'];
    allowLowerPrices = json['allow_lower_prices'];
    enableNearpay = json['enable_nearpay'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
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
    data['street'] = this.street;
    data['building'] = this.building;
    data['city'] = this.city;
    data['district'] = this.district;
    data['country'] = this.country;
    data['allow_lower_prices'] = this.allowLowerPrices;
    data['enable_nearpay'] = this.enableNearpay;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['image_url'] = this.imageUrl;
    return data;
  }
}
