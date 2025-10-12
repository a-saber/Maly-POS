part of 'search_client_cubit.dart';

@immutable
sealed class SearchClientState {}

final class SearchClientInitial extends SearchClientState {}

final class SearchClientLoading extends SearchClientState {}

final class SearchClientSuccess extends SearchClientState {}

final class SearchClientFailing extends SearchClientState {
  final ApiResponse errMessage;
  SearchClientFailing({required this.errMessage});
}

final class SearchClientFailingPagination extends SearchClientState {
  final ApiResponse errMessage;
  SearchClientFailingPagination({required this.errMessage});
}
