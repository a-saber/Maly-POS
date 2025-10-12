import 'dart:io';

import 'package:pos_app/core/api/api_keys.dart';
import 'package:pos_app/core/helper/upload_image_to_api.dart';

class CategoryModel {
  final int? id;
  final String? name;
  final String? description;
  final String? imagePath;
  final String? createdAt;
  final String? updatedAt;
  final String? imageUrl;

  CategoryModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imagePath,
    required this.createdAt,
    required this.updatedAt,
    required this.imageUrl,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json[ApiKeys.id],
      name: json[ApiKeys.name],
      description: json[ApiKeys.description],
      imagePath: json[ApiKeys.imagepath],
      createdAt: json[ApiKeys.createdat],
      updatedAt: json[ApiKeys.updatedat],
      imageUrl: json[ApiKeys.imageurl],
    );
  }
  factory CategoryModel.createWithoutId({
    required String name,
    required String description,
    required File? image,
    int? id,
  }) {
    return CategoryModel(
      id: id,
      name: name.trim(),
      description: description.trim(),
      imagePath: image?.path,
      createdAt: DateTime.now().toString(),
      updatedAt: DateTime.now().toString(),
      imageUrl: '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data[ApiKeys.id] = id;
    data[ApiKeys.name] = name;
    data[ApiKeys.description] = description;
    data[ApiKeys.imagepath] = imagePath;
    data[ApiKeys.createdat] = createdAt;
    data[ApiKeys.updatedat] = updatedAt;
    data[ApiKeys.imageurl] = imageUrl;
    return data;
  }

  Future<Map<String, dynamic>> toJsonWithoutId() async {
    final Map<String, dynamic> data = {};

    data[ApiKeys.name] = name;
    data[ApiKeys.description] = description;
    if (imagePath != null) {
      data[ApiKeys.image] = await uploadImageToApi(image: File(imagePath!));
    }
    return data;
  }
}
