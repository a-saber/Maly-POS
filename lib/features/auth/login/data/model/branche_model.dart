import 'package:hive/hive.dart';
import 'package:pos_app/core/api/api_keys.dart';
import 'package:pos_app/features/auth/login/data/model/pivot_model.dart';

part 'branche_model.g.dart';

@HiveType(typeId: 2)
class BrancheModel {
  @HiveField(0)
  final int? id;
  @HiveField(1)
  final String? name;
  @HiveField(2)
  final String? address;
  @HiveField(3)
  final String? phone;
  @HiveField(4)
  final String? email;
  @HiveField(5)
  final String? createdAt;
  @HiveField(6)
  final String? updatedAt;
  @HiveField(7)
  final PivotModel? pivot;

  BrancheModel(
      {required this.id,
      required this.name,
      required this.address,
      required this.phone,
      required this.email,
      required this.createdAt,
      required this.updatedAt,
      required this.pivot});

  factory BrancheModel.fromJson(Map<String, dynamic> json) {
    return BrancheModel(
      id: json[ApiKeys.id],
      name: json[ApiKeys.name],
      address: json[ApiKeys.address],
      phone: json[ApiKeys.phone],
      email: json[ApiKeys.email],
      createdAt: json[ApiKeys.createdat],
      updatedAt: json[ApiKeys.updatedat],
      pivot: json[ApiKeys.pivot] != null
          ? PivotModel.fromJson(json[ApiKeys.pivot])
          : null,
    );
  }
  factory BrancheModel.createWithoutId({
    String? name,
    String? address,
    String? phone,
    String? email,
  }) {
    return BrancheModel(
      id: null,
      name: name,
      address: address,
      phone: phone,
      email: email,
      createdAt: null,
      updatedAt: null,
      pivot: null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data[ApiKeys.id] = id;
    data[ApiKeys.name] = name;
    data[ApiKeys.address] = address;
    data[ApiKeys.phone] = phone;
    data[ApiKeys.email] = email;
    data[ApiKeys.createdat] = createdAt;
    data[ApiKeys.updatedat] = updatedAt;
    data[ApiKeys.pivot] = pivot;
    return data;
  }

  Map<String, dynamic> toJsonWithoutId() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data[ApiKeys.name] = name;
    data[ApiKeys.address] = address;
    data[ApiKeys.phone] = phone;
    data[ApiKeys.email] = email;

    return data;
  }
}
