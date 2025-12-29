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
  Map<String, String>? paymentMethods;
  String? createdAt;
  String? updatedAt;
  int? userId;
  String? startAt;
  String? endAt;
  int? branchId;
  int? ordersCount;
  User? user;
  Branch? branch;
  ShiftSummary? summary; // ✅ أضف الـ summary

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
    this.summary,
  });

  ShiftData.fromJson(Map<String, dynamic> json) {
    // ✅ Safe parsing للـ id
    if (json['id'] != null) {
      id = json['id'] is int ? json['id'] : int.tryParse(json['id'].toString());
    }
    
    openingQuantity = json['opening_quantity']?.toString();
    closingQuantity = json['closing_quantity']?.toString();
    discountTotal = json['discount_total']?.toString();
    taxTotal = json['tax_total']?.toString();
    totalAfterTax = json['total_after_tax']?.toString();
    
    // ✅ محاولة جلب payment_methods من المكانين
    Map<String, String>? tempPaymentMethods;
    
    // 1️⃣ محاولة من الـ shift نفسه (Shift Details API)
    if (json['payment_methods'] != null && json['payment_methods'] is Map) {
      try {
        final rawPaymentMethods = json['payment_methods'] as Map<String, dynamic>;
        tempPaymentMethods = rawPaymentMethods.map(
          (key, value) => MapEntry(key, value.toString()),
        );
        debugPrint('✅ Found payment_methods in shift: $tempPaymentMethods');
      } catch (e) {
        debugPrint('❌ Error parsing payment_methods from shift: $e');
      }
    }
    
    // 2️⃣ محاولة من الـ summary (Shifts List API)
    if (tempPaymentMethods == null && json['summary'] != null) {
      try {
        summary = ShiftSummary.fromJson(json['summary']);
        tempPaymentMethods = summary?.paymentMethods;
        debugPrint('✅ Found payment_methods in summary: $tempPaymentMethods');
      } catch (e) {
        debugPrint('❌ Error parsing summary: $e');
      }
    }
    
    paymentMethods = tempPaymentMethods;
    
    if (paymentMethods == null || paymentMethods!.isEmpty) {
      debugPrint('⚠️ No payment_methods found in JSON');
    }
    
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
    
    if (json['user_id'] != null) {
      userId = json['user_id'] is int 
        ? json['user_id'] 
        : int.tryParse(json['user_id'].toString());
    }
    
    if (json['branch_id'] != null) {
      branchId = json['branch_id'] is int 
        ? json['branch_id'] 
        : int.tryParse(json['branch_id'].toString());
    }
    
    if (json['orders_count'] != null) {
      ordersCount = json['orders_count'] is int 
        ? json['orders_count'] 
        : int.tryParse(json['orders_count'].toString());
    }
    
    startAt = json['start_at']?.toString();
    endAt = json['end_at']?.toString();
    
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    branch = json['branch'] != null ? Branch.fromJson(json['branch']) : null;
  }

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

class ShiftSummary {
  int? count;
  String? totalAfterTax;
  String? totalCollected;
  Map<String, String>? paymentMethods;

  ShiftSummary({
    this.count,
    this.totalAfterTax,
    this.totalCollected,
    this.paymentMethods,
  });

  ShiftSummary.fromJson(Map<String, dynamic> json) {
    count = json['count'] is int 
      ? json['count'] 
      : int.tryParse(json['count']?.toString() ?? '0');
    
    totalAfterTax = json['total_after_tax']?.toString();
    totalCollected = json['total_collected']?.toString();
    
    if (json['payment_methods'] != null && json['payment_methods'] is Map) {
      try {
        final rawPaymentMethods = json['payment_methods'] as Map<String, dynamic>;
        paymentMethods = rawPaymentMethods.map(
          (key, value) => MapEntry(key, value.toString()),
        );
      } catch (e) {
        debugPrint('❌ Error parsing payment_methods in summary: $e');
        paymentMethods = null;
      }
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'count': count,
      'total_after_tax': totalAfterTax,
      'total_collected': totalCollected,
      'payment_methods': paymentMethods,
    };
  }
}
