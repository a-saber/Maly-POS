import 'package:flutter/material.dart';
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
  Map<String, String>? paymentMethods; // ✅ أضف ده
  User? user;
  Branch? branch;

  Shift({
    this.id,
    this.openingQuantity,
    this.createdAt,
    this.updatedAt,
    this.userId,
    this.startAt,
    this.endAt,
    this.branchId,
    this.ordersCount,
    this.paymentMethods, // ✅ أضف ده
    this.user,
    this.branch,
  });

  Shift.fromJson(Map<String, dynamic> json) {
    // ✅ Safe parsing for id
    if (json['id'] != null) {
      id = json['id'] is int ? json['id'] : int.tryParse(json['id'].toString());
    }
    
    openingQuantity = json['opening_quantity'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    
    // ✅ Safe parsing for userId
    if (json['user_id'] != null) {
      userId = json['user_id'] is int 
        ? json['user_id'] 
        : int.tryParse(json['user_id'].toString());
    }
    
    startAt = json['start_at'];
    endAt = json['end_at'];
    
    // ✅ Safe parsing for branchId
    if (json['branch_id'] != null) {
      branchId = json['branch_id'] is int 
        ? json['branch_id'] 
        : int.tryParse(json['branch_id'].toString());
    }
    
    // ✅ Safe parsing for ordersCount
    if (json['orders_count'] != null) {
      ordersCount = json['orders_count'] is int 
        ? json['orders_count'] 
        : int.tryParse(json['orders_count'].toString());
    }
    
    // ✅ Parse payment_methods
    if (json['payment_methods'] != null && json['payment_methods'] is Map) {
      try {
        final rawPaymentMethods = json['payment_methods'] as Map<String, dynamic>;
        paymentMethods = rawPaymentMethods.map(
          (key, value) => MapEntry(key, value.toString()),
        );
        debugPrint('✅ Payment methods parsed in Shift: $paymentMethods');
      } catch (e) {
        debugPrint('❌ Error parsing payment_methods in Shift: $e');
        paymentMethods = null;
      }
    }
    
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
    
    if (paymentMethods != null) {
      data['payment_methods'] = paymentMethods;
    }
    
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

  User({
    this.id,
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
    this.imageUrl,
  });

  User.fromJson(Map<String, dynamic> json) {
    // ✅ Safe parsing for all int fields
    id = _parseInt(json['id']);
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    address = json['address'];
    status = _parseInt(json['status']);
    imagePath = json['image_path'];
    emailVerifiedAt = json['email_verified_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    centralUserId = _parseInt(json['central_user_id']);
    roleId = _parseInt(json['role_id']);
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

  // ✅ Helper function for safe int parsing
  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
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

  Branch({
    this.id,
    this.name,
    this.address,
    this.phone,
    this.email,
    this.createdAt,
    this.updatedAt,
  });

  Branch.fromJson(Map<String, dynamic> json) {
    id = _parseInt(json['id']);
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

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }
}


class Summary {
  int? count;
  String? subtotal;
  String? discountTotal;
  String? totalAfterDiscount;
  String? taxTotal;
  String? totalAfterTax;
  Map<String, String>? paymentMethods;

  Summary({
    this.count,
    this.subtotal,
    this.discountTotal,
    this.totalAfterDiscount,
    this.taxTotal,
    this.totalAfterTax,
    this.paymentMethods,
  });

  Summary.fromJson(Map<String, dynamic> json) {
    count = _parseInt(json['count']);
    subtotal = json['subtotal'];
    discountTotal = json['discount_total'];
    totalAfterDiscount = json['total_after_discount'];
    taxTotal = json['tax_total'];
    totalAfterTax = json['total_after_tax'];
    
    if (json['payment_methods'] != null && json['payment_methods'] is Map) {
      try {
        final rawPaymentMethods = json['payment_methods'] as Map<String, dynamic>;
        paymentMethods = rawPaymentMethods.map(
          (key, value) => MapEntry(key, value.toString()),
        );
      } catch (e) {
        debugPrint('❌ Error parsing payment_methods: $e');
        paymentMethods = null;
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    data['subtotal'] = subtotal;
    data['discount_total'] = discountTotal;
    data['total_after_discount'] = totalAfterDiscount;
    data['tax_total'] = taxTotal;
    data['total_after_tax'] = totalAfterTax;
    if (paymentMethods != null) {
      data['payment_methods'] = paymentMethods;
    }
    return data;
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
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

  Settings({
    this.id,
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
    this.imageUrl,
  });

  Settings.fromJson(Map<String, dynamic> json) {
    id = _parseInt(json['id']);
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

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
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

  OrderData({
    this.id,
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
    this.branch,
  });

  OrderData.fromJson(Map<String, dynamic> json) {
    id = _parseInt(json['id']);
    subtotal = json['subtotal'];
    discountTotal = json['discount_total'];
    totalAfterDiscount = json['total_after_discount'];
    taxTotal = json['tax_total'];
    totalAfterTax = json['total_after_tax'];
    paymentMethod = json['payment_method'];
    orderType = json['order_type'];
    discountId = _parseInt(json['discount_id']);
    userId = _parseInt(json['user_id']);
    branchId = _parseInt(json['branch_id']);
    customerId = _parseInt(json['customer_id']);
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    salesReturnId = _parseInt(json['sales_return_id']);
    shiftId = _parseInt(json['shift_id']);
    
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

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
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

  SaleProducts({
    this.id,
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
    this.tax,
  });

  SaleProducts.fromJson(Map<String, dynamic> json) {
    id = _parseInt(json['id']);
    saleId = _parseInt(json['sale_id']);
    productId = _parseInt(json['product_id']);
    unitId = _parseInt(json['unit_id']);
    price = json['price'];
    unitPriceAfterDiscount = json['unit_price_after_discount'];
    lineTotalBeforeDiscount = json['line_total_before_discount'];
    lineTotalAfterDiscount = json['line_total_after_discount'];
    taxAmount = json['tax_amount'];
    lineTotalAfterTax = json['line_total_after_tax'];
    quantity = _parseInt(json['quantity']);
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    taxId = _parseInt(json['tax_id']);
    product = json['product'] != null 
        ? ProductModel.fromJson(json['product']) 
        : null;
    unit = json['unit'] != null 
        ? UnitModel.fromJson(json['unit']) 
        : null;
    tax = json['tax'] != null 
        ? TaxesModel.fromJson(json['tax']) 
        : null;
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

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }
}