part of 'language_control_cubit.dart';

@immutable
sealed class LanguageControlState {}

final class LanguageControlInitial extends LanguageControlState {}

final class LanguageChange extends LanguageControlState {}
