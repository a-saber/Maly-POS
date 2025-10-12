import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
// ignore: depend_on_referenced_packages, unnecessary_import
import 'package:meta/meta.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/features/auth/login/data/model/branche_model.dart';
import 'package:pos_app/features/auth/login/data/model/role_model.dart';
import 'package:pos_app/features/auth/login/data/model/user_model.dart';
// import 'package:pos_app/features/permissions/data/model/permission_model.dart';
import 'package:pos_app/features/users/data/repo/users_repo.dart';

part 'add_user_state.dart';

class AddUserCubit extends Cubit<AddUserState> {
  AddUserCubit(this.repo) : super(AddUserInitial());

  static AddUserCubit get(context) => BlocProvider.of(context);

  final UsersRepo repo;

  void changeUserPermission(RoleModel newPermission) {
    permissionModel = newPermission;
    emit(AddUserChangePermission());
  }

  void addBranch(BrancheModel? newBranch) {
    if (newBranch == null) return;
    int index = branches.indexWhere((element) => element.id == newBranch.id);
    if (index != -1) return;
    branches.add(newBranch);
    emit(AddUserChangeBranch());
  }

  void removeBranch(BrancheModel? newBranch) {
    if (newBranch == null) return;
    branches.removeWhere((element) => element.id == newBranch.id);
    emit(AddUserChangeBranch());
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  XFile? image;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  RoleModel? permissionModel;
  List<BrancheModel> branches = [];

  Future<void> addUser() async {
    emit(AddUserLoading());
    if (formKey.currentState!.validate()) {
      final result = await repo.addUser(
        userModel: UserModel.fromJsonWithoutId(
            email: emailController.text,
            name: nameController.text,
            phone: phoneController.text,
            address: addressController.text,
            role: permissionModel,
            branches: branches),
        password: passwordController.text,
        image: image == null ? null : File(image!.path),
      );

      result.fold(
        (error) => emit(AddUserFailing(errMessage: error)),
        (r) => emit(AddUserSuccess(user: r)),
      );
    } else {
      autovalidateMode = AutovalidateMode.always;
      emit(AddUserUnValidate());
    }
  }

  @override
  Future<void> close() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();

    return super.close();
  }
}
