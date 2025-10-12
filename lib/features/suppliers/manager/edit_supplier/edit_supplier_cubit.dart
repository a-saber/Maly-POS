import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'edit_supplier_state.dart';
import '../../data/repo/suppliers_repo.dart';
import '../../data/models/supplier_model.dart';

class EditSupplierCubit extends Cubit<EditSupplierState> {
  final SuppliersRepo repo;
  final SupplierModel supplier;
  EditSupplierCubit(this.repo, this.supplier) : super(EditSupplierInitial()) {
    nameController = TextEditingController(text: supplier.name);
    emailController = TextEditingController(text: supplier.email);
    phoneController = TextEditingController(text: supplier.phone);
    addressController = TextEditingController(text: supplier.address);
    // commercialRegisterController =
    //     TextEditingController(text: supplier.commercialRegister);
    // taxIdentificationNumberController =
    //     TextEditingController(text: supplier.taxIdentificationNumber);
    // noteController = TextEditingController(text: supplier.note);
  }
  static EditSupplierCubit get(context) => BlocProvider.of(context);

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController addressController;
  // late TextEditingController commercialRegisterController;
  // late TextEditingController taxIdentificationNumberController;
  // late TextEditingController noteController;
  // XFile? image;

  Future<void> editSupplier() async {
    if (!formKey.currentState!.validate()) return;

    // supplier.name = nameController.text;
    // supplier.email = emailController.text;
    // supplier.phone = phoneController.text;
    // supplier.address = addressController.text;
    // supplier.commercialRegister = commercialRegisterController.text;
    // supplier.taxIdentificationNumber = taxIdentificationNumberController.text;
    // supplier.note = noteController.text;
    // if (image != null) supplier.imagePath = image?.path;
    // emit(EditSupplierLoading());
    final result = await repo.editSupplier(
      supplier: SupplierModel.createUserWIthoutId(
        id: supplier.id,
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
    result.fold(
        (error) => emit(EditSupplierError(error)),
        (data) => emit(EditSupplierSuccess(
              supplier: data,
            )));
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
