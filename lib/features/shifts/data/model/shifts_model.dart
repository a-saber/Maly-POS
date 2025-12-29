import 'package:flutter/material.dart';
import 'package:pos_app/features/shifts/data/model/end_shift_model.dart';
import 'package:pos_app/features/shifts/data/model/getshift.dart'
    hide User, Branch;

class ShiftsModel {
  bool? status;
  String? message;
  Data? data;

  ShiftsModel({this.status, this.message, this.data});

  ShiftsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
}

class Data {
  int? currentPage;
  List<ShiftData>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Links>? links;
  String? nextPageUrl;
  String? path;
  int? perPage;
  dynamic prevPageUrl;
  int? to;
  int? total;

  Data({
    this.currentPage,
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
    this.total,
  });

  Data.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];

    if (json['data'] != null) {
      data = <ShiftData>[];
      json['data'].forEach((v) {
        data!.add(ShiftData.fromJson(v));
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
}

class ShiftData {
  int? id;
  String? openingQuantity;
  String? closingQuantity;
  String? discountTotal;
  String? taxTotal;
  String? totalAfterTax;
  Map<String, String>? paymentMethods; // ✅ ده المفروض يجي من الـ shift
  String? createdAt;
  String? updatedAt;
  int? userId;
  String? startAt;
  String? endAt;
  int? branchId;
  int? ordersCount;
  User? user;
  Branch? branch;

  ShiftData({
    this.id,
    this.openingQuantity,
    this.createdAt,
    this.updatedAt,
    this.userId,
    this.startAt,
    this.endAt,
    this.branchId,
    this.ordersCount,
    this.user,
    this.branch,
    this.closingQuantity,
    this.paymentMethods,
    this.discountTotal,
    this.taxTotal,
    this.totalAfterTax,
  });

 // ✅ تأكد من الـ JSON اللي جاي من الـ API
ShiftData.fromJson(Map<String, dynamic> json) {
  // طباعة الـ raw JSON عشان نشوف إيه اللي جاي
  debugPrint('🔍 Raw JSON for shift:');
  debugPrint(json.toString());
  
  if (json['id'] != null) {
    if (json['id'] is int) {
      id = json['id'];
    } else if (json['id'] is String) {
      id = int.tryParse(json['id']);
    }
  }
  
  openingQuantity = json['opening_quantity']?.toString();
  closingQuantity = json['closing_quantity']?.toString();
  discountTotal = json['discount_total']?.toString();
  taxTotal = json['tax_total']?.toString();
  totalAfterTax = json['total_after_tax']?.toString();
  
  // ✅ طباعة نوع الـ payment_methods قبل ما نحاول نعالجها
  debugPrint('🔍 payment_methods type: ${json['payment_methods']?.runtimeType}');
  debugPrint('🔍 payment_methods value: ${json['payment_methods']}');
  
  if (json['payment_methods'] != null) {
    try {
      // تأكد إن الحاجة دي Map فعلاً
      if (json['payment_methods'] is Map) {
        final rawPaymentMethods = json['payment_methods'] as Map<String, dynamic>;
        paymentMethods = rawPaymentMethods.map(
          (key, value) => MapEntry(key, value.toString()),
        );
        debugPrint('✅ Payment methods parsed successfully: $paymentMethods');
      } else {
        debugPrint('⚠️ payment_methods is not a Map! It is: ${json['payment_methods'].runtimeType}');
      }
    } catch (e, stackTrace) {
      debugPrint('❌ Error parsing payment_methods: $e');
      debugPrint('Stack trace: $stackTrace');
      paymentMethods = null;
    }
  } else {
    debugPrint('⚠️ payment_methods is NULL in JSON');
  }
  
  createdAt = json['created_at']?.toString();
  updatedAt = json['updated_at']?.toString();
  
  if (json['user_id'] != null) {
    if (json['user_id'] is int) {
      userId = json['user_id'];
    } else if (json['user_id'] is String) {
      userId = int.tryParse(json['user_id']);
    }
  }
  
  if (json['branch_id'] != null) {
    if (json['branch_id'] is int) {
      branchId = json['branch_id'];
    } else if (json['branch_id'] is String) {
      branchId = int.tryParse(json['branch_id']);
    }
  }
  
  if (json['orders_count'] != null) {
    if (json['orders_count'] is int) {
      ordersCount = json['orders_count'];
    } else if (json['orders_count'] is String) {
      ordersCount = int.tryParse(json['orders_count']);
    }
  }
  
  startAt = json['start_at']?.toString();
  endAt = json['end_at']?.toString();
  
  user = json['user'] != null ? User.fromJson(json['user']) : null;
  branch = json['branch'] != null ? Branch.fromJson(json['branch']) : null;
}
  // ✅ دالة مساعدة عشان تطبع البيانات للتجربة
  void printShiftData() {
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    debugPrint('📊 Shift Data #$id');
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    debugPrint('👤 User: ${user?.name ?? "N/A"}');
    debugPrint('🏢 Branch: ${branch?.name ?? "N/A"}');
    debugPrint('📅 Start: $startAt');
    debugPrint('📅 End: $endAt');
    debugPrint('💰 Opening: $openingQuantity');
    debugPrint('💰 Closing: $closingQuantity');
    debugPrint('🎫 Discount: $discountTotal');
    debugPrint('💵 Tax: $taxTotal');
    debugPrint('💳 Total After Tax: $totalAfterTax');
    debugPrint('📦 Orders Count: $ordersCount');
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    debugPrint('💳 Payment Methods:');
    if (paymentMethods != null && paymentMethods!.isNotEmpty) {
      paymentMethods!.forEach((key, value) {
        debugPrint('   • $key: $value');
      });
    } else {
      debugPrint('   ⚠️ No payment methods found!');
    }
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
  }
}