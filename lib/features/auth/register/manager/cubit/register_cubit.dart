import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// ignore: unnecessary_import, depend_on_referenced_packages
import 'package:meta/meta.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/features/auth/register/data/repo/register_repo.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit(this.repo) : super(RegisterInitial());
  final RegisterRepo repo;
  static RegisterCubit get(context) => BlocProvider.of(context);

  late TextEditingController emailController,
      passwordController,
      confirmPasswordController,
      namecontroller,
      phonecontroller,
      addresscontroller,
      shopnamecontroller;
  late GlobalKey<FormState> formKey;
  late AutovalidateMode autovalidateMode;
  late bool passwordObscure;
  late bool confirmPasswordObscure;

  void init() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    namecontroller = TextEditingController();
    phonecontroller = TextEditingController();
    addresscontroller = TextEditingController();
    shopnamecontroller = TextEditingController();
    formKey = GlobalKey();
    autovalidateMode = AutovalidateMode.disabled;
    passwordObscure = true;
    confirmPasswordObscure = true;
  }

  void changePasswordObscure() {
    passwordObscure = !passwordObscure;
    emit(ChangeOnbscurePassword());
  }

  void changeConfirmPasswordObscure() {
    confirmPasswordObscure = !confirmPasswordObscure;
    emit(ChangeOnbscurePassword());
  }

  void onTap() async {
    emit(RegisterLoading());
    if (formKey.currentState!.validate()) {
      var response = await repo.register(
        email: emailController.text,
        password: passwordController.text,
        name: namecontroller.text,
        phone: phonecontroller.text,
        shopName: shopnamecontroller.text,
        address: addresscontroller.text,
      );
      response.fold(
          (error) => emit(RegisterError(
                errMessage: error,
              )),
          (success) => emit(RegisterSuccess(
                message: success,
              )));
    } else {
      autovalidateMode = AutovalidateMode.always;
      emit(RegisterUnvalidTextField());
    }
  }

  @override
  Future<void> close() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    namecontroller.dispose();
    phonecontroller.dispose();
    addresscontroller.dispose();
    shopnamecontroller.dispose();
    return super.close();
  }
}
