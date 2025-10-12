part of 'login_cubit.dart';

@immutable
sealed class LoginState {}

final class LoginInitial extends LoginState {}

final class ChangeObscureTextState extends LoginState {}

final class LoginLoading extends LoginState {}

final class LoginSuccess extends LoginState {
  final ApiResponse message;

  LoginSuccess({required this.message});
}

final class LoginUnvalidTextField extends LoginState {}

final class LoginError extends LoginState {
  final ApiResponse errorMessage;

  LoginError({required this.errorMessage});
}
