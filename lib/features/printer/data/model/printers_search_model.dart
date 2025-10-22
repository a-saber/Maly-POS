import 'package:pos_app/features/categories/data/model/category_model.dart';

class PrintersModel {
  int? currentPage;
  List<Data>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Links>? links;
  String? nextPageUrl;
  String? path;
  int? perPage;
  String? prevPageUrl;
  int? to;
  int? total;

  PrintersModel({
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

  factory PrintersModel.fromJson(Map<String, dynamic> json) {
    return PrintersModel(
      currentPage: json['current_page'] as int?,
      data: json['data'] != null && json['data'] is List
          ? (json['data'] as List)
              .map((e) => Data.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
      firstPageUrl: json['first_page_url'] as String?,
      from: json['from'] as int?,
      lastPage: json['last_page'] as int?,
      lastPageUrl: json['last_page_url'] as String?,
      links: json['links'] != null && json['links'] is List
          ? (json['links'] as List)
              .map((e) => Links.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
      nextPageUrl: json['next_page_url'] as String?,
      path: json['path'] as String?,
      perPage: json['per_page'] is String
          ? int.tryParse(json['per_page'])
          : json['per_page'] as int?,
      prevPageUrl: json['prev_page_url'] as String?,
      to: json['to'] as int?,
      total: json['total'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'data': data?.map((e) => e.toJson()).toList(),
      'first_page_url': firstPageUrl,
      'from': from,
      'last_page': lastPage,
      'last_page_url': lastPageUrl,
      'links': links?.map((e) => e.toJson()).toList(),
      'next_page_url': nextPageUrl,
      'path': path,
      'per_page': perPage,
      'prev_page_url': prevPageUrl,
      'to': to,
      'total': total,
    };
  }
  bool get hasNextPage => nextPageUrl != null && nextPageUrl!.isNotEmpty;
}
class Data {
  int? id;
  String? createdAt;
  String? updatedAt;
  String? printerName;
  String? printerType;
  String? communicationType;
  List<CategoryModel>? categories;

  Data({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.printerName,
    this.printerType,
    this.communicationType,
    this.categories,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'] as int?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      printerName: json['printer_name'] as String?,
      printerType: json['printer_type'] as String?,
      communicationType: json['communication_type'] as String?,
      categories: json['categories'] != null && json['categories'] is List
          ? (json['categories'] as List)
              .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'printer_name': printerName,
      'printer_type': printerType,
      'communication_type': communicationType,
      'categories': categories?.map((e) => e.toJson()).toList(),
    };
  }
}

class Links {
  String? url;
  String? label;
  bool? active;

  Links({this.url, this.label, this.active});

  factory Links.fromJson(Map<String, dynamic> json) {
    return Links(
      url: json['url'] as String?,
      label: json['label'] as String?,
      active: json['active'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'label': label,
      'active': active,
    };
  }
}
