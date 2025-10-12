import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// ignore: depend_on_referenced_packages, unnecessary_import
import 'package:meta/meta.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/core/constant/constant.dart';
import 'package:pos_app/features/auth/login/data/model/role_model.dart';
import 'package:pos_app/features/permissions/data/model/permission_model.dart';
import 'package:pos_app/features/permissions/data/repo/permission_repo.dart';

part 'add_permission_state.dart';

class AddPermissionCubit extends Cubit<AddPermissionState> {
  AddPermissionCubit(this.permissionsRepo) : super(AddPermissionInitial());

  static AddPermissionCubit get(context) => BlocProvider.of(context);

  final PermissionsRepo permissionsRepo;

  void changePermissionStatus({required int index, required bool status}) {
    permissionItems[index].isSelected = status;
    emit(AddPermissionChangePermission());
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.always;
  List<PermissionItemModel> permissionItems = AppConstant.allPermissions();
  Future<void> addPermission() async {
    if (formKey.currentState!.validate()) {
      RoleModel role = RoleModel.createNew(
          name: nameController.text.trim(),
          description: descriptionController.text.trim(),
          permissions: permissionItems);
      emit(AddPermissionLoading());
      final result = await permissionsRepo.addPermission(
        permission: role,
      );
      result.fold(
          (errMessage) => emit(AddPermissionFailing(errMessage: errMessage)),
          (r) => emit(AddPermissionSuccess(role: r)));
    } else {
      autovalidateMode = AutovalidateMode.always;
      emit(AddPermissionUnValidate());
    }
  }

  @override
  Future<void> close() {
    nameController.dispose();
    descriptionController.dispose();
    return super.close();
  }
}
