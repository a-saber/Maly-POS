part of 'search_branch_cubit.dart';

@immutable
sealed class SearchBranchState {}

final class SearchBranchInitial extends SearchBranchState {}

final class SearchBranchLoading extends SearchBranchState {}

final class SearchBranchSuccess extends SearchBranchState {}

final class SearchBranchFailing extends SearchBranchState {
  final ApiResponse errMessage;
  SearchBranchFailing({required this.errMessage});
}

final class SearchBranchPaginationFailing extends SearchBranchState {
  final ApiResponse errMessage;
  SearchBranchPaginationFailing({required this.errMessage});
}
