import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/features/shop_setting/data/model/shop_setting_model.dart';
import 'package:pos_app/features/shop_setting/data/repo/shop_setting_repo.dart';

part 'shop_setting_state.dart';

class ShopSettingCubit extends Cubit<ShopSettingState> {
  ShopSettingCubit(this.repo) : super(ShopSettingInitial());

  static ShopSettingCubit get(context) => BlocProvider.of(context);
  final ShopSettingRepo repo;

  late TextEditingController shopNameController,
      addressController,
      postalCodeController,
      taxNoController,
      commercialNoController,
      phoneController,
      emailController;
  FileImage? image;
  String? imageUrl;
  XFile? newImage;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late AutovalidateMode autovalidateMode;

  void init() async {
    shopNameController = TextEditingController();
    addressController = TextEditingController();
    postalCodeController = TextEditingController();
    taxNoController = TextEditingController();
    commercialNoController = TextEditingController();
    phoneController = TextEditingController();
    emailController = TextEditingController();
    autovalidateMode = AutovalidateMode.disabled;
    var response = await repo.getShopSettingData();
    response.fold(
      (error) {},
      (success) {
        shopNameController.text = success.shopName ?? '';
        addressController.text = success.address ?? '';
        postalCodeController.text = success.postalCode ?? '';
        taxNoController.text = success.taxNo ?? '';
        commercialNoController.text = success.commercialNo ?? '';
        phoneController.text = success.phone ?? '';
        emailController.text = success.email ?? '';
        imageUrl = success.imageUrl;
        emit(ShopSettingGetSuccess());
      },
    );
  }

  void updateShopSetting() async {
    if (formKey.currentState!.validate()) {
      emit(ShopSettingUpdateLoading());
      var response = await repo.updateShopSettingData(
        shopSettingModel: ShopSettingModel.createModelWithoutId(
          shopName: shopNameController.text,
          address: addressController.text,
          postalCode: postalCodeController.text,
          taxNo: taxNoController.text,
          commercialNo: commercialNoController.text,
          phone: phoneController.text,
          email: emailController.text,
        ),
        image: newImage == null ? null : File(newImage!.path),
      );
      response.fold(
        (error) {
          emit(ShopSettingUpdateFailing(errMessage: error));
        },
        (success) {
          emit(ShopSettingUpdateSuccess());
        },
      );
    } else {
      autovalidateMode = AutovalidateMode.always;
      emit(ShopSettingUpdateUnValid());
    }
  }

  @override
  void emit(ShopSettingState state) {
    if (!isClosed) {
      super.emit(state);
    }
  }

  void onChangeImage(XFile image) {
    newImage = image;
  }

  @override
  Future<void> close() {
    shopNameController.dispose();
    addressController.dispose();
    postalCodeController.dispose();
    taxNoController.dispose();
    commercialNoController.dispose();
    phoneController.dispose();
    emailController.dispose();
    return super.close();
  }
}
