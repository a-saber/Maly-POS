import 'package:hive/hive.dart';
import 'package:pos_app/core/api/api_keys.dart';

part 'pivot_model.g.dart';

@HiveType(typeId: 3)
class PivotModel {
  @HiveField(0)
  final int? userId;
  @HiveField(1)
  final int? branchId;

  PivotModel({required this.userId, required this.branchId});

  factory PivotModel.fromJson(Map<String, dynamic> json) {
    return PivotModel(
      userId: json[ApiKeys.userid],
      branchId: json[ApiKeys.branchid],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data[ApiKeys.userid] = userId;
    data[ApiKeys.branchid] = branchId;
    return data;
  }
}
