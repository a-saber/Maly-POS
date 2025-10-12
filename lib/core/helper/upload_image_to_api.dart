import 'dart:io';

import 'package:dio/dio.dart';

Future<MultipartFile> uploadImageToApi({required File image}) async {
  return await MultipartFile.fromFile(
    image.path,
    filename: image.path.split('/').last, // اسم الملف
  );
}
