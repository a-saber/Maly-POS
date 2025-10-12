import 'package:pos_app/core/api/api_keys.dart';
import 'package:pos_app/core/model/links_model.dart';
import 'package:pos_app/features/products/data/model/product_model.dart';

class GetProductsModel {
  final bool? status;
  final Data? data;

  GetProductsModel({required this.status, required this.data});

  factory GetProductsModel.fromJson(Map<String, dynamic> json) {
    return GetProductsModel(
      status: json[ApiKeys.status],
      data:
          json[ApiKeys.data] == null ? null : Data.fromJson(json[ApiKeys.data]),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data[ApiKeys.status] = status;
    if (this.data != null) {
      data[ApiKeys.data] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  final int? currentPage;
  final List<ProductModel>? data;
  final String? firstPageUrl;
  final int? from;
  final int? lastPage;
  final String? lastPageUrl;
  final List<LinksModel>? links;
  final String? nextPageUrl;
  final String? path;
  final int? perPage;
  final String? prevPageUrl;
  final int? to;
  final int? total;

  Data(
      {required this.currentPage,
      required this.data,
      required this.firstPageUrl,
      required this.from,
      required this.lastPage,
      required this.lastPageUrl,
      required this.links,
      required this.nextPageUrl,
      required this.path,
      required this.perPage,
      required this.prevPageUrl,
      required this.to,
      required this.total});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      currentPage: json[ApiKeys.currentpage],
      data: json[ApiKeys.data] != null
          ? List<ProductModel>.from(
              json[ApiKeys.data].map((x) => ProductModel.fromJson(x)))
          : null,
      firstPageUrl: json[ApiKeys.firstpageurl],
      from: json[ApiKeys.from],
      lastPage: json[ApiKeys.lastpage],
      lastPageUrl: json[ApiKeys.lastpageurl],
      links: json[ApiKeys.links] != null
          ? List<LinksModel>.from(
              json[ApiKeys.links].map((x) => LinksModel.fromJson(x)))
          : null,
      nextPageUrl: json[ApiKeys.nextpageurl],
      path: json[ApiKeys.path],
      perPage: json[ApiKeys.perpage],
      prevPageUrl: json[ApiKeys.prevpageurl],
      to: json[ApiKeys.to],
      total: json[ApiKeys.total],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data[ApiKeys.currentpage] = currentPage;
    if (this.data != null) {
      data[ApiKeys.data] = this.data!.map((v) => v.toJson()).toList();
    }
    data[ApiKeys.firstpageurl] = firstPageUrl;
    data[ApiKeys.from] = from;
    data[ApiKeys.lastpage] = lastPage;
    data[ApiKeys.lastpageurl] = lastPageUrl;
    if (links != null) {
      data[ApiKeys.links] = links!.map((v) => v.toJson()).toList();
    }
    data[ApiKeys.nextpageurl] = nextPageUrl;
    data[ApiKeys.path] = path;
    data[ApiKeys.perpage] = perPage;
    data[ApiKeys.prevpageurl] = prevPageUrl;
    data[ApiKeys.to] = to;
    data[ApiKeys.total] = total;
    return data;
  }
}
