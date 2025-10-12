import 'package:pos_app/core/api/api_keys.dart';
import 'package:pos_app/core/model/links_model.dart';
import 'package:pos_app/features/store_quantity/data/model/store_quantity_product_model.dart';

class StoreQuantityModel {
  final bool? status;
  final DataModel? data;

  StoreQuantityModel({required this.status, required this.data});

  factory StoreQuantityModel.fromJson(Map<String, dynamic> json) {
    return StoreQuantityModel(
      status: json[ApiKeys.status],
      data: json[ApiKeys.data] == null
          ? null
          : DataModel.fromJson(json[ApiKeys.data]),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data[ApiKeys.status] = status;
    data[ApiKeys.data] = data;
    return data;
  }
}

class DataModel {
  final int? currentPage;
  final List<StoreQuantityProductModel>? data;
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

  DataModel(
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

  factory DataModel.fromJson(Map<String, dynamic> json) {
    return DataModel(
      currentPage: json[ApiKeys.currentpage],
      data: json[ApiKeys.data] != null
          ? (json[ApiKeys.data] as List)
              .map((i) => StoreQuantityProductModel.fromJson(i))
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

    return data;
  }
}
