import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:pos_app/core/api/api_helper.dart';
import 'package:pos_app/core/api/api_keys.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/features/shop_setting/data/model/get_shopping_setting_model.dart';
import 'package:pos_app/features/shop_setting/data/model/shop_setting_model.dart';

class ShopSettingRepo {
  final ApiHelper api;
  ShopSettingRepo(this.api);

  Future<Either<ApiResponse, ShopSettingModel>> getShopSettingData() async {
    try {
      String url = await ApiEndPoints.getShopSetting();
      var respone = await api.get(
        url: url,
      );

      if (respone.status) {
        GetShopSettingModel getShopSettingModel =
            GetShopSettingModel.fromJson(respone.data!);
        return Right(getShopSettingModel.data!);
      } else {
        return Left(
          respone,
        );
      }
    } catch (e) {
      debugPrint(e.toString());
      return Left(
        ApiResponse.unKnownError(),
      );
    }
  }

  Future<Either<ApiResponse, ShopSettingModel>> updateShopSettingData(
      {required ShopSettingModel shopSettingModel, File? image}) async {
    try {
      String url = await ApiEndPoints.getShopSetting();
      var data = await shopSettingModel.toJsonWithoutId(
        image: image,
      );
      var response = await api.post(
        url: url,
        data: data,
      );
      if (response.status) {
        GetShopSettingModel getShopSettingModel =
            GetShopSettingModel.fromJson(response.data!);
        return Right(getShopSettingModel.data!);
      } else {
        return Left(
          response,
        );
      }
    } catch (e) {
      debugPrint(e.toString());
      return Left(
        ApiResponse.unKnownError(),
      );
    }
  }
}
