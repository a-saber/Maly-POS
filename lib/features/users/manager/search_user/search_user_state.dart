part of 'search_user_cubit.dart';

@immutable
sealed class SearchUserState {}

final class SearchUserInitial extends SearchUserState {}

final class SearchUserLoading extends SearchUserState {}

final class SearchUserSuccess extends SearchUserState {}

final class SearchUserFailing extends SearchUserState {
  final ApiResponse errMessage;
  SearchUserFailing({required this.errMessage});
}

final class SearchUserPaginationFailing extends SearchUserState {
  final ApiResponse errMessage;
  SearchUserPaginationFailing({required this.errMessage});
}
