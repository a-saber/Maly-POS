import 'package:pos_app/core/api/api_keys.dart';

class UnitTestModel {
  final int id;
  final String name;
  final String? description;

  UnitTestModel(
      {required this.id, required this.name, required this.description});

  factory UnitTestModel.fromJson(Map<String, dynamic> json) {
    return UnitTestModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }
}

class UnitModel {
  final int? id;
  final String? name;
  final String? createdAt;
  final String? updatedAt;

  UnitModel({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UnitModel.fromJson(Map<String, dynamic> json) {
    return UnitModel(
      id: json[ApiKeys.id],
      name: json[ApiKeys.name],
      createdAt: json[ApiKeys.createdat],
      updatedAt: json[ApiKeys.updatedat],
    );
  }
  factory UnitModel.createWithoutId({
    required String? name,
    int? id,
    String? createdAt,
    String? updatedAt,
  }) {
    return UnitModel(
      id: id,
      name: name,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data[ApiKeys.id] = id;
    data[ApiKeys.name] = name;
    data[ApiKeys.createdat] = createdAt;
    data[ApiKeys.updatedat] = updatedAt;
    return data;
  }

  Map<String, dynamic> toJsonWithoutId() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data[ApiKeys.name] = name;

    return data;
  }
}
