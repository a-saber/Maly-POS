import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/features/clients/data/model/customer_model.dart';
import 'package:pos_app/features/clients/data/repo/clients_repo.dart';

part 'add_client_state.dart';

class AddClientCubit extends Cubit<AddClientState> {
  AddClientCubit(this.repo) : super(AddClientInitial());
  static AddClientCubit get(context) => BlocProvider.of(context);
  final ClientsRepo repo;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController buildingController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController districtController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  // final TextEditingController commercialRegisterController =
  //     TextEditingController();
  // final TextEditingController taxIdentificationNumberController =
  //     TextEditingController();
  // final TextEditingController noteController = TextEditingController();
  XFile? image;

  Future<void> addClient() async {
    if (formKey.currentState!.validate()) {
      final reponse = await repo.addClient(
          client: CustomerModel.createWithoutId(
        name: nameController.text,
        email: emailController.text,
        phone: phoneController.text,
        address: addressController.text,
        street: streetController.text,
        building: buildingController.text,
        city: cityController.text,    
        district: districtController.text,
        country: countryController.text,
      ));
      reponse.fold(
          (error) => emit(AddClientFailing(errMessage: error)),
          (data) => emit(AddClientSuccess(
                customer: data,
              )));
    } else {
      autovalidateMode = AutovalidateMode.always;
      emit(AddClientNotValidate());
    }
  }

  @override
  Future<void> close() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    streetController.dispose();
    buildingController.dispose();
    cityController.dispose();
    districtController.dispose();
    countryController.dispose();
    // commercialRegisterController.dispose();
    // taxIdentificationNumberController.dispose();
    // noteController.dispose();
    return super.close();
  }
}
