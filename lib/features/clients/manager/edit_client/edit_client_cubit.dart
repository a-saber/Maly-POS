import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/features/clients/data/model/customer_model.dart';
import 'package:pos_app/features/clients/data/repo/clients_repo.dart';

part 'edit_client_state.dart';

class EditClientCubit extends Cubit<EditClientState> {
  EditClientCubit(this.repo, this.client) : super(EditClientInitial()) {
    nameController = TextEditingController(text: client.name);
    emailController = TextEditingController(text: client.email);
    phoneController = TextEditingController(text: client.phone);
    addressController = TextEditingController(text: client.address);
    // commercialRegisterController =
    //     TextEditingController(text: client.commercialRegister);
    // taxIdentificationNumberController =
    //     TextEditingController(text: client.taxIdentificationNumber);
    // noteController = TextEditingController(text: client.note);
  }

  static EditClientCubit get(context) => BlocProvider.of(context);

  final ClientsRepo repo;
  final CustomerModel client;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController addressController;
  // late TextEditingController commercialRegisterController;
  // late TextEditingController taxIdentificationNumberController;
  // late TextEditingController noteController;
  XFile? image;

  Future<void> editClient() async {
    emit(EditClientLoading());

    if (formKey.currentState!.validate()) {
      final response = await repo.editClient(
        client: CustomerModel(
          id: client.id,
          name: nameController.text,
          email: emailController.text,
          phone: phoneController.text,
          address: addressController.text,
          createdAt: null,
          updatedAt: null,
          // commercialRegister: commercialRegisterController.text,
          // taxIdentificationNumber: taxIdentificationNumberController.text,
          // note: noteController.text,
          // imagePath: image?.path,
        ),
      );
      response.fold(
        (error) => emit(EditClientFailing(errMessage: error)),
        (data) => emit(EditClientSuccess(
          customer: data,
        )),
      );
    } else {
      autovalidateMode = AutovalidateMode.always;
      emit(EditClientUnVaildate());
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
