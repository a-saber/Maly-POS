import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/features/auth/login/data/model/branche_model.dart';

import 'package:pos_app/features/branch/data/repo/branches_repo.dart';

part 'add_branch_state.dart';

class AddBranchCubit extends Cubit<AddBranchState> {
  AddBranchCubit(this.repo) : super(AddBranchInitial());
  static AddBranchCubit get(context) => BlocProvider.of(context);
  final BranchesRepo repo;

  GlobalKey<FormState> formKey = GlobalKey();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  XFile? imageFile;

  Future<void> addBranch() async {
    emit(AddBranchLoading());
    if (formKey.currentState!.validate()) {
      var reponse = await repo.addBranch(
        branch: BrancheModel.createWithoutId(
          name: nameController.text,
          address: addressController.text,
          phone: phoneController.text,
          email: emailController.text,
        ),
      );
      reponse.fold(
        (error) => emit(
          AddBranchFailing(errMessage: error),
        ),
        (r) => emit(AddBranchSuccess(branch: r)),
      );
    } else {
      autovalidateMode = AutovalidateMode.always;
      emit(AddBranchUnVaild());
    }
  }

  @override
  Future<void> close() {
    nameController.dispose();
    addressController.dispose();
    return super.close();
  }

  @override
  void emit(AddBranchState state) {
    if (!isClosed) {
      super.emit(state);
    }
  }
}
