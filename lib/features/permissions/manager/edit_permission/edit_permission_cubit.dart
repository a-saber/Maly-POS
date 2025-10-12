import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// ignore: depend_on_referenced_packages, unnecessary_import
import 'package:meta/meta.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/core/constant/constant.dart';
import 'package:pos_app/features/auth/login/data/model/role_model.dart';
import 'package:pos_app/features/permissions/data/model/permission_model.dart';
import 'package:pos_app/features/permissions/data/repo/permission_repo.dart';

part 'edit_permission_state.dart';

class EditPermissionCubit extends Cubit<EditPermissionState> {
  EditPermissionCubit(this.repo, this.permission)
      : super(EditPermissionInitial()) {
    nameController = TextEditingController(text: permission.name);
    descriptionController = TextEditingController(text: permission.description);
    permissonsItem = AppConstant.getUserPermissions(permission);
  }
  static EditPermissionCubit get(context) => BlocProvider.of(context);

  final RoleModel permission;
  final PermissionsRepo repo;

  late TextEditingController nameController;
  late TextEditingController descriptionController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  List<PermissionItemModel> permissonsItem = [];

  void changePermissionStatus({required int index, required bool status}) {
    permissonsItem[index].isSelected = status;
    emit(EditPermissionChnagePermission());
  }

  Future<void> editPermission() async {
    emit(EditPermissionLoading());
    if (formKey.currentState!.validate()) {
      RoleModel role = RoleModel.createNew(
          name: nameController.text.trim(),
          description: descriptionController.text.trim(),
          permissions: permissonsItem);
      emit(EditPermissionLoading());
      final result =
          await repo.editPermission(newPermission: role, id: permission.id!);
      result.fold(
          (errMessage) => emit(EditPermissionFailing(errMessage: errMessage)),
          (r) => emit(EditPermissionSuccess(role: r)));
    } else {
      autovalidateMode = AutovalidateMode.always;

      emit(EditPermissionUnvalidate());
    }
  }

  @override
  Future<void> close() {
    nameController.dispose();
    descriptionController.dispose();
    return super.close();
  }
}
