import 'package:pos_app/features/clients/data/model/client_model.dart';
import 'package:pos_app/features/discounts/data/model/discount_model.dart';
import 'package:pos_app/features/products/data/model/product_model.dart';
import 'package:pos_app/features/taxes/data/model/taxes_model.dart';
import 'package:pos_app/features/units/data/model/unit_model.dart';

import 'end_shift_model.dart';

class GetShift {
  bool? status;
  String? message;
  Shift? shift;
  Summary? summary;
  Dataforshift? data;
  Settings? settings;

  GetShift({status, message, shift, summary, data, settings});

  GetShift.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    shift = json['shift'] != null ? Shift.fromJson(json['shift']) : null;
    summary =
        json['summary'] != null ? Summary.fromJson(json['summary']) : null;
    data = json['data'] != null ? Dataforshift.fromJson(json['data']) : null;
    settings =
        json['settings'] != null ? Settings.fromJson(json['settings']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (shift != null) {
      data['shift'] = shift!.toJson();
    }
    if (summary != null) {
      data['summary'] = summary!.toJson();
    }
    data['data'] = this.data!.toJson();
    if (settings != null) {
      data['settings'] = settings!.toJson();
    }
    return data;
  }
}

class Shift {
  int? id;
  String? openingQuantity;
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



class Dataforshift {
  int? currentPage;
  List<OrderData>? data;
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

  Dataforshift(
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

  Dataforshift.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = <OrderData>[];
      json['data'].forEach((v) {
        data!.add(OrderData.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    if (json['links'] != null) {
      links = <Links>[];
      json['links'].forEach((v) {
        links!.add(Links.fromJson(v));
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['current_page'] = currentPage;
    data['data'] = data;
    data['first_page_url'] = firstPageUrl;
    data['from'] = from;
    data['last_page'] = lastPage;
    data['last_page_url'] = lastPageUrl;
    if (links != null) {
      data['links'] = links!.map((v) => v.toJson()).toList();
    }
    data['next_page_url'] = nextPageUrl;
    data['path'] = path;
    data['per_page'] = perPage;
    data['prev_page_url'] = prevPageUrl;
    data['to'] = to;
    data['total'] = total;
    return data;
  }
}

class Links {
  String? url;
  String? label;
  bool? active;

  Links({url, label, active});

  Links.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    label = json['label'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    data['label'] = label;
    data['active'] = active;
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
  String? logoUrl;
  String? createdAt;
  String? updatedAt;
  String? street;
  String? building;
  String? city;
  String? district;
  String? country;
  String? imageUrl;

  Settings(
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

class OrderData {
  int? id;
  String? subtotal;
  String? discountTotal;
  String? totalAfterDiscount;
  String? taxTotal;
  String? totalAfterTax;
  String? paymentMethod;
  String? orderType;
  int? discountId;
  int? userId;
  int? branchId;
  int? customerId;
  String? createdAt;
  String? updatedAt;
  int? salesReturnId;
  int? shiftId;
  List<SaleProducts>? saleProducts;
  ClientModel? customer;
  DiscountModel? discount;
  User? user;
  Branch? branch;

  OrderData(
      {this.id,
      this.subtotal,
      this.discountTotal,
      this.totalAfterDiscount,
      this.taxTotal,
      this.totalAfterTax,
      this.paymentMethod,
      this.orderType,
      this.discountId,
      this.userId,
      this.branchId,
      this.customerId,
      this.createdAt,
      this.updatedAt,
      this.salesReturnId,
      this.shiftId,
      this.saleProducts,
      this.customer,
      this.discount,
      this.user,
      this.branch});

  OrderData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subtotal = json['subtotal'];
    discountTotal = json['discount_total'];
    totalAfterDiscount = json['total_after_discount'];
    taxTotal = json['tax_total'];
    totalAfterTax = json['total_after_tax'];
    paymentMethod = json['payment_method'];
    orderType = json['order_type'];
    discountId = json['discount_id'];
    userId = json['user_id'];
    branchId = json['branch_id'];
    customerId = json['customer_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    salesReturnId = json['sales_return_id'];
    shiftId = json['shift_id'];
    if (json['sale_products'] != null) {
      saleProducts = <SaleProducts>[];
      json['sale_products'].forEach((v) {
        saleProducts!.add(SaleProducts.fromJson(v));
      });
    }
    customer = json['customer'] != null
        ? ClientModel.fromJson(json['customer'])
        : null;
    discount = json['discount'] != null
        ? DiscountModel.fromJson(json['discount'])
        : null;
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    branch = json['branch'] != null ? Branch.fromJson(json['branch']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['subtotal'] = subtotal;
    data['discount_total'] = discountTotal;
    data['total_after_discount'] = totalAfterDiscount;
    data['tax_total'] = taxTotal;
    data['total_after_tax'] = totalAfterTax;
    data['payment_method'] = paymentMethod;
    data['order_type'] = orderType;
    data['discount_id'] = discountId;
    data['user_id'] = userId;
    data['branch_id'] = branchId;
    data['customer_id'] = customerId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['sales_return_id'] = salesReturnId;
    data['shift_id'] = shiftId;
    if (saleProducts != null) {
      data['sale_products'] = saleProducts!.map((v) => v.toJson()).toList();
    }
    data['customer'] = customer;
    data['discount'] = discount;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (branch != null) {
      data['branch'] = branch!.toJson();
    }
    return data;
  }
}

class SaleProducts {
  int? id;
  int? saleId;
  int? productId;
  int? unitId;
  String? price;
  String? unitPriceAfterDiscount;
  String? lineTotalBeforeDiscount;
  String? lineTotalAfterDiscount;
  String? taxAmount;
  String? lineTotalAfterTax;
  int? quantity;
  String? createdAt;
  String? updatedAt;
  int? taxId;
  ProductModel? product;
  UnitModel? unit;
  TaxesModel? tax;

  SaleProducts(
      {this.id,
      this.saleId,
      this.productId,
      this.unitId,
      this.price,
      this.unitPriceAfterDiscount,
      this.lineTotalBeforeDiscount,
      this.lineTotalAfterDiscount,
      this.taxAmount,
      this.lineTotalAfterTax,
      this.quantity,
      this.createdAt,
      this.updatedAt,
      this.taxId,
      this.product,
      this.unit,
      this.tax});

  SaleProducts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    saleId = json['sale_id'];
    productId = json['product_id'];
    unitId = json['unit_id'];
    price = json['price'];
    unitPriceAfterDiscount = json['unit_price_after_discount'];
    lineTotalBeforeDiscount = json['line_total_before_discount'];
    lineTotalAfterDiscount = json['line_total_after_discount'];
    taxAmount = json['tax_amount'];
    lineTotalAfterTax = json['line_total_after_tax'];
    quantity = json['quantity'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    taxId = json['tax_id'];
    product =
        json['product'] != null ? ProductModel.fromJson(json['product']) : null;
    unit = json['unit'] != null ? UnitModel.fromJson(json['unit']) : null;
    tax = json['tax'] != null ? TaxesModel.fromJson(json['tax']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['sale_id'] = saleId;
    data['product_id'] = productId;
    data['unit_id'] = unitId;
    data['price'] = price;
    data['unit_price_after_discount'] = unitPriceAfterDiscount;
    data['line_total_before_discount'] = lineTotalBeforeDiscount;
    data['line_total_after_discount'] = lineTotalAfterDiscount;
    data['tax_amount'] = taxAmount;
    data['line_total_after_tax'] = lineTotalAfterTax;
    data['quantity'] = quantity;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['tax_id'] = taxId;
    if (product != null) {
      data['product'] = product!.toJson();
    }
    if (unit != null) {
      data['unit'] = unit!.toJson();
    }
    data['tax'] = tax;
    return data;
  }
}
