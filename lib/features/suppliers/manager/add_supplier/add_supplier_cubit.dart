import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'add_supplier_state.dart';
import '../../data/repo/suppliers_repo.dart';
import '../../data/models/supplier_model.dart';

class AddSupplierCubit extends Cubit<AddSupplierState> {
  final SuppliersRepo repo;

  AddSupplierCubit(this.repo) : super(AddSupplierInitial());
  static AddSupplierCubit get(context) => BlocProvider.of(context);

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  // final TextEditingController commercialRegisterController =
  //     TextEditingController();
  // final TextEditingController taxIdentificationNumberController =
  //     TextEditingController();
  // final TextEditingController noteController = TextEditingController();
  // XFile? image;
  Future<void> addSupplier() async {
    emit(AddSupplierLoading());

    if (formKey.currentState!.validate()) {
      final response = await repo.addSupplier(
        supplier: SupplierModel.createUserWIthoutId(
          name: nameController.text,
          email: emailController.text,
          phone: phoneController.text,
          address: addressController.text,
          // commercialRegister: commercialRegisterController.text,
          // taxIdentificationNumber: taxIdentificationNumberController.text,
          // note: noteController.text,
          // imagePath: image?.path
        ),
      );
      response.fold(
          (error) => emit(AddSupplierError(error)),
          (data) => emit(AddSupplierSuccess(
                supplier: data,
              )));
    } else {
      autovalidateMode = AutovalidateMode.always;
      emit(AddSupplierUnValidate());
    }
  }

  @override
  Future<void> close() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    // commercialRegisterController.dispose();
    // taxIdentificationNumberController.dispose();
    // noteController.dispose();
    return super.close();
  }
}
