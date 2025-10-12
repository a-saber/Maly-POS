part of 'register_cubit.dart';

@immutable
sealed class RegisterState {}

final class RegisterInitial extends RegisterState {}

final class ChangeOnbscurePassword extends RegisterState {}

final class RegisterLoading extends RegisterState {}

final class RegisterSuccess extends RegisterState {
  final ApiResponse message;

  RegisterSuccess({required this.message});
}

final class RegisterUnvalidTextField extends RegisterState {}

final class RegisterError extends RegisterState {
  final ApiResponse errMessage;

  RegisterError({required this.errMessage});
}
