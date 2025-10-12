import 'package:pos_app/core/api/api_keys.dart';
import 'package:pos_app/features/auth/login/data/model/user_model.dart';
import 'package:pos_app/core/model/links_model.dart';

class GetUserModel {
  final int? currentPage;
  final List<UserModel>? data;
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

  GetUserModel(
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

  factory GetUserModel.fromJson(Map<String, dynamic> json) {
    return GetUserModel(
      currentPage: json[ApiKeys.currentpage],
      data: json[ApiKeys.data] != null
          ? List<UserModel>.from(
              json[ApiKeys.data].map((x) => UserModel.fromJson(x)))
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
