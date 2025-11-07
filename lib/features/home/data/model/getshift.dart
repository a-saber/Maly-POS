class GetShift {
  bool? status;
  String? message;
  Shift? shift;
  Summary? summary;
  Data? data;
  Settings? settings;

  GetShift(
      {this.status,
      this.message,
      this.shift,
      this.summary,
      this.data,
      this.settings});

  GetShift.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    shift = json['shift'] != null ? new Shift.fromJson(json['shift']) : null;
    summary =
        json['summary'] != null ? new Summary.fromJson(json['summary']) : null;
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    settings = json['settings'] != null
        ? new Settings.fromJson(json['settings'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.shift != null) {
      data['shift'] = this.shift!.toJson();
    }
    if (this.summary != null) {
      data['summary'] = this.summary!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (this.settings != null) {
      data['settings'] = this.settings!.toJson();
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
      {this.id,
      this.openingQuantity,
      this.createdAt,
      this.updatedAt,
      this.userId,
      this.startAt,
      this.endAt,
      this.branchId,
      this.ordersCount,
      this.user,
      this.branch});

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
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    branch =
        json['branch'] != null ? new Branch.fromJson(json['branch']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['opening_quantity'] = this.openingQuantity;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['user_id'] = this.userId;
    data['start_at'] = this.startAt;
    data['end_at'] = this.endAt;
    data['branch_id'] = this.branchId;
    data['orders_count'] = this.ordersCount;
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

class Data {
  int? currentPage;
  List<dynamic>? data;
  String? firstPageUrl;
  dynamic from;
  int? lastPage;
  String? lastPageUrl;
  List<Links>? links;
  dynamic nextPageUrl;
  String? path;
  int? perPage;
  dynamic prevPageUrl;
  dynamic to;
  int? total;

  Data(
      {this.currentPage,
      this.data,
      this.firstPageUrl,
      this.from,
      this.lastPage,
      this.lastPageUrl,
      this.links,
      this.nextPageUrl,
      this.path,
      this.perPage,
      this.prevPageUrl,
      this.to,
      this.total});

  Data.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = <dynamic>[];
      json['data'].forEach((v) {
        data!.add(v);
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    if (json['links'] != null) {
      links = <Links>[];
      json['links'].forEach((v) {
        links!.add(new Links.fromJson(v));
      });
    }
    nextPageUrl = json['next_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    if (this.data != null) {
      data['data'] = this.data;
    }
    data['first_page_url'] = this.firstPageUrl;
    data['from'] = this.from;
    data['last_page'] = this.lastPage;
    data['last_page_url'] = this.lastPageUrl;
    if (this.links != null) {
      data['links'] = this.links!.map((v) => v.toJson()).toList();
    }
    data['next_page_url'] = this.nextPageUrl;
    data['path'] = this.path;
    data['per_page'] = this.perPage;
    data['prev_page_url'] = this.prevPageUrl;
    data['to'] = this.to;
    data['total'] = this.total;
    return data;
  }
}

class Links {
  String? url;
  String? label;
  bool? active;

  Links({this.url, this.label, this.active});

  Links.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    label = json['label'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['label'] = this.label;
    data['active'] = this.active;
    return data;
  }
}

class Settings {
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

  Settings(
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

  Settings.fromJson(Map<String, dynamic> json) {
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
