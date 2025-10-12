import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// ignore: depend_on_referenced_packages, unnecessary_import
import 'package:meta/meta.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/features/auth/login/data/repo/login_repo.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this.repo) : super(LoginInitial());

  final LoginRepo repo;

  static LoginCubit get(context) => BlocProvider.of(context);

  late TextEditingController emailController, passwordController;
  late GlobalKey<FormState> formKey;
  late AutovalidateMode autovalidateMode;
  late bool obscureText;

  void init() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    formKey = GlobalKey();
    autovalidateMode = AutovalidateMode.disabled;
    obscureText = true;
  }

  void changeObscureText() {
    obscureText = !obscureText;
    emit(ChangeObscureTextState());
  }

  void onTap() {
    emit(LoginLoading());
    if (formKey.currentState!.validate()) {
      repo
          .login(email: emailController.text, password: passwordController.text)
          .then((value) => value.fold(
                (error) => emit(LoginError(
                  errorMessage: error,
                )),
                (success) => emit(
                  LoginSuccess(
                    message: success,
                  ),
                ),
              ));
    } else {
      autovalidateMode = AutovalidateMode.always;
      emit(LoginUnvalidTextField());
    }
  }

  @override
  Future<void> close() {
    emailController.dispose();
    passwordController.dispose();
    return super.close();
  }
}
