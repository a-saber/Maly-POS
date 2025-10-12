import 'package:pos_app/core/api/api_keys.dart';
import 'package:pos_app/core/model/links_model.dart';
import 'package:pos_app/features/sales/data/model/sales_model.dart';

class GetSalesModel {
  final bool? status;
  final Data? data;

  GetSalesModel({required this.status, required this.data});

  factory GetSalesModel.fromJson(Map<String, dynamic> json) {
    return GetSalesModel(
      status: json[ApiKeys.status],
      data:
          json[ApiKeys.data] == null ? null : Data.fromJson(json[ApiKeys.data]),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data[ApiKeys.status] = status;
    data[ApiKeys.data] = data;
    return data;
  }
}

class Data {
  final int? currentPage;
  final List<SalesModel>? data;
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
          ? (json[ApiKeys.data] as List)
              .map((i) => SalesModel.fromJson(i))
              .toList()
          : null,
      firstPageUrl: json[ApiKeys.firstpageurl],
      from: json[ApiKeys.from],
      lastPage: json[ApiKeys.lastpage],
      lastPageUrl: json[ApiKeys.lastpageurl],
      links: json[ApiKeys.links] != null
          ? (json[ApiKeys.links] as List)
              .map((i) => LinksModel.fromJson(i))
              .toList()
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

    if (this.data != null) {
      data[ApiKeys.data] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
