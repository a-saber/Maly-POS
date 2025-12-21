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
  String? cashTotal;
   String? onlineTotal;
  String? discountTotal;
  String? taxTotal;
  String? totalAfterTax;
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
     this.cashTotal,
     this.onlineTotal,
    this.discountTotal,
    this.taxTotal,
    this.totalAfterTax,

  });

  ShiftData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    openingQuantity = json['opening_quantity'];
    closingQuantity = json['closing_quantity'];
    cashTotal = json['cash_total'];
     onlineTotal = json['online_total'];
    discountTotal = json['discount_total'];
    taxTotal = json['tax_total'];
    totalAfterTax = json['total_after_tax'];


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
}
