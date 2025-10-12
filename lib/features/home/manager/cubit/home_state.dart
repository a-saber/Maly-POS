part of 'home_cubit.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeLoading extends HomeState {}

final class HomeFailing extends HomeState {
  final ApiResponse errMessage;

  HomeFailing({required this.errMessage});
}

final class HomeSuccess extends HomeState {}
