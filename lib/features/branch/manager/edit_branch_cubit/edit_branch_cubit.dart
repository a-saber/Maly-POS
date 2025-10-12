import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/features/auth/login/data/model/branche_model.dart';

import 'package:pos_app/features/branch/data/repo/branches_repo.dart';

part 'edit_branch_state.dart';

class EditBranchCubit extends Cubit<EditBranchState> {
  EditBranchCubit(this.repo, this.branch) : super(EditBranchInitial()) {
    nameController = TextEditingController(text: branch.name);
    addressController = TextEditingController(text: branch.address);
    phoneController = TextEditingController(text: branch.phone);
    emailController = TextEditingController(text: branch.email);
  }

  final BranchesRepo repo;
  final BrancheModel branch;

  static EditBranchCubit get(context) => BlocProvider.of(context);
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  late TextEditingController nameController;
  late TextEditingController addressController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  XFile? imageFile;

  Future<void> editBranch() async {
    emit(EditBranchLoading());
    if (formkey.currentState!.validate()) {
      var reponse = await repo.editBranch(
        branch: BrancheModel.createWithoutId(
          name: nameController.text,
          address: addressController.text,
          phone: phoneController.text,
          email: emailController.text,
        ),
        id: branch.id!,
      );
      reponse.fold(
        (error) => emit(EditBranchFailing(
          errMessage: error,
        )),
        (r) => emit(EditBranchSuccess(branch: r)),
      );
    } else {
      autovalidateMode = AutovalidateMode.always;
      emit(EditBranchUnVaild());
    }
  }

  @override
  Future<void> close() {
    nameController.dispose();
    addressController.dispose();
    return super.close();
  }

  @override
  void emit(EditBranchState state) {
    if (!isClosed) {
      super.emit(state);
    }
  }
}
