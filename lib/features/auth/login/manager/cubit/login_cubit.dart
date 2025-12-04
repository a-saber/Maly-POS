import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:meta/meta.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/core/cache/cache_helper.dart';
import 'package:pos_app/features/auth/login/data/repo/login_repo.dart';

import '../../../../../core/cache/cache_keys.dart';
import '../../../../../core/widget/custom_dialog.dart';
import '../../view/widget/show_credentials_dialog.dart';


part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this.repo) : super(LoginInitial());

  final LoginRepo repo;

  static LoginCubit get(context) => BlocProvider.of(context);

  late TextEditingController emailController, passwordController;
  late GlobalKey<FormState> formKey;
  late AutovalidateMode autovalidateMode;
  late bool obscureText;
  late bool rememberMe;
  late bool showCredentials;

  void init() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    formKey = GlobalKey();
    autovalidateMode = AutovalidateMode.disabled;
    obscureText = true;
    rememberMe = true;
    showCredentials=true;

  }
  void onRememberMeChanged(bool? value) {
    rememberMe = !rememberMe;
    emit(ChangeRememberMeState());
  }


  void changeObscureText() {
    obscureText = !obscureText;
    emit(ChangeObscureTextState());
  }
  void onTapEmail(BuildContext context) async {
   if(!showCredentials) return;


    List credentials=   CacheHelper.getData(key:  CacheKeys.credential)??[];
    if(credentials.isNotEmpty){
      // emailController.text= credentials[0].split(":")[0];
      // passwordController.text= credentials[0].split(":")[1];
      CustomDialog.showDialogHelper(context, builder: CredentialsWidget(credentials: credentials,loginCubit: BlocProvider.of<LoginCubit>(context),),contentWidget: SizedBox());
    }
    emit(ChangeRememberMeState());


  }
  void onTapCredentials(String credential) {
     emailController.text= credential.split(":")[0];
     passwordController.text= credential.split(":")[1];
     showCredentials=false;
     emit(ChangeRememberMeState());
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
                (success) async { emit(
                  LoginSuccess(
                    message: success,
                  ),);
                  if(rememberMe){
                 await saveCredential();
                  }
                }
              ));
    } else {
      autovalidateMode = AutovalidateMode.always;
      emit(LoginUnvalidTextField());
    }
  }
  Future<void> saveCredential() async {
    String encodeToken = "${emailController.text}:${passwordController.text}";
     List<String> credentials=  await CacheHelper.getData(key:  CacheKeys.credential)??[];
     if(!credentials.contains(encodeToken)){
       credentials.add(encodeToken);
       await CacheHelper.saveData(key:  CacheKeys.credential, value: credentials);
     }



  }

  @override
  Future<void> close() {
    emailController.dispose();
    passwordController.dispose();
    return super.close();
  }
}
