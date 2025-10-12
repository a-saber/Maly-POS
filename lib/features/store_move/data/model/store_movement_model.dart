import 'package:pos_app/core/api/api_keys.dart';
import 'package:pos_app/core/model/links_model.dart';
import 'package:pos_app/features/store_move/data/model/store_movement_data.dart';

class StoreMovementsModel {
  final bool? status;
  final Movements? movements;

  StoreMovementsModel({required this.status, required this.movements});

  factory StoreMovementsModel.fromJson(Map<String, dynamic> json) {
    return StoreMovementsModel(
      status: json[ApiKeys.status],
      movements: json[ApiKeys.movements] == null
          ? null
          : Movements.fromJson(json[ApiKeys.movements]),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data[ApiKeys.status] = status;
    data[ApiKeys.movements] = movements;
    return data;
  }
}

class Movements {
  int? currentPage;
  List<StoreMovementData>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<LinksModel>? links;
  String? nextPageUrl;
  String? path;
  int? perPage;
  String? prevPageUrl;
  int? to;
  int? total;

  Movements(
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

  factory Movements.fromJson(Map<String, dynamic> json) {
    return Movements(
      currentPage: json[ApiKeys.currentpage],
      data: json[ApiKeys.data] == null
          ? null
          : (json[ApiKeys.data] as List)
              .map((i) => StoreMovementData.fromJson(i))
              .toList(),
      firstPageUrl: json[ApiKeys.firstpageurl],
      from: json[ApiKeys.from],
      lastPage: json[ApiKeys.lastpage],
      lastPageUrl: json[ApiKeys.lastpageurl],
      links: json[ApiKeys.links] == null
          ? null
          : (json[ApiKeys.links] as List)
              .map((i) => LinksModel.fromJson(i))
              .toList(),
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
