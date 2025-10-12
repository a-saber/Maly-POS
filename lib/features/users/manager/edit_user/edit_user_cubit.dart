// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
// ignore: unnecessary_import
import 'package:meta/meta.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/features/auth/login/data/model/branche_model.dart';
import 'package:pos_app/features/auth/login/data/model/role_model.dart';
import 'package:pos_app/features/auth/login/data/model/user_model.dart';
import 'package:pos_app/features/users/data/repo/users_repo.dart';

part 'edit_user_state.dart';

class EditUserCubit extends Cubit<EditUserState> {
  EditUserCubit(this.user, this.repo) : super(EditUserInitial()) {
    nameController = TextEditingController(text: user.name);
    emailController = TextEditingController(text: user.email);
    addressController = TextEditingController(text: user.address);
    phoneController = TextEditingController(text: user.phone);
    passwordController = TextEditingController();
    permissionModel = user.role;
    branches = user.branches;
  }
  static EditUserCubit get(context) => BlocProvider.of(context);
  final UserModel user;
  final UsersRepo repo;

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController addressController;
  late TextEditingController passwordController;
  XFile? image;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  RoleModel? permissionModel;
  List<BrancheModel>? branches;

  Future<void> editUser() async {
    emit(EditUserLoading());

    if (formKey.currentState!.validate()) {
      final result = await repo.editUser(
        id: user.id!,
        userModel: UserModel.fromJsonWithoutId(
          email: emailController.text,
          name: nameController.text,
          phone: phoneController.text,
          address: addressController.text,
          role: permissionModel,
          branches: branches,
        ),
        password: passwordController.text,
        image: image != null ? File(image!.path) : null,
      );

      result.fold(
        (error) => emit(EditUserFailing(errMessage: error)),
        (r) => emit(EditUserSuccess(user: r)),
      );
    } else {
      autovalidateMode = AutovalidateMode.always;
      emit(EditUserUnValidate());
    }
  }

  void changeUserPermission(RoleModel newPermission) {
    permissionModel = newPermission;
    emit(EditUserChnagePermission());
  }

  void addBranches(BrancheModel? newBranch) {
    if (newBranch == null) return;

    int index =
        branches?.indexWhere((element) => element.id == newBranch.id) ?? -1;
    if (index != -1) return;
    branches?.add(newBranch);

    emit(EditUserChnageBranche());
  }

  void removeBranches(BrancheModel? newBranch) {
    if (newBranch == null) return;
    branches?.removeWhere((element) => element.id == newBranch.id);
    emit(EditUserChnageBranche());
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
